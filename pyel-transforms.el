
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

(make-transform-table 'pyel)

;; should not fset functions because the effect takes place globally
;; even when the name being set is let bound.
(pyel-dispatch-func set (_sym _val)
                    ;;NOTE: if is changed, `setter-functions' 
                    ;; may need to be updated
                    (_ $function) -> (setq $sym $$val)
                    (_ _) -> (setq $sym $val)) ;;TODO: other?

(def-transform assign pyel ()
  (lambda (targ val &optional line col) (py-assign targ val line col)))

;;TODO: put all setq's in a single form: (setq a 1 b 2) etc

(defun py-assign (targets values &optional line col)

  (let ((wrap-values t)
        unpack i)
    ;;make sure targets and lists are both in a list form
    ;;the 'unpack' flag is needed because it leaves no difference
    ;;between a,b=c and a=b=c
    (if (and (listp (car targets))
             (eq (caar targets) 'tuple))
        (progn

          (if (eq (car values) 'tuple)
              (progn

                (setq values (cadr values))
                (setq wrap-values nil))
            (setq unpack t) ;;targets is a tuple and values is not
            ;;(setq values (list values))
            )

          (setq targets (cadar targets)))
      )

    (when wrap-values
      (setq values (list values)))


    ;;py-sssign2 does the main transforms
    ;;TODO: check for the special case a,b=b,a and create temp variables
    ;;TODO: check that legnth of the lists are the same

    ;;TODO:
    (cond (unpack
           ;;TODO: pyel error unless: (and (> (length targets) 1)  (= (length values) 1)

           (let ((code '(@)))
             `(let ((__value__ ,(transform (car values))))

                ,(dotimes (i (length targets) (reverse code))
                 ;;;TODO: will have to help the transform know what type __value__ is
                   (push (py-assign2 (nth i targets)

                                     (pyel-make-ast 'subscript '__value__ i 'load))
                         code))
                )))

          ((= (length targets) 1)
           ;;form: a=b
           (py-assign2 (car targets)
                       (car values))) ;;if this is the second call of a "a,b = c" type form, then the ctx of values will be store instead of load which leads to an error

          ;;form: a = b = c
          ((and (> (length targets) 1) (= (length values) 1))
           ;; (list '@ (py-assign2 (car (last targets)) (car values))
           ;;          (py-assign  (butlast targets)
           ;;                      (pyel-change-ctx (car (last targets)) 'load))))
           (let ((out (py-assign2 (car (last targets)) (car values))))
             (setq values (car (last targets))
                   targets (butlast targets))
             (while targets
               (setq out (py-assign2 (car (last targets)) out)
                     targets (butlast targets)))
             out))


          ;;form: a,b = x,y
          (t (let* ((tmp-vars (loop for i from 1 to (length targets)
                                    collect (intern (format "__%s__" i))))
                    (let-vars (mapcar* (lambda (a b)
                                         (list a (transform b)))
                                       tmp-vars values)))
               `(let ,let-vars
                  ,(cons '@ (mapcar* 'py-assign2 targets tmp-vars))))))))

;;DOC: tranforms must be carefull not to transform code multiple times

(defun py-assign2 (target value)
  ;;access line and col values from `py-assign' calling env.
  (let ((ctx (eval (car (last target))))

        (assign-value value))


    ;;the target code is responsible for providing the correct assign function
    ;;

    ;;TODO:     is context-value still used?
    ;; (using-context assign-target
    ;;             (setq t-target (transform target)))
    ;; (using-context assign-value
    ;;             (setq t-value (transform value)))

    ;;The target transform is responsible for generating the code
    ;;The value being assigned to the target is available to the
    ;;target transform via the variable 'assign-value'.
    ;;'assign-value' is untransformed, the target transform must tranform it.

    ;; (using-context assign-value
    ;;             (setq assign-value (transform value)))
    ;;problem: code was being transformed multiple times
    (setq assign-value value)
    (using-context assign-target
                   (transform target))
    ;;    (list assign-func t-target t-value)

    ))

(def-transform attribute pyel ()
  (lambda (value attr ctx &optional line col)
    (pyel-attribute value attr ctx line col)))

(defun pyel-attribute (value attr ctx &optional line col)
  (setq ctx (cond ((context-p 'force-load) 'load)
                  ((context-p 'force-store) 'store)
                  (t (eval ctx))))
  (let ((t-value (transform value))
        (attr (read (_to- (transform attr))))
        ret obj-type obj-name)

    ;; ;;create slot for this attribute if it does not already exist
    ;; (when (and (context-p 'method-def)
    ;;            (not (assoc attr class-def-slots)))
    ;;   (push `(,attr :initarg ,(intern (concat ":"
    ;;                                           (symbol-name attr)))
    ;;                 :initform nil)

    ;;         class-def-slots))
    (if (and (context-p 'method-call)
             (not (context-p 'method-call-override)))
        (using-context method-call-override
                       ;;ctx?
                       `(@ call-method ,(transform value) ,attr))

      ;; (if (context-p 'assign-target)
      ;;          (setq assign-func 'oset))

      ;;check the presumption:
      (when (and (eq ctx 'store)
                 (not (context-p 'assign-target))
                 nil);;for this to work, this function need to set context as well
        (error "`pyel-attribute': Presumption failed: ctx==store but not in assign context"))
      (when (and (eq ctx 'store)
                 (not (boundp 'assign-value)))
        (error "`pyel-attribute': Presumption failed: ctx==store but assign-value is unbound"))

      (cond
       ((eq ctx 'store)
        (using-context return-type?
                       (setq ret (list 'setattr t-value attr
                                       (transform assign-value))))
                                        ;(setq return-type nil)

        (if (setq obj-type (pyel-env-get t-value type-env))
            (if (pyel-is-object-type obj-type)
                (pyel-type-set-attr obj-type attr return-type)
              ;;TODO:? make a new object?
              (pyel-env-set t-value nil type-env)))
        
        ;;(list 'oset t-value attr (transform assign-value)) ;;assign target
        ret)

       ((eq ctx 'load) ;;assign value
        ;;(list 'oref t-value attr)

        (setq return-type
              (if (and (setq obj-type (pyel-env-get t-value type-env))
                       (pyel-is-object-type obj-type))
                  (pyel-type-get-attr obj-type attr)))

        (list 'getattr t-value attr))
       (t (error "Error in attribute-- invalid ctx")))
      )))

(def-transform num pyel ()
  (lambda (n &optional line col)
    (if (context-p 'return-type?)
        (setq return-type 'number))
    n))

(def-transform name pyel ()
  (lambda (id ctx &optional line col)
    (pyel-name id ctx line col)))

(defun pyel-name (id ctx &optional line col)
  (let ((new-id)
        (id (read id))
        piece code
        value)

    ;;TODO: id should be string. verify?
    (setq ctx (cond ((context-p 'force-load) 'load)
                    ((context-p 'force-store) 'store)
                    (t (eval ctx))))


    (if (assoc id pyel-marked-ast-pieces)
        ;;this id is a marker, insert the corresponding macro
        (progn
          (setq piece (assoc id pyel-marked-ast-pieces))
          ;;'piece' has form: (marker macro-name macro-body)
          (using-context macro-call
                         (list (second piece)
                               (pyel-transform-ast (third piece) :nosplice))))

      ;;else: normal name
      (setq id (_to- id))
      (when (and (context-p 'assign-value) ;;checking assumption
                 (not (equal ctx 'load)))
        (error (format "In transform name: context is 'assign-value' but ctx is not 'load'.
          ctx = %s" ctx)))
      (if (context-p 'return-type?)
          (setq return-type (pyel-env-get id type-env)))
      
      (when (and (not (context-p 'function-call))
                 (not (context-p 'get-annotation))
                 (setq new-id (assoc id pyel-variable-name-translations)))
        (setq id (cadr new-id)))

      (when (and (eq ctx 'store)
                 (context-p 'function-def)
                 (context-p 'assign-target))
        (add-to-list 'let-arglist id))

      (cond
       ((eq ctx 'load) id)
       ((eq ctx 'store)  (if (context-p 'for-loop-target)
                             id
                           (setq value (using-context return-type?
                                                      (transform assign-value)))
                           (pyel-env-set id return-type type-env)
                           (setq known-types (list nil (list return-type)))
                           (call-transform-no-trans 'set id value)))
       (t  "<ERROR: name>"))
      )))

(def-transform list pyel ()
  (lambda (elts ctx &optional line col)
    (pyel-list elts ctx line col)))

(defun pyel-list (elts ctx &optional line col)  ;;IGNORING CTX
  (let ((transformed (mapcar 'transform elts)))
    (if (context-p 'return-type?)
        (setq return-type 'list))
    (if (context-p 'macro-call)
        transformed
      (cons 'list transformed))))

(defvar pyel-dict-test 'equal "Test function for dictionaries")

(def-transform dict pyel ()
  (lambda (keys values &optional line col)
    (pyel-dict keys values line col)))

(defun pyel-dict (keys values line col) ;;TODO: move to lambda in template and create template vars
  (let ((ret (cons 'py-dict (mapcar* (lambda (key value)
                                       (list key value))
                                     (mapcar 'transform  keys)
                                     (mapcar 'transform  values)))))
    (if (context-p 'return-type?)
        (setq return-type 'hash))
    ret))

(def-transform tuple pyel ()
  (lambda (elts ctx &optional line col) ;;Ignoring ctx for now
    (let ((transformed (mapcar 'transform elts)))
      (if (context-p 'return-type?)
          (setq return-type 'vector))
      (cons 'vector transformed))))

(def-transform str pyel ()
  (lambda (s &optional line col)
    ;;    (format "\"%s\"" s)
    (if (context-p 'return-type?)
        (setq return-type 'string))
    s))

(def-transform compare pyel ()
  (lambda (left ops comparators &optional line col)
    ;;what if comparators has multiple items?
    (pyel-compare left ops comparators :outer line col)))

;;TODO: assign comparators to temp variables to prevent repeated evaluation
(defun pyel-compare (left ops comparators &optional outer line col)
  ;;if outer is non-nil, then we use 'and' to combine the seporate tests
  (if (> (length ops) 1)
      (list (if outer 'and '@)
            (pyel-compare left (list (car ops)) (list (car comparators)))
            (pyel-compare (car comparators) (cdr ops) (cdr comparators)))
    
    (call-transform (read (car ops)) left (car comparators))))

(pyel-dispatch-func == (l r)
                    (number number) -> (= l r)
                    (string string) -> (string= l r)
                    ;;                       (object _) -> (--eq-- l r)
                    
                    (_ _) -> (equal l r))

(pyel-dispatch-func > (l r)
                    (number number) -> (> l r)
                    ;;TODO: macro for this
                    (string string) -> (pyel-string> l r)
                    (list list) -> (pyel-list-> l r)
                    (object _) -> (call-method l --gt-- r)
                    (vector vector) -> (pyel-vector-> l r)
                    )

;;TODO: other py types?

;;::Q does `string<' behave like < for strings in python?
(pyel-dispatch-func < (l r)
                    (number number) -> (< l r)
                    (string string) -> (string< l r)
                    (list list) -> (pyel-list-< l r)
                    (object _) -> (call-method l --lt-- r)
                    (vector vector) -> (pyel-vector-< l r))

(pyel-dispatch-func >= (l r)
                    (number number) -> (>= l r)
                    (string string) -> (pyel-string>= l r)
                    (list list)     ->  (pyel-list>= l r)
                    (object _) -> (call-method l --ge-- r)
                    (vector vector) -> (pyel-vector->= l r))

(pyel-dispatch-func <= (l r)
                    (number number) -> (<= l r)
                    (string string) -> (pyel-string<= l r)
                    (list list)     -> (pyel-list<= l r)
                    (object _) -> (call-method l --le-- r)
                    (vector vector) -> (pyel-vector-<= l r))

(pyel-dispatch-func != (l r)
                    (number number) -> (pyel-number!= l r)
                    (string string) -> (pyel-string!= l r)
                    (object _) -> (call-method l --ne-- r)
                    (_ _) -> (!equal l r))

;;this is defined as a transform because `pyel-compare' expects
;;all comparison functions to be transforms
(pyel-dispatch-func is (l r)
                    (_ _) -> (eq l r))

(def-transform if pyel ()
  (lambda (test body orelse &optional line col)
    (pyel-if test body orelse line col)))

(defun pyel-if (test body orelse &optional line col)
  (let* ((tst (transform test))
         true-type false-type trans
         (true-body
          (if (> (length body) 1)
              (append (remove-context
                       ;;(tail-context return-type)
                       tail-context
                       (mapcar 'transform
                               (or (subseq body 0 -1)
                                   (list (car body)))))
                      (using-context
                       return-type?
                       (setq trans (list (transform (car (last body))))
                             true-type return-type)
                       trans))
            (using-context return-type?
                           (setq trans (mapcar 'transform body)
                                 true-type return-type)
                           trans)))
         (false-body
          (if (> (length orelse) 1)
              (append (remove-context
                       ;;(tail-context return-type)
                       tail-context
                       (mapcar 'transform
                               (or (subseq orelse 0 -1)
                                   (list (car orelse)))))
                      (using-context
                       return-type?
                       (setq trans (list (transform (car (last orelse))))
                             false-type return-type)
                       trans))
            (using-context return-type?
                           (setq trans (mapcar 'transform orelse)
                                 false-type return-type)
                           trans))) 
         (progn-code (if (> (length true-body) 1)
                         '(@ progn)
                       '@)))
    
    (setq return-type (if (equal true-type false-type)
                          true-type
                        (list true-type false-type)))
    `(if ,(if (equal tst []) nil tst)

         (,progn-code ,@true-body)
       ,@false-body)))

(defvar pyel-obj-counter 0)

(defun pyel-next-obj-name ()
  (if pyel-unique-obj-names
      (format "obj-%d" (setq pyel-obj-counter (1+ pyel-obj-counter)))
    "obj"))

;; (pyel-dispatch-func fcall (_func &rest args)
;;                      ($func _) -> ($func ,@args)
;;                      (_ _) -> (funcall $func ,@args))

;; functions set to variables override those defined with `defun'
;; this allows locally defined functions to override their global
;; counterparts without defining themselves globally
(pyel-dispatch-func fcall (_func &rest _args)
                    ($list _) 
                    (vfunc _) -> (funcall $func ,@(pyel-sort-kwargs args))
                    ;;($function _) -> ($func ,@(pyel-sort-kwargs args))
                    (class _) -> (call-method $func --new--
                                              ,@(pyel-sort-kwargs args))

                    (instance _) -> (call-method $func --call--
                                                 ,@(pyel-sort-kwargs args))
                    (_ _) -> ($func ,@(pyel-sort-kwargs args))
                    )

(def-transform keyword pyel ()
  (lambda (arg value &optional line col)
    (if (context-p 'keywords-alist)
        (list (_to- arg) (transform value))
      (list '@ (_to- arg)  '= (transform value)))))

(def-transform call pyel ()
  ;;TODO: some cases funcall will need to be used, how to handle that?
  (lambda (func args keywords starargs kwargs &optional line col)
    (pyel-call-transform func args keywords starargs kwargs line col)))

(defun pyel-call-transform (func args keywords starargs kwargs &optional line col)
  (let* ((is-method-call (eq (car func) 'attribute))
         (t-func (using-context return-type?
                                (using-context function-call
                                               (transform func))))
         new-func
         (name t-func);;original name before (possible) translation
         ;;check if this function name needs to be translated         
         (t-func (if (and (not is-method-call)
                          (setq new-func (assoc t-func
                                                pyel-function-name-translations)))
                     (cadr new-func)
                   t-func))
          
         (function-type (cond ((pyel-is-func-type return-type)
                               (pyel-func-func-type return-type))
                              ((pyel-is-class-type return-type)
                               '(class))
                              ((pyel-is-instance-type return-type)
                               '(instance))))
        (function-type (if (listp function-type)
                           function-type
                         (list function-type)))
        (this-return-type return-type)
        
        (keyword-args (using-context keywords-alist
                                     (mapcar (lambda (x) (transform (car x)))
                                             keywords)))
        (t-args-quoted (mapcar (lambda (x)
                                 (list 'quote (transform x)))
                               args))
        (known-types known-types)
        new-func m-name f-name star-args kw-args ret this-return)

    ;; (if (member t-func pyel-defined-classes)
    ;;     ;;instantiate an object and call its initializer
    ;;     `(let ((__c (,t-func ,(pyel-next-obj-name))))
    ;;        (--init-- __c ,@(mapcar 'transform args))
    ;;        __c)

    (if (eq t-func pyel-type-declaration-function2)
        ;;declare variable type, return nothing
        (progn
          (assert (= (length args) 2) "type declaration function requires 2 args")
          (pyel-env-set (transform (car args)) (transform (cadr args)) type-env)
          pyel-nothing)
      ;;else: normal function/method call
      (setq known-types
            (mapcar (lambda (arg)
                      (setq type (if (symbolp arg)
                                     (pyel-env-get arg type-env)
                                   (using-context return-type?
                                                  (transform arg))
                                   return-type))
                      (cond ((pyel-is-func-type type)
                             (setq type (pyel-func-return-type type)))
                            ((pyel-is-class-type type)
                             (setq type '(class)))
                            ((pyel-is-instance-type type)
                             (setq type '(instance)))
                            ((null type)
                             ;;if type is not known, it could be anything
                             (setq type pyel-possible-types)))
                      ;;type for each arg must be a list
                      (if (listp type)
                          type
                        (list type)))
                    args))

      (setq return-type this-return-type)

      (if is-method-call
          (if (and (member (setq m-name (read (caddr func)))
                           pyel-method-transforms)
                   (setq m-name (pyel-find-method-transform-name
                                 m-name
                                 (1+ (length args)))));;1+ because args does not include the object

              ;;this methods transform is overridden
              (progn
                (setq known-types (cons function-type known-types))
                ;;dynamic scoping saves the day again!
                (setq keyword-args keywords
                      star-args starargs
                      kw-args kwargs
                      ret (eval `(call-transform-no-trans
                                  ',m-name
                                  ',(transform (cadr func))
                                  ,@t-args-quoted))
                      return-type this-return-type)
                ret)
            ;;normal method call
            (remove-context
             method-call-override
             (setq ret (using-context
                        method-call
                        `(,(transform func) ,@(remove-context
                                               method-call
                                               (mapcar 'transform args))))
                   return-type this-return-type)
             ret))

        ;;call function transform if one was defined
        (cond ((and keyword-args
                    (member t-func pyel-func-kwarg-transforms))
               ;;transform defined with `pyel-func-kwarg-transform'
               (setq ret (eval `(call-transform-no-trans
                                 ',(pyel-func-transform-name t-func t)
                                 ',keyword-args
                                 ,@t-args-quoted))
                     return-type this-return-type)
               ret)

              ((member t-func pyel-func-transforms)
               ;;transform defined with `pyel-func-transform'
               (setq ret (eval `(call-transform-no-trans
                                 ',(pyel-func-transform-name t-func)
                                 ,@t-args-quoted))
                     return-type this-return-type)
               ret)

              ((member t-func pyel-func-transforms2)
               ;;transform defined with `pyel-define-function-translation'
               (setq ret (eval `(call-transform-no-trans
                                 ',(pyel-func-transform-name t-func)
                                 ;;,(mapcar '(lambda (x) `(quote ,x)) args)
                                 (mapcar 'transform args) ;;?
                                 keyword-args))
                     return-type this-return-type))

              ;;normal function call
              ;;`(,t-func ,@(mapcar 'transform args))
              ;;TODO: this is dumb, convert `call-transform' to a macro?
              (t (if (context-p 'return-type?)
                     (setq this-return (pyel-env-get name type-env)
                           this-return (cond ((pyel-is-func-type this-return)
                                              (pyel-func-return-type this-return))
                                             ((pyel-is-class-type this-return)
                                              (pyel-make-instance-type
                                               this-return type-env))
                                             (t this-return))))
                 (setq known-types (cons function-type known-types)
                       _known-types known-types
                       ret (eval `(call-transform-no-trans
                                   'fcall ,@(cons 't-func
                                                  (append
                                                   t-args-quoted
                                                   (mapcar (lambda (x)
                                                             (list 'quote
                                                                   (transform x)))
                                                           (mapcar 'car
                                                                   keywords))))))
                       return-type this-return)
                 ret))))))

(def-transform while pyel ()
  (lambda (test body orelse &optional line col)
    (pyel-while test body orelse line col)))

;;doc: context macro-call
(defun pyel-while (test body orelse &optional line col)
  ;;pyel-while is special. it gets to handle the macro definitions
  (let* ((tst (transform test))
         (else (mapcar 'transform orelse))
         break-code
         continue-code
         macro-name
         t-body
         t-last
         break-code
         continue-code
         wile
         ;;inter-transform variables
         continue-while
         break-while )

    (if (and (symbolp tst)
             (string-match (format "^%s\\([A-Za-z0-9_]+\\)$" pyel-py-macro-prefix)
                           (symbol-name tst)))
        (using-context
         macro-call
         ;;expand as a macro call
         `(,(intern (replace-regexp-in-string "_" "-"
                                              (match-string 1 (symbol-name tst))))
           ;;TODO: if macro name is an alias, replace with actual
           ,@(mapcar 'transform body)))

      ;;expand as a normal while loop
      (using-context
       while

       (setq code (remove-context tail-context (mapcar 'transform body))
             ;;^ no tail calls from while loop
              ;; t-body (remove-context tail-context
              ;;                        (mapcar 'transform (subseq body 0 -1)))
              ;; t-last (transform (car (last body)))
              ;; code (append t-body (list t-last))


             break-code (if break-while '(catch '__break__)
                          pyel-nothing)
             continue-code (if continue-while '(catch '__continue__)
                             pyel-nothing)
             wile `(,@break-code
                    (while
                        ,(if (equal tst []) nil tst)
                      (,@continue-code
                       ,@code)))))
      (if else
          `(@ ,wile ,@else)
        wile))))

(def-transform arguments pyel ()
  (lambda (args vararg varargannotation kwonlyargs kwarg kwargannotation
                defaults kw_defaults)
    (pyel-arguments args vararg varargannotation kwonlyargs kwarg kwargannotation
                    defaults kw_defaults)))

(defun pyel-arguments (args vararg varargannotation
                            kwonlyargs kwarg kwargannotation
                            defaults kw_defaults)
  ;;TODO: other args

  (let* ((_args args);;save for annotations
         (args (mapcar 'transform args))
         (positional args)
         (defaults (mapcar 'transform defaults))
         annotations)

    ;;&optional
    (when defaults
      (setq defaults (reverse (mapcar* (lambda (arg default)
                                         (setq arg (_to- arg))
                                         (cons arg default))
                                       (reverse args) (reverse defaults))))
      (setq args (append (subseq args 0 (- (length args) (length defaults)))
                         '(&optional)
                         defaults)))

    ;;&rest
    (when vararg
      (setq args (append args (list '&rest vararg)))
      (when (and (not pyel-use-list-for-varargs)
                 (context-p 'function-def))
        (push `(setq, vararg (vconcat ,vararg)) assign-defaults)))

    ;;&kwonly
    (when kwonlyargs
      (setq args (append args (cons '&kwonly
                                    (mapcar* 'cons
                                             (mapcar 'transform kwonlyargs)
                                             (mapcar 'transform kw_defaults))))))
    
    ;;&kwarg
    (when kwarg
      (setq args (append args (list '&kwarg kwarg))))

    ;;type annotations
    (when (context-p 'function-def)
      (mapcar* (lambda (arg type)
                 ;;TODO: verify correct type
                 (pyel-env-set arg type type-env)
                 (push type annotations))
               positional
               (using-context get-annotation
                              (mapcar 'transform _args)))
      ;; 'function-name', 'function-type',  and 'type-of-return' are set
      ;; by the 'return' transform.
      (setq return-type (pyel-make-func-type function-type
                                             (reverse annotations)
                                             type-of-return))
      (if function-name
          (pyel-env-set function-name 
                        return-type
                        (pyel-env-get-parent type-env))))
    args))

(def-transform arg pyel ()
  (lambda (arg annotation)
    (setq _x annotation)
    (if (context-p 'get-annotation)
        (transform annotation)
      (read arg))))

(def-transform def pyel ()
  (lambda (name args body decoratorlist returns &optional line col)
    (pyel-def name args body decoratorlist returns line col)))

(defun transform-last-with-context (context code)
  ;;TODO: this does not work: fix and replace code in `pyel-def
  (let*  ((last-line (using-context context
                                    (transform (car (last code)))))
          (first (mapcar 'transform (subseq code 0 (1- (length code))))))
    (append first (list last-line))))

(defun pyel-def (name args body decoratorlist returns &optional line col)
  (let ((name (if (null name) name (read (_to- name)))))

    ;;when 'name' is nil, define an anonymous function
    (when (and (context-p 'function-def)
               (not (null name)))
      (push name let-arglist)) ;;do this before the let-arglists gets overridden for this transform

    (let* ((inner-defun (and (context-p 'function-def)
                             (not (null name))))
           (function-name name)
           (function-type (if (or inner-defun (context-p 'lambda-def))
                              'vfunc 'func))
           (type-of-return (using-context get-annotation (transform returns)))
           ;;'return-type', 'function-name', and 'function-type,
           ;; are used to pass values to the 'arguments' transform
           (type-env (pyel-make-type-env type-env))
           ;;NOTE: the 'arguments' transform is responsible for setting
           ;;the type values of the parameters in this new 'type-env'
           ;;The 'arguments' transform also maps the function name to
           ;;its argument and parameter types in the parent of this 'type-env'
           
           (func 'def)
           t-body
           arglist
           first
           last-line

           ;;trans-template vars
           (assign-defaults (list pyel-nothing));;holds assignment code set by the arguments transform
           return-middle
           let-arglist
           global-vars
           docstring
           interactive

              ;;;
           (ret pyel-nothing)
           (args (_to- (using-context function-def (transform (car args)))))
           (arg-names (mapcar (lambda (x) (if (consp x) (car x) x)) args))
           (this-return return-type) ;;return-type set by the argument transform
           (orig-name name)
           (decorators (mapcar 'transform decoratorlist))
           setq-code first-arg-name
           )

      (setq _env type-env)

      (when (or (null name)
                (context-p 'lambda-def)
                (and inner-defun
                     (not (member '&kwarg args))))

        (setq decorators (cons 'pyel-lambda decorators)
              name nil))

      (when (context-p 'class-def)
        ;;this is a method. set a reference to the name of the first arg
        ;;This is used by the type declaration code
        (setq first-arg-name (car args))
        ;;map the first arg to its class type. 
        ;;`class-name' is set by the class transform
        (pyel-env-set first-arg-name (pyel-env-get class-name type-env) type-env)
        (setq decorators (cons 'pyel-lambda decorators)))

      (using-context
       function-def
       (cond

        ;; ((context-p 'class-def) (using-context method-def
        ;;                           (setq last-line (using-context tail-context
        ;;                                                          (transform (car (last body))))
        ;;                                 first (mapcar 'transform (subseq body 0 (1- (length body))))
        ;;                                 t-body (append first (list last-line)))

        ;;                           ;;TODO: let-arlist for methods like
        ;;                           ;;      and *args ...
        ;;                           (push `(defmethod ,name
        ;;                                    ((,(car args) ,class-def-name)
        ;;                                     ,@(cdr args))

        ;;                                    ,@t-body)
        ;;                                 class-def-methods)))

        (t (setq first (subseq body 0 (1- (length body)))
                 first (if first
                           (mapcar 'transform first)
                         nil)
                 last-line (using-context tail-context
                                          (transform (car (last body))))
                 t-body (append first (list last-line)))

           ;;(setq t-body (transform-last-with-context
           ;;                'tail-context body))

           ;;remove variables from the let arglist that have been declared global
           (setq let-arglist (let (arglist)
                               (mapcar (lambda (x)
                                         (unless (or (member x global-vars)
                                                     (member x arg-names))
                                           (push x arglist)))
                                       let-arglist)
                                  arglist))
           ;;      ?remove variables that are defined in emacs?

           (setq docstring
                 (if (stringp (car t-body))
                     (pop t-body)
                   pyel-nothing))

           (setq ret (if return-middle '(catch '__return__)
                       '(@)))

           (if let-arglist
               (setq let-arglist (list '@ 'let let-arglist))
             (setq let-arglist '@))

           (if inner-defun
               (progn
                 (if (and (member '&kwarg args)
                          (not (member 'pyel-lambda decorators)))
                     (setq decorators
                           (cons 'pyel-lambda decorators)))
                 (setq setq-code (list '@ 'setq orig-name)))
             (setq setq-code '@))

           (if interactive
               (push 'interactive decorators))

           (setq pyel-last-func-type-env type-env)
           (setq return-type this-return)
           `(,setq-code (,func ,name ,args ,decorators
                               ,docstring
                               ,@assign-defaults
                               (,let-arglist
                                (,@ret
                                 ,@t-body
                                 ))))))))))

(defun pyel-sort-kwargs (args)
  "Organize args in the format required by functions that accept keyword args
Returns a list whose first element has an alist containing the keyword args
in the cdr and ':kwargs' in the car position.
and whose second element is a list of all non-keyword args
Recognizes keyword args in the form 'arg = value'."
  ;;for use in the 'fcall' transform
  (if (member '= args)
      (let ((current args)
            kwargs
            normal)
        (when (eq (car current) '=) (error "invalid keyword arg syntax"))
        (while current
          (if (eq (car current) '=)
              (progn
                (when (null (cdr current)) (error "invalid keyword arg syntax"))
                (push (cons (pop normal) (cadr current)) kwargs)
                (setq current (cddr current)))
            (push (car current) normal)
            (setq current (cdr current))))
        (list (list 'quote (cons :kwargs kwargs)) (list 'quote (reverse normal))))
    args))

(def-transform bin-op pyel ()
  (lambda (left op right &optional line col)
    (call-transform op left right)))

(pyel-dispatch-func * (l r)
                    (number number) -> (* l r)
                    (string number)
                    (number string)  -> (pyel-mul-num-str l r)
                    (object _)  -> (call-method l --mul-- r))

(pyel-dispatch-func + (lhs rhs)
                    (number number) -> (+ lhs rhs)
                    (string string) -> (concat lhs rhs)
                    (list list)   -> (append lhs rhs)
                    (object _) -> (call-method lhs --add-- rhs)
                    (vector vector) -> (vconcat lhs rhs))

(pyel-dispatch-func - (l r)
                    (number number) -> (- l r)
                    (object _) -> (call-method l --sub-- r))

(pyel-dispatch-func ** (l r) ;;pow
                    (number number) -> (expt l r)
                    (object _) -> (call-method l --pow-- r))

(pyel-dispatch-func / (l r)
                    (number number) -> (pyel-div l r)
                    (object _) -> (call-method l --truediv-- r))

(pyel-dispatch-func // (l r) ;;floored (normal) division
                    (number number) -> (/ l r)
                    (object _) -> (call-method l --floordiv-- r))

(pyel-dispatch-func ^ (l r) ;;bit xor
                    (number number) -> (logxor l r)
                    (object _) -> (call-method l --xor-- r))

(pyel-dispatch-func & (l r) ;;bit and
                    (number number) -> (logand l r)
                    (object _) -> (call-method l --and-- r))

(pyel-dispatch-func | (l r) ;;bit or
                    (number number) -> (logior l r)
                    (object _) -> (call-method l --or-- r))

(pyel-dispatch-func % (l r)
                    (number number) -> (% l r)
                    (object _) -> (call-method l --mod-- r))

(def-transform index pyel ()
  (lambda (value &optional line col)
    (transform value)))

(def-transform slice pyel ()
  (lambda (lower upper step)
    (call-method slice
                 --new-- 
                 (transform lower)
                 (transform upper)
                 (transform step))))

(def-transform subscript pyel ()
  (lambda (value _slice ctx &optional line col)
    (pyel-subscript value _slice ctx line col)))

(pyel-dispatch-func subscript-load-index (name value)
                    (list _) -> (nth value name)
                    (object _) -> (call-method name --getitem-- value)
                    (vector _) -> (aref name value)
                    (string _) -> (char-to-string (aref name value))
                    (hash _) -> (gethash value name))

(pyel-dispatch-func subscript-load-slice (name start end step)
                    (object _ _ _) -> (call-method name --getitem--
                                                   (call-method slice
                                                                --new--
                                                                start
                                                                end
                                                                step))
                    ;;TODO implement step
                    (_ _ _ _) -> (subseq name start end))

(pyel-dispatch-func subscript-store-slice (name start end step assign)
                    (object _ _ _) -> (call-method name --setitem--
                                                   (call-method slice
                                                                --new--
                                                                start
                                                                end
                                                                step)
                                                   assign)

                    ;;TODO implement step
                    (_ _ _ _) -> (setf (subseq name start end) assign))

(pyel-dispatch-func subscript-store-index (name value assign)
                    (list _) -> (setf (nth value name) assign)
                    (object _) -> (call-method name --setitem-- value assign)
                    (vector _) -> (setf (aref name value) assign)
                    (hash _) -> (puthash value assign name))
;;                  (string _) -> not supported in python

(defun pyel-subscript (value _slice ctx &optional line col)
  (let* (;(value (transform value))
         (slice (transform _slice))
         (ctx (cond ((context-p 'force-load) 'load)
                    ((context-p 'force-store) 'store)
                    (t (eval ctx))))
         start stop step ret)

    (when (py-object-p slice)
      (setq start (getattr slice start)
            stop (getattr slice stop)
            step (getattr slice step)))
    (setq ret
          (if (eq ctx 'load)
              (if (py-object-p slice)
                  (call-transform 'subscript-load-slice value start stop step) ;;load slice
                (call-transform 'subscript-load-index value slice)) ;;load index
            ;;else: store
            (if (py-object-p slice)
                (call-transform 'subscript-store-slice value start stop step assign-value)
              (call-transform 'subscript-store-index value slice assign-value)))) ;;store index
    (setq return-type nil) ;;return type unknown
    ret))

(def-transform classdef pyel ()
  (lambda (name bases keywords starargs kwargs
                body decorator_list &optional line col)
    (pyel-defclass name bases keywords starargs kwargs
                   body decorator_list line col)))

(defun pyel-defclass (name bases keywords starargs kwargs
                           body decorator_list &optional line col)
  (let ((class-name (_to- (transform name)))
        (t-bases (mapcar 'transform bases))
        (outer-env type-env)
        (type-env (pyel-make-type-env type-env)))
    
    ;;set the type of this class in the outer type-env
    (pyel-env-set class-name (pyel-make-class-type class-name outer-env) outer-env)
    
    (when (context-p 'function-def)
      (push class-name let-arglist)
      (push '__defined-in-function-body t-bases))
    
    (add-to-list 'pyel-defined-classes name)
    (setq pyel-last-class-type-env type-env)
    (remove-context
     function-def
     (using-context class-def
                    `(define-class ,class-name ,t-bases
                       ,@(mapcar 'transform body)
                       )))))

(def-transform assert pyel ()
  (lambda (test msg &optional line col)
    (pyel-assert test msg line col)))

(defun pyel-assert (test msg &optional line col)
  `(assert ,(transform test) t ,(transform msg)))

(def-transform for pyel ()
  (lambda (target iter body orelse &optional line col)
    (pyel-for target iter body orelse line col)))

;;TODO: for a,y in thing: ...
;;TODO: check if iter is an object, then do the iterator thing

(defun pyel-for (target iter body orelse &optional line col)
  (let ((target (using-context for-loop-target
                               (if (eq (car target) 'tuple)
                                   (mapcar 'transform (cadr target))
                                 (list (transform target)))))
        (body (using-context for (mapcar 'transform body)))
        (else (mapcar 'transform orelse))) ;;break/continue for else?
    (when else
      (setq body (append body (cons 'else else))))

    `(py-for ,@target in ,(transform iter) ,@body)))

;; (if (eq (car target) 'tuple)
;;     "TODO: var unpacking"
;;   ;;create a temp target variable
;;   ;;in body, unpack that into the provided target variables

;;   (let* ((continue-for nil)
;;          (break-for nil)
;;          (code (using-context for (mapcar 'transform body)))
;;          (break-code (if break-for '(catch '__break__)
;;                        pyel-nothing))
;;          (continue-code (if continue-for '(catch '__continue__)
;;                           pyel-nothing)))
;;     (setq _x break-for)
;;     `(,@break-code
;;       (loop for ,(using-context for-loop-target
;;                                 (transform target))
;;             in (py-list ,(transform iter))
;;             do (,@continue-code
;;                 ,@(mapcar 'transform body)))
;;       ,@(mapcar 'transform orelse)))))

(def-transform global pyel ()
  (lambda (names &optional line col)
    (if (context-p 'function-def)
        (progn (mapc (lambda (x) (add-to-list 'global-vars (_to- x))) names)
               pyel-nothing)
      (pyel-not-implemented "'global' calls outside of function definitions"))))



(def-transform lambda pyel ()
  (lambda (args body &optional line col)
    (using-context lambda-def
                   (pyel-def nil args body nil nil line col))))

(def-transform unary-op pyel ()
  (lambda (op operand &optional line col)
    (call-transform op operand)))

(pyel-dispatch-func not (obj)
                    (number) -> (eq obj 0)
                    (string) -> (eq obj "")
                    (list)   -> (null obj)
                    (object) -> (pyel-object-bool obj)
                    (vector) -> (eq obj [])
                    (hash)   -> (= (hash-table-count obj) 0)
                    (_)      -> (not obj))

(pyel-dispatch-func usub (x)
                    (number) -> (- x)
                    (object) -> (--usub-- x) ;;?
                    )

(def-transform aug-assign pyel (target op value)
  (lambda (target op value &optional line col)
    (call-transform 'assign
                    `(,target)
                    (call-transform  op
                                     ;;TODO: what if this is something else
                                     ;;other then a simple name?
                                     ;;=> ok as long as nothing acknowledges
                                     ;;   the  force-load context
                                     (using-context force-load
                                                    (transform target))
                                     value))))

(def-transform return pyel ()
  (lambda (value &optional line col)

    (if (context-p 'tail-context)
        (transform value)
      (setq return-middle t)
      `(throw '__return__ ,(transform value)))))

(def-transform break pyel ()
  (lambda (&optional line col)
    ;;TODO verify that it is ok to just use one inter-template var for this
    (context-switch
     (while (setq break-while t)
       '(throw '__break__ nil))
     (for (setq break-for t)
          '(break)))))

(def-transform continue pyel ()
  (lambda (&optional line col)
    ;;TODO verify that it is ok to just use one inter-template var for this
    (context-switch
     (while (setq continue-while t)
       '(throw '__continue__ nil))
     (for (setq continue-for t)
          '(continue)))))

(def-transform except-handler pyel (type name body)
  ;;TODO: name?
  (lambda (type name body &optional line col)
    `(,(or (transform type) 'error)
      ,@(mapcar 'transform body))))

(def-transform try pyel (body handlers orelse)
  ;;TODO: orelse
  (lambda (body handlers orelse &optional line col)
    (let ((body (mapcar 'transform body)))
      (if (> (length body) 1)
          (setq body (cons 'progn body))
        (setq body (car body)))
      `(condition-case nil
           ,body
           ,@(mapcar 'transform handlers)))))

;;a not in b
;; function:    is_not(a, b)  (in the operator module)
(pyel-dispatch-func not-in (l r)
                    (_ list) -> (not (py-list-member l r))
                    (_ string) -> (not (py-string-member l r))
                    (_ object) -> (not (py-object-member l r))
                    (_ vector) -> (not (py-vector-member l r)))

;;a in b
;; function:    is_(a, b)
(pyel-dispatch-func in (l r)
                    (_ list) -> (py-list-member l r)
                    (_ string) -> (py-string-member l r)
                    (_ object) -> (py-object-member l r)
                    (_ vector) -> (py-vector-member l r))

(def-transform comprehension pyel (target iter ifs)
  (lambda (target iter ifs) (pyel-comprehension target iter ifs)))

(defun pyel-comprehension (target iter ifs)
  (cons 'for (cons (using-context for-loop-target
                                  (transform target))
                   (cons 'in (cons (transform iter)
                                   (reduce 'append
                                           (mapcar (lambda (x)
                                                     (list 'if (transform x)))
                                                   ifs)))))))
(def-transform list-comp pyel (elt generators)
  (lambda (elt generators &optional line col)
    (pyel-list-comp elt generators line col)))


(defun pyel-list-comp (elt generators &optional line col)
  (let ((ret (cons 'py-list-comp
                   (cons (transform elt)
                         (reduce 'append (mapcar 'transform generators))))))
    (setq return-type 'list)
    ret))

(def-transform dict-comp pyel (key value generators)
  (lambda (key value generators &optional line col)
    (pyel-dict-comp key value generators line col)))

(defun pyel-dict-comp (key value generators &optional line col)
  (let ((ret (append (list 'py-dict-comp (transform key) ': (transform value))
                     (reduce 'append (mapcar 'transform generators)))))
    (setq return-type 'hash)
    ret))

(def-transform boolop pyel (op values)
  (lambda (op values &optional line col)
    (cons op (mapcar 'transform values))))

(def-transform pass pyel ()
  (lambda (&optional line col) nil))

(def-transform unimplemented pyel (name)
  (lambda (name)
    (pyel-notify-error "Set comprehensions have not been implemented")
    pyel-error-string))

(def-transform if-exp pyel ()
  (lambda (test body orelse &optional line col)
    (pyel-if test (list body) (list orelse) line col)))

(def-transform raise pyel ()
  (lambda (exc cause &optional line col)
    `(py-raise ,(transform exc)))) ;;TODO: ignoring cause

;;

(pyel-translate-function-name 'map 'mapcar)

(pyel-declare-el-func-fn 'len 'number)
(pyel-func-transform len (thing)
                     (hash)   -> (hash-table-count thing)
                     (object) -> (call-method thing --len--)
                     (_)      -> (length thing))

(pyel-declare-el-func-fn 'range 'list)
(pyel-declare-el-func-fn 'xrange 'list)
(pyel-translate-function-name 'range 'py-range)
(pyel-translate-function-name 'xrange 'py-range)

(pyel-declare-el-func-fn 'input 'string)
(pyel-translate-function-name 'input 'read-string)

(pyel-declare-el-func-fn 'list 'list)

(defalias 'py-list 'pyel-list-function31)
(pyel-func-transform list (object)
                     (string) -> (py-string-to-list object)
                     (object) -> (py-object-to-list object)
                     (vector) -> (py-vector-to-list object)
                     (hash)   -> (py-hash-to-list object)
                     (list)   -> (py-copy-list object))

(let ((current-transform-table (get-transform-table 'pyel))
      (type-env (pyel-make-type-env pyel-global-type-env)))
  (call-transform (pyel-func-transform-name 'list) nil))

(pyel-declare-el-func-fn 'tuple 'vector)
(pyel-func-transform tuple (object)
                     (string) -> (py-string-to-vector object)
                     (list)   -> (py-list-to-vector object)
                     (vector) -> (py-copy-vector object)
                     (hash)   -> (py-hash-to-vector object)
                     (object) -> (py-object-to-vector object))

(pyel-declare-el-func-fn 'hasattr 'bool)
(pyel-translate-function-name 'hasattr 'obj-hasattr)

(pyel-declare-el-func-fn 'isinstance 'bool)
(pyel-translate-function-name 'isinstance 'obj-isinstance)

(pyel-func-transform str (thing)
                     ;; if any of these cases are added/removed,
                     ;; the 'pyel-str-function' alias will
                     ;; need to be updated 
                     (number) -> (number-to-string thing)
                     (string) -> (format "\"%s\"" thing)
                     (function) -> (py-function-str thing)
                     (list) -> (py-list-str thing)
                     (object) -> (call-method thing --str--)
                     (vector) -> (py-vector-str thing)
                     (hash) -> (py-hash-str thing)
                     (symbol) -> (symbol-name thing))

(pyel-translate-function-name 'str 'pyel-str)
(pyel-declare-el-func-fn 'str 'string)

(pyel-func-transform repr (thing)
                     ;; if any of these cases are added/removed,
                     ;; the 'pyel-repr-function' alias will
                     ;; need to be updated (in str transform section)
                     (number) -> (number-to-string thing)
                     (string) -> (py-repr-string thing)
                     (function) -> (py-function-str thing)
                     (symbol) -> (pyel-symbol-str thing)
                     (list) -> (py-list-repr thing)
                     (object) -> (call-method thing --repr--)
                     (vector) -> (py-vector-str thing)
                     (hash) -> (py-hash-str thing))

(pyel-translate-function-name 'repr 'pyel-repr)
(pyel-declare-el-func-fn 'repr 'string)

(pyel-declare-el-func-fn 'hex 'string)
(pyel-translate-function-name 'hex 'py-hex)

(pyel-declare-el-func-fn 'bin 'string)
(pyel-translate-function-name 'bin 'py-bin)

;;(pyel-translate-function-name 'print 'py-print)
(pyel-declare-el-func-fn 'print 'bool)
(pyel-define-function-translation
 print
 `(py-print ,(cadr (assoc 'sep kwargs))
            ,(cadr (assoc 'end kwargs))
            nil ;;TODO: file=sys.stdout
            ,@args))

(pyel-declare-el-func-fn 'pow 'number)
(pyel-define-function-translation
 pow
 (case (length args)
   (3 (list 'mod (list 'expt (car args) (cadr args)) (caddr args)))
   (2 (list 'expt (car args) (cadr args)))
   (t "ERROR") ;;TODO
   ))

(pyel-declare-el-func-fn 'eval 'list)
(pyel-translate-function-name 'eval 'py-eval)

;;(pyel-declare-el-func-fn 'type 'symbol)
(pyel-translate-function-name 'type 'py-type)

(pyel-translate-variable-name 'int 'py-int)
(pyel-translate-variable-name 'float 'py-float)
(pyel-translate-variable-name 'tuple 'py-tuple)
(pyel-translate-variable-name 'dict 'py-dict)
(pyel-translate-variable-name 'list 'py-list)
(pyel-translate-variable-name 'string 'py-string)
(pyel-translate-variable-name 'bool 'py-bool)
(pyel-translate-variable-name 'type 'py-type)

(pyel-declare-el-func-fn 'abs 'number)
                         
(pyel-func-transform abs (object)
                     (number) -> (abs object)
                     (object) -> (call-method object --abs--))

(pyel-declare-el-func-fn 'chr 'string)
(pyel-translate-function-name 'chr 'py-chr)

(pyel-declare-el-func-fn 'ord 'number)
(pyel-translate-function-name 'ord 'py-ord)

(pyel-declare-el-func-fn 'chr nil)
(pyel-translate-function-name 'exit 'pyel-exit)

(pyel-declare-el-func-fn 'int 'number)
(pyel-func-transform int (object)
                     (string) -> (py-str-to-int object)
                     (number) -> (py-number-to-int object)
                     (object) -> (call-method object --int--))

(pyel-declare-el-func-fn 'float 'number)
(pyel-func-transform float (object)
                     (string) -> (py-str-to-float object)
                     (number) -> (py-number-to-float object)
                     (object) -> (call-method object --float--))

(pyel-declare-el-func-fn 'dict 'hash)

(pyel-func-kwarg-transform dict (kwargs)
                           (_)-> (pyel-alist-to-hash2 'kwargs))

(pyel-func-transform dict (&optional object)
                     (list)   -> (pyel-list-to-dict object)
                     (object) -> (pyel-object-to-dict object)
                     (vector) -> (pyel-vector-to-dict object)
                     (hash)   -> (copy-hash-table object))

(pyel-declare-el-func-fn 'round 'number)
(pyel-translate-function-name 'round 'py-round)

(pyel-declare-el-func-fn 'enumerate 'list)

(pyel-func-transform enumerate (obj &optional start)
                     (list)   -> (py-enumerate-list obj start)
                     (string) -> (py-enumerate-string obj start)
                     (object) -> (py-enumerate-object obj start)
                     (vector) -> (py-enumerate-vector obj start)
                     (hash)   -> (py-enumerate-hash obj start))

(pyel-declare-el-func-fn 'interactive nil)

(pyel-define-function-translation
 interactive
 (setq interactive t))

(pyel-declare-el-func-fn 'divmod 'vector)

(pyel-func-transform divmod (x y)
                     (_ float)
                     (_ float) -> (py-divmod-f x y)
                     (int int) -> (py-divmod-i x y)
                     (_ _)     -> (py-divmod x y))

(pyel-declare-el-func-fn 'bool 'bool)

(pyel-func-transform bool (object)
                     (object) -> (py-object-bool object)
                     (_) -> (py-bool object))

(pyel-declare-el-func-fn 'iter 'object)

(pyel-func-transform iter (obj)
                     (list)   -> (py-list-iter obj)
                     (string) -> (py-string-iter obj)
                     (object) -> (py-object-iter obj)
                     (vector) -> (py-vector-iter obj)
                     (hash)   -> (py-hash-iter obj))

(pyel-declare-el-func-fn 'next nil)

(pyel-translate-function-name 'next 'py-next)

(pyel-declare-el-func-fn 'all 'bool)

(pyel-func-transform all (obj)
                     (list)   -> (py-list-all obj)
                     (string) -> (py-string-all obj)
                     (object) -> (py-object-all obj)
                     (vector) -> (py-vector-all obj)
                     (hash)   -> (py-hash-all obj))

(pyel-declare-el-func-fn 'any 'bool)

(pyel-func-transform any (obj)
                     (list)   -> (py-list-any obj)
                     (string) -> (py-string-any obj)
                     (object) -> (py-object-any obj)
                     (vector) -> (py-vector-any obj)
                     (hash)   -> (py-hash-any obj))

(pyel-declare-el-func-fn 'sum 'number)

(pyel-func-transform sum (obj)
                     (list)   -> (py-list-sum obj)
                     (object) -> (py-object-sum obj)
                     (vector) -> (py-vector-sum obj)
                     (hash)   -> (py-hash-sum obj))

(pyel-declare-el-func-fn 'hash 'number)

(pyel-translate-function-name 'hash 'sxhash)

;;

(pyel-method-transform append (obj thing)
                       (list _) -> (py-append $obj thing)
                       (_ _)    -> (call-method obj append thing))

(pyel-method-transform insert (obj i x)
                       (list _) -> (py-insert obj i x)
                       (_ _) -> (call-method obj insert i x))

(pyel-method-transform find (obj sub &optional start end)
                       (string _ _ _) -> (py-find obj sub start end)
                       (_ _ _ _)      -> (call-method obj find sub start end))

(pyel-method-transform index (obj elem)
                       (list _) -> (list-index elem obj)
                       (string _) -> (py-string-index obj elem)
                       (object _) -> (call-method obj index elem)
                       (vector _) -> (vector-index elem obj))

(pyel-method-transform remove (obj x)
                       (list _) -> (py-list-remove obj x)
                       (_ _) -> (call-method obj remove x))

(pyel-method-transform count (obj elem)
                       (string _) -> (count-str-matches obj elem)
                       (list _) -> (count-elems-list obj elem)
                       (object _)  -> (call-method obj count elem)
                       (vector _) -> (count-elems-vector obj elem))

(pyel-method-transform join (obj elem)
                       (string _) ->  (mapconcat 'identity elem obj)
                       (_ _)      -> (call-method obj join thing))

(pyel-method-transform extend (obj elem)
                       (list _) ->  (py-list-extend obj elem)
                       (_ _)    ->  (call-method obj extend elem))

(pyel-method-transform pop (obj &optional a)
                       (list _) -> (py-list-pop obj a)
                       (hash _) -> (py-hash-pop obj a)
                       (_ _)    -> (call-method obj pop a))

(pyel-method-transform reverse (obj)
                       (list) ->  (pyel-list-reverse obj)
                       (_)    ->  (call-method obj reverse))

(pyel-method-transform lower (obj)
                       (string) ->  (downcase obj)
                       (_)    ->  (call-method obj lower))

(pyel-method-transform upper (obj)
                       (string) ->  (upcase obj)
                       (_)    ->  (call-method obj upper))

(pyel-method-transform split (obj &optional sep maxsplit)
                       (string) ->  (pyel-split obj sep maxsplit)
                       (_)    ->  (call-method obj split sep maxsplit))

(pyel-method-transform strip (obj &optional chars)
                       (string) ->  (pyel-strip obj chars)
                       (_)    ->  (call-method obj strip chars))

(pyel-method-transform get (obj key &optional default)
                       (hash) ->  (gethash key obj default)
                       (_)    ->  (call-method-with-defaults obj get
                                                             (key) (default)))

(pyel-method-transform items (obj)
                         (hash) -> (pyel-dict-items obj)
                         (_)    -> (call-method obj items))

(pyel-method-transform keys (obj)
                           (hash) -> (py-dict-keys obj)
                           (_)    -> (call-method obj key))

(pyel-method-transform values (obj)
                       (hash) -> (pyel-dict-values obj)
                       (_)    -> (call-method obj values))

(pyel-method-transform popitem (obj)
                       (hash) -> (pyel-hash-popitem obj)
                       (_)    -> (call-method obj popitem))

(pyel-method-transform copy (obj)
                       (hash) -> (copy-hash-table obj)
                       (_)    -> (call-method obj popitem))

(pyel-method-transform islower (obj)
                       (string) -> (py-islower obj)
                       (_)      -> (call-method obj islower))

(pyel-method-transform isupper (obj)
                       (string) -> (py-isupper obj)
                       (_)      -> (call-method obj isupper))

(pyel-method-transform istitle (obj)
                       (string) -> (py-istitle obj)
                       (_)      -> (call-method obj istitle))

(pyel-method-transform isalpha (obj)
                       (string) -> (py-isalpha obj)
                       (_)      -> (call-method obj isalpha))

(pyel-method-transform isalnum (obj)
                       (string) -> (py-isalnum obj)
                       (_)      -> (call-method obj isalnum))

(pyel-method-transform zfill (obj width)
                       (string) -> (py-zfill obj width)
                       (_)      -> (call-method obj zfill width))

(pyel-method-transform title (obj)
                       (string) -> (py-title obj)
                       (_)      -> (call-method obj title))

(pyel-method-transform swapcase (obj)
                       (string) -> (py-swapcase obj)
                       (_)      -> (call-method obj swapcase))

(pyel-method-transform startswith (obj prefix &optional start end)
                       (string _ _ _) -> (py-startswith obj prefix start end)
                       (_ _ _ _)            -> (call-method obj startswith prefix start end))

(pyel-method-transform splitlines (obj &optional keepends)
                       (string) -> (py-splitlines obj keepends)
                       (_)      -> (call-method obj splitlines keepends))

(pyel-method-transform rstrip (obj &optional chars)
                       (string) -> (py-rstrip obj chars)
                       (_)      -> (call-method obj rstrip chars))

(pyel-method-transform lstrip (obj &optional chars)
                       (string) -> (py-lstrip obj chars)
                       (_)      -> (call-method obj lstrip chars))

(pyel-method-transform rsplit (obj &optional sep maxsplit)
                       (string) ->  (pyel-rsplit obj sep maxsplit)
                       (_)    ->  (call-method obj rsplit sep maxsplit))

(pyel-method-transform partition (obj sep)
                       (string) ->  (py-partition obj sep)
                       (_)    ->  (call-method obj partition sep))

(pyel-method-transform rpartition (obj sep)
                       (string) ->  (py-rpartition obj sep)
                       (_)      ->  (call-method obj rpartition sep))

(pyel-method-transform rjust (obj width &optional fillchar)
                       (string) -> (py-rjust obj width fillchar)
                       (_)      -> (call-method obj rjust width fillchar))

(pyel-method-transform ljust (obj width &optional fillchar)
                       (string) -> (py-ljust obj width fillchar)
                       (_)      -> (call-method obj ljust width fillchar))

(pyel-method-transform rfind (obj sub &optional start end)
                       (string) -> (py-rfind obj sub start end)
                       (_)      -> (call-method obj rfind sub start end))

(pyel-method-transform rindex (obj sub &optional start end)
                       (string) -> (py-rindex obj sub start end)
                       (_)      -> (call-method obj rindex sub start end))

(pyel-method-transform replace (obj old new &optional count)
                       (string) -> (py-replace obj old new count)
                       (_)      -> (call-method obj replace old new count))

(pyel-method-transform clear (obj)
                       (hash) -> (py-hash-table-clear obj)
                       (_)      -> (call-method obj clear))

(pyel-method-transform fromkeys(obj keys &optional value)
                         (hash _ _) -> (py-fromkeys keys value)
                         (_)      -> (call-method obj fromkeys keys value))

(pyel-method-transform isprintable (obj)
                       (string) -> (py-isprintable obj)
                       (_)      -> (call-method obj isprintable))

;;

;;

(provide 'pyel-transforms)
;;pyel-transforms.el ends here

;;
