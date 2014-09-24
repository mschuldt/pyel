(defvar pyel-type-declaration-function '_pyel_declare_type_
  "name of the function that is used to communicate variable types
to the pyel translator.
Type declarations are replaced with a call to this function.")

(setq pyel-type-declaration-function2 '-pyel-declare-type-)

(set (defvar pyel-possible-types nil
       "list of all (built-in) types a variable can take")
       '(number
         list
         vector
         string
         object
         hash
         function
         func
         symbol
         vfunc
         class
         instance
         int
         float))

(setq known-types nil)

(defun pyel-force-list (thing)
  (if (or (null thing)
          (listp thing))
      thing
    (list thing)))

(defun pyel-get-possible-types (args)
  "return a list in the form (arg types).
  The car is the argument and the cdr is a list of possible types"

  (let* ((known-types (mapcar (lambda (x) (if (null x)
                                              pyel-possible-types
                                            x))
                              known-types))
         (len-known (length known-types))
         (len-args (length args))
         (types (if (>= len-known len-args)
                    known-types
                  (append known-types
                          (mapcar (lambda (_) pyel-possible-types)
                                  (number-sequence 1 (- len-args len-known))))))
         (args (filter (lambda (x) (not (or (eq x '&optional)
                                            (eq x '&rest)))) args)))

    (mapcar* (lambda (arg type)
               (cons arg type))
             args types)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;type environment object definition
;;fields:
;; parent: another environment
;; ht: a hash table that maps symbols to lists of types
(defconst pyel-env-array-len 2)
(defconst pyel-env-parent 0)
(defconst pyel-env-ht 1)

(defun pyel-make-type-env (&optional parent)
  (let ((a (vconcat (make-list pyel-env-array-len 0))))
    (aset a pyel-env-parent parent)
    (aset a pyel-env-ht (make-hash-table :test 'eq))
    a))

(defsubst pyel-env-get-ht (env)
  (aref env pyel-env-ht))
(defsubst pyel-env-get-parent (env)
  (aref env pyel-env-parent))
(defsubst pyel-env-get-grandparent (env)
  (pyel-env-get-parent (pyel-env-get-parent env)))
(defsubst pyel-env-set (sym val env)
  (puthash sym val (pyel-env-get-ht env)))
(defsubst pyel-env-set-parent (env parent)
  (aset env pyel-env-parent parent))

(defun pyel-env-get (sym env)
  "return a list of possible types for SYM in ENVironment"
  (let ((val (gethash sym (pyel-env-get-ht env)))
        parent)
    (if val
        val
      (if (setq parent (pyel-env-get-parent env))
          (pyel-env-get sym parent)))))

(defvar pyel-global-type-env (pyel-make-type-env)
  "global type environment used for type reconstruction")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;function type
;;  in type environments, function symbols get
;;  mapped to these function types

(defconst pyel-env-func:type 0)
(defconst pyel-env-func:args 1)
(defconst pyel-env-func:ret 2)

(defsubst pyel-make-func-type (func-type arg-type return-type)
  (vector func-type arg-type return-type))
(defsubst pyel-func-func-type (function-type)
  (aref function-type pyel-env-func:type))
(defsubst pyel-func-args-type (function-type)
  (aref function-type pyel-env-func:args))
(defsubst pyel-func-return-type (function-type)
  (aref function-type pyel-env-func:ret))
(defsubst pyel-is-func-type (type)
  (and (vectorp type) (= (length type) 3)))
(defsubst pyel-change-to-vfunc-type (type)
  (let ((new (vconcat type)))
    (aset new pyel-env-func:type 'vfunc)
    new))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;class type
;;  in type environments, object name symbols get
;;  mapped to these types
(defconst pyel-env-class:name 0)
(defconst pyel-env-class:env 1)
(defconst pyel-env-class:attrs 2)
(defconst pyel-env-class:supers 3)

(defconst pyel-env-class-length 5)

(defsubst pyel-make-class-type (object-name type-env)
  ;;forth elem exists to make the length 4.
  ;;This allows `pyel-is-class-type' to just check the length
  (vector object-name ;;name of class
          type-env  ;;type-env it was defined in
          (make-hash-table :test 'eq) ;;attribute--type mapping
          nil ;; list of super classes
          nil))
(defsubst pyel-class-type-name (obj-type)
  (aref obj-type pyel-env-class:name))
(defsubst pyel-class-type-env (obj-type)
  (aref obj-type pyel-env-class:env))
(defsubst pyel-class-type-supers (obj-type)
  (aref obj-type pyel-env-class:supers))
(defsubst pyel-class-type-set-supers (obj-type supers)
  (aset obj-type pyel-env-class:supers
        (append supers (aref obj-type pyel-env-class:supers))))

;;attributes that can take on any time are mapped to the symbol 'all'
(defsubst pyel-class-type-set-attr (obj-type attr val)
  (puthash attr (if (null val) 'all val) (aref obj-type pyel-env-class:attrs)))

(defun _pyel-class-type-get-attr (obj-type attr)
  ;;this returns the type value as stored in the attr--type mapping
  ;;so if the name maps to any type then 'all is returned
  (let ((val (gethash attr (aref obj-type pyel-env-class:attrs)))
        supers found)
    (when (not val)
      ;;check super classes
      (setq supers (aref obj-type pyel-env-class:supers)
            val nil)
      (while (and (not found) supers)
        (setq val (pyel-class-type-get-attr (car supers) attr))
        (if val
            (setq found t)
          (setq supers (cdr supers)))))
    val))

(defsubst pyel-class-type-get-attr (obj-type attr)
  (let ((val (_pyel-class-type-get-attr obj-type attr)))
    (if (eq val 'all)
        nil
      val)))

(defsubst pyel-class-type-has-attr (obj-type attr)
  (not (null (_pyel-class-type-get-attr obj-type attr))))

(defsubst pyel-is-class-type (type)
  (and (vectorp type) (= (length type) pyel-env-class-length)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;instance type
;;the only field contains name of the instance in form <classname><instance num>
(defconst pyel-env-inst:class 0)
(defconst pyel-env-inst:env 1)
(defconst pyel-env-inst:attrs 2)

(defconst pyel-env-inst-length 4)

(defsubst pyel-make-instance-type (object type-env)
  (vector object ;;object type
          type-env ;;create here
          nil ;;alist of attributes. Form: (name . type)
          nil))
(defsubst pyel-instance-type-class (obj-type)
  (aref obj-type pyel-env-inst:class))
(defsubst pyel-instance-type-env (obj-type)
  (aref obj-type pyel-env-inst:env))
(defsubst pyel-instance-type-get-attrs (obj-type)
  (aref obj-type pyel-env-inst:attrs))
(defsubst pyel-is-instance-type (type)
  (and (vectorp type)
       (= (length type) pyel-env-inst-length)))

(defsubst pyel-iter-type-set-attr (obj-type attr type)
  (aset obj-type pyel-env-inst:attrs
        (cons (cons attr type) (aref obj-type pyel-env-inst:attrs))))

(defun pyel-iter-type-get-attr (obj-type attr)
  (let ((val (assoc attr (aref obj-type pyel-env-inst:attrs))))
    (if val
        (cdr val)
      ;;check the class
      (pyel-class-type-get-attr (aref obj-type pyel-env-inst:class) attr))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defsubst pyel-is-object-type (type)
  (and (vectorp type) (or (= (length type) pyel-env-class-length)
                          (= (length type) pyel-env-inst-length))))

(defsubst pyel-type-get-attr (obj attr)
  (if (pyel-is-instance-type obj)
      (pyel-iter-type-get-attr obj attr)
    (pyel-class-type-get-attr obj attr)))

(defsubst pyel-type-set-attr (obj attr val)
  (if (pyel-is-instance-type obj)
      (pyel-iter-type-set-attr obj attr val)
    (pyel-class-type-set-attr obj attr val)))

(defsubst pyel-object-type-name (type)
  (if (pyel-is-instance-type type)
      (pyel-instance-type-name type)
    (pyel-class-type-name type)))

;;creates a key for the class/instance attribute to type mapping
(defun pyel-env-attr-key (class attr)
  (intern (concat (symbol-name class) ":" (symbol-name attr))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro pyel-declare-el-func (name returns)
  `(pyel-declare-el-func-fn ',name ',returns))

(defun pyel-declare-el-func-fn (name returns)
  (assert (symbolp name) "FUNCTION name must be a symbol")
  ;;TODO: check that RETURNS is valid
  (setq returns (if (or (eq returns 'any)
                        (eq returns nil))
                    pyel-possible-types
                  returns))
  (pyel-env-set name
                (pyel-make-func-type 'function nil returns)
                pyel-global-type-env))

;;;;;;

(ert-deftest pyel-test-type-env ()
  (should
   (let* ((env (pyel-make-type-env))
          o i)
     (pyel-env-set 'superclass (pyel-make-class-type 'superclass env) env)
     (setq o (pyel-env-get 'superclass env))
     (pyel-env-set 'classname (pyel-make-class-type 'classname env) env)
     (pyel-class-type-set-supers (pyel-env-get 'classname env) (list o))

     (pyel-env-set 'instname (pyel-make-instance-type (pyel-env-get 'classname env)
                                                      env) env)
     (setq i (pyel-env-get 'instname env))

     (pyel-type-set-attr (pyel-env-get 'instname env) 'instattr 'string)
     (pyel-type-set-attr (pyel-env-get 'classname env) 'classattr 'number)
     (pyel-type-set-attr (pyel-env-get 'superclass env) 'superattr 'list)

     (and
      (pyel-is-object-type o)
      (pyel-is-object-type i)
      (eq (pyel-type-get-attr (pyel-env-get 'instname env) 'instattr)
          'string)
      (eq (pyel-type-get-attr (pyel-env-get 'instname env) 'classattr)
          'number)
      (eq (pyel-type-get-attr (pyel-env-get 'instname env) 'superattr)
          'list)
      (eq (pyel-type-get-attr (pyel-env-get 'classname env) 'instattr)
          nil)
      (eq (pyel-type-get-attr (pyel-env-get 'classname env) 'classattr)
          'number)
      (eq (pyel-type-get-attr (pyel-env-get 'classname env) 'superattr)
          'list)
      (eq (pyel-type-get-attr (pyel-env-get 'superclass env) 'instattr)
          nil)
      (eq (pyel-type-get-attr (pyel-env-get 'superclass env) 'classattr)
          nil)
      (eq (pyel-type-get-attr (pyel-env-get 'superclass env) 'superattr)
          'list)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; function declarations

;;currently a type of nil is treated as unknown and will be treated
;;as every possible type, so it is equivalent to a type of 'any'
;;They are treated separately here in case things should change
;;in the future

(mapc (lambda (f)
        (pyel-declare-el-func-fn f nil))
      ;;returns nil (?)
      '(pyel-eval-extra-generated-code
        switch-to-buffer-other-window  ;;buffer
        erase-buffer
        lisp-interaction-mode
        pyel-prettyprint
        goto-char
        backward-char
        forward-char
        backward-sexp
        forward-sexp
        provide))

(mapc (lambda (f)
        (pyel-declare-el-func-fn f 'string))
      ;;returns string
      '(concat
        substring
        buffer-substring
        buffer-substring-no-properties
        buffer-string))

(mapc (lambda (f)
        (pyel-declare-el-func-fn f 'number))
      ;;return number
      '(length
        point
        random))

(mapc (lambda (f)
        (pyel-declare-el-func-fn f 'bool))
      ;;returns bool
      '(looking-at
        bobp eobp
        bolp eolp))

(mapc (lambda (f)
        (pyel-declare-el-func-fn f 'any))
      ;;returns any
      '(car cdr cadr cddr cdar
            thing-at-point ;;?)
            first last
            nth
            quote
            aref aset))

(pyel-declare-el-func-fn 'pyel-buffer-to-lisp 'list)
(pyel-declare-el-func-fn 'pyel 'list)

(provide 'pyel-type-reconstruction)
