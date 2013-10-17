
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

(add-to-list 'load-path "~/programming/pyel/")
  (add-to-list 'load-path "~/programming/code-transformer/")  
  (require 'eieio)
  (require 'cl) 
;;other requires are at the end

;; This is a tangled file  -- DO NOT HAND-EDIT -- 
;;PYEL -> translate PYthon to Emacs Lisp

(defun mpp (code)
  (let ((pp (pp-to-string code)))
    (insert "\n" pp)))


;;TODO: more robust checking, return type of error as well
(defun pyel-is-error (code)
  "return the line of the error in CODE, else nil"
  (let ((line))
    (if (string-match "^Traceback" code)
        (with-temp-buffer
          (insert code)
          (goto-char (point-max))
          (if (re-search-backward "line \\([0-9]+\\)")
              (setq line (match-string 1)))))
    ;;TODO: why is this the actual line number...it should be relative the a bunch of code it's appended to ...
    (and line (string-to-number line))))

(defvar pyel-transform-status nil
  "indicate status (success/fail) of last pyel transform
status types:
nil for no error
('python ast transform error'  <line number>) 
")

(defvar pyel-error-string "PYEL ERROR"
  "string returned by `pyel' when it failed to transform")

(defun pyel-py-ast-file-name ()
  "return the full file name of py-ast.el"
  (file-path-concat pyel-directory "py-ast.py"))

(defun pyel (python &optional py-ast-only &optional include-defuns)
  "translate PYTHON into Emacs Lisp.
PYTHON is a string.
If PY-AST-ONLY, return the un-evaled ast.
If INCLUDE-DEFUNS, include the list of pyel defined functions in the output
  this is ignored if PY-AST-ONLY is non-nil"

  (setq pyel-marked-ast-pieces nil)
  (setq pyel-transform-status nil) ;;so far so good...
  
  (let ((file "/tmp/py2el.py")
        (py-ast "")
        (el-code "")
        (current-transform-table (get-transform-table 'pyel))
        (python (with-temp-buffer
                  (insert python)
                  (pyel-preprocess-buffer2)
                  (buffer-string)))
        (pyel-context nil)
        line ret
        )
    
    ;;?? setting the mark?
    (with-temp-buffer
      ;;    (find-file file)
      ;;    (erase-buffer)
      (insert-file (pyel-py-ast-file-name))
      (goto-char (point-max))
      (insert "\n")
      (setq line (line-number-at-pos))
      (insert (format "print(eval(ast.dump(ast.parse(\"\"\"%s\"\"\"))))" python))
      (write-region
       nil
       nil
       file nil 'silent))
    
    (setq py-ast (shell-command-to-string (format "python3 %s" file)))

    (if (setq py-error (pyel-is-error py-ast))
        (progn
          (setq pyel-python-error-line py-error)
          pyel-error-string)
        ;;else: no error
    (if py-ast-only
        py-ast
      ;;      (pyel-do-splices (transform (read py-ast))))))
      ;;read can only return one sexp so we need to put it in a progn or something
      ;;similar
      
      (setq ret (pyel-do-splices (if include-defuns
                           (list '@ (cons '@ pyel-function-definitions)
                                    (transform (read (format "(@ %s)" py-ast))))
                         (transform (read  (format "(@ %s)" py-ast))))))
      ;;TODO this is a temp solution for convenience
      (mapc 'eval pyel-function-definitions) 
      ret
      ))))

(defun pyel-buffer-to-string (&optional ast-only)
  "transform python in current buffer and return a string"
  ;;THIS DOES NOT RETURN A STRING!
  (pyel (buffer-string) ast-only))


(defvar pyel-pp-function 'pp-to-string
      "function that pretty prints pyel e-lisp code")
      
(defun pyel-buffer (&optional out-buff)
  "transform python in current buffer and display in OUT-BUFF,
OUT-BUFF defaults to *pyel-output*"
  (interactive)
  (let ((out (pyel-buffer-to-string)))
    (switch-to-buffer-other-window "*pyel-output*")
    (erase-buffer)
    (insert (funcall 'pyel-pp-function out))
    (emacs-lisp-mode)))

(defun pyel-transform-ast (ast &optional no-splice)
  "transform a python AST to Emacs Lisp, AST must be a string
AST can be generated by `pyel' with (pyel py-string t)"
  (with-transform-table 'pyel
                        (let ((code (transform (read  (format "(@ %s)" ast)))))
                          (if no-splice
                              code
                            (pyel-do-splices code)))))

(defun pyel-ast (code)
  "return the ast of python CODE"
  ;;TODO:
  ;;create a new ast type and add the code from the list `pyel-marked-ast-pieces'
  ;;   to the ast
  ;; have a transform for it to rebuild `pyel-marked-ast-pieces'
  ;; This way the AST can be transformed independently of any variables
  )
(defun pyel-file-ast (file-name)
  "return the ast from .py file FILE-NAME"
  )
      
(defmacro pyel-with-known-types (known-types &rest code)
  "translate CODE while faking the known types"
  `(flet ((pyel-get-possible-types
           (&rest args)
           (mapcar* (lambda (arg type) (cons arg type))
                    args ,known-types)))
     
     (pyel ,@code)))


(defun py-ast (code &optional pp)
  "return the python abstract syntax tree for python CODE"
  (let ((file "/tmp/py2el.py")
        (py-ast "")
        (el-code "")
        ret)
    
    (find-file file)
    (erase-buffer)
    (insert "import ast" "\n");; "import test" "\n")

    (insert (format "print(ast.dump(ast.parse(\"\"\"%s\"\"\")))" code))
    (save-buffer)
    (kill-buffer)
    (setq ret (shell-command-to-string (format "python3 %s" file)))
    (if pp
        (mapconcat 'identity (split-string ret ",") ",\n")
      ret)))


;;'(a (@ b (c)))) => (a b (c))
;;'(a (@ b c)))   => (a b c)
;;'(@ a b c) => (progn a b c)
;;'(@ (a b)) = > (a b)
;;'(a (@) b) = > (a b)

(defun pyel-do-splices (code)
  (if (listp code)
      (if (eq (car code) '@) ;;special case: outer most list 
          (if (> (length code) 2)
              (pyel-do-splices `(progn ,code))
            (pyel-do-splices (cadr code)))
        (let ((ncode nil))
          (while code
            (setq c (pop code))
            (if (listp c)
                (if (equal (car c) '@)
                    (setq ncode (append (reverse (pyel-do-splices (cdr c))) ncode))
                  (push (pyel-do-splices c) ncode))
              (push c ncode)))
          (if (listp ncode) (reverse ncode) ncode)))
    code))



(defun pyel-reload ()
  (interactive)
  (dolist (f '(pyel pyel-tests pyel-transforms ))
    (setq features (remove f features)))
  (require 'pyel))



(defun pyel-method-transform-name(method-name)
  "return the name of the temlate that transform the method METHOD-NAME.
template names are modified to avoid potential conflict with other templates"
  (intern (format "_%s-method_" (symbol-name method-name))))


(defun pyel-func-transform-name (func-name)
  "like `pyel-method-transform-name' for functions"
  (intern (format "_%s-function_" (symbol-name func-name))))



(defmacro push-back (val place)
  "Add VAL to the end of the sequence stored in PLACE. Return the new
value."
  `(setq ,place (append ,place (list ,val))))

(defun pyel-translate-function-name (name new-name)
  "translate python NAME to e-lisp NEW-NAME"
  (push (list name new-name) pyel-function-name-translations))

(defun pyel-translate-variable-name (name new-name)
  "translate python  NAME to e-lisp NEW-NAME"
  (push (list name new-name) pyel-variable-name-translations))


(defun pyel-not-implemented (message)
  "signify that a feature is not implemented"
  ;;TODO
  (message message) ;;tmp
  )


(defmacro insert-at (list nth value)
  "insert VALUE at NTH index in LIST"
  `(setq ,list (append (subseq ,list 0 ,nth)
                       (list ,value)
                       (subseq ,list  ,nth))))

(defun list-to-vector (list)
  (eval `(vector ,@list))) ;;this is gross


(defun _to- (thing)
  (cond
   ((stringp thing)

    (replace-regexp-in-string "_" "-"  thing))
   ((symbolp thing)
    (intern (replace-regexp-in-string "_" "-"  (symbol-name thing))))
   ((listp thing) (mapcar '_to- thing))
   (t (error "ERROR in _to-. invalid thing"))))

;; (defun pyel-create-test-here (name &rest py-code)
;;   (let ((shoulds nil))
;;     (dolist (code (reverse py-code))
;;       ;;check complete code transformation
;;       (push `(should (string= (pyel ,code)
;;                       ,(pyel code)))
;;             shoulds)
;;       ;;check transformed .py syntax tree
;;       (push `(should (string= (pyel ,code t)
;;                       ,(pyel code t)))
;;             shoulds)
;;       ;;check pure .py syntax tree
;;       (push `(should (equal (py-ast ,code)
;;                              ,(py-ast code)))
;;             shoulds))

;;     (pp `(ert-deftest ,name () ,@shoulds)) nil))

(defun pyel-create-tests (name &rest py-code)
  (let ((complete nil)
        (py-ast nil)
        (el-ast nil)
        trans)
    (progv
        (mapcar 'car test-variable-values)
        (mapcar 'cadr test-variable-values)
      
      (dolist (code (reverse py-code))
        ;;check complete code transformation
        (setq trans (pyel code))
        (push `(should (equal
                        (pyel ,code)
                        ',trans))
              complete)
        ;;check pure .py syntax tree
        (push `(should (equal (py-ast ,code)
                              ,(py-ast code)))
              py-ast)
        ;;check transformed .py syntax tree
        (push `(should (string= (pyel ,code t)
                                ,(pyel code t)))
              el-ast))
      
      (kill-new (pp-to-string `(ert-deftest ,(intern (concat "pyel-" (symbol-name name) "-full-transform"))
                                   () ,@complete)))
      (kill-append (pp-to-string `(ert-deftest ,(intern (concat "pyel-" (symbol-name name) "-py-ast"))
                                      () ,@py-ast)) nil)
      
      (kill-append (pp-to-string `(ert-deftest ,(intern (concat "pyel-" (symbol-name name) "-el-ast"))
                                      () ,@el-ast)) nil)
      (message "Tests copied to kill ring"))))

  
(defun pyel-create-tests-with-known-types (name known-types &rest py-code)
  "just like `pyel-create-tests-with-known-types' fakes the known types during the tests"
  ;;99% of the code is the same...
  (let ((complete nil)
        (py-ast nil)
        (el-ast nil)    
        trans)
    (progv
        (mapcar 'car test-variable-values)
        (mapcar 'cadr test-variable-values)

      
      (dolist (code (reverse py-code))
        ;;check complete code transformation
        (setq trans (pyel-with-known-types known-types code))
        (push `(should (equal
                        (pyel-with-known-types ',known-types ,code)
                        ',trans))
              complete)
        ;;check pure .py syntax tree
        (push `(should (equal (py-ast ,code)
                              ,(py-ast code)))
              py-ast)
        ;;check transformed .py syntax tree
        (push `(should (string= (pyel ,code t)
                                ,(pyel code t)))
              el-ast))
      
      (kill-new (pp-to-string `(ert-deftest ,(intern (concat "pyel-" (symbol-name name) "-full-transform"))
                                   () ,@complete)))
      (kill-append (pp-to-string `(ert-deftest ,(intern (concat "pyel-" (symbol-name name) "-py-ast"))
                                      () ,@py-ast)) nil)

      (kill-append (pp-to-string `(ert-deftest ,(intern (concat "pyel-" (symbol-name name) "-el-ast"))
                                      () ,@el-ast)) nil)
      (message "Tests copied to kill ring"))))

(defvar pyel-directory ""
  "Path to pyel files. must include py-ast.py, pyel.el etc")


(defvar pyel-type-test-funcs '((string stringp)
                               (number numberp)
                               (integer integerp)
                               (int integerp)
                               (float floatp)
                               (vector vectorp)
                               (list listp)
                               (cons consp)
                               (hash hash-table-p)
                               (hash-table hash-table-p)
                               (symbol symbolp)
                               (array arrayp)
                               (object object-p))
  "alist of types used in pyel-call-transform for the switch-type
    and the function used to test for that type")


(defvar pyel-defined-classes nil
  "list of call class names defined by pyel")



(defvar pyel-defined-functions nil
  "list of some functions defined pyel
  used by some templates to determine if a needed function has been defined yet")

(defvar pyel-function-definitions nil
  "used to store function definitions created by pyel, not the user.")

(defvar pyel-replace-args nil
  "if non-nil, pyel-do-call-transform will replace the arg symbols with their
  value, used if the code is to be inlined
  TODO: the option to replace the args should probably be obsoletede")

(defvar pyel-unique-obj-names nil
  "if non-nil, uniquely name object instantces")


(defvar pyel-context-groups nil ;;TODO: still used?
  "groups of contexts that cannot exist at the same time.
`context-p' will stop at the first one in the list,")

(setq pyel-context-groups
      '((assign-target assign-value)))

(defvar pyel-function-name-translations nil
  "alist of function name translations, python->e-lisp.

Entries in `pyel-function-name-translations' are applied before
checking for function transforms.
If a translation len->length is defined then the function transform for
'len' will not be detected because the name is now 'length'
")

(defvar pyel-variable-name-translations nil
  "alist of variable name translations, python->e-lisp.")

(setq pyel-function-name-translations `(
                                        
                                        ))
;;TODO: list, vector, etc
;;      map?               

(setq pyel-variable-name-translations '((True t)
                                        (False nil)
                                        (None nil)))

(defvar pyel-method-transforms nil
  "List of names of methods for which a transform has been defined
For internal use only--do not modify by hand"
  )

(defvar pyel-func-transforms nil
  "list of function names that have transforms defined for them")


(defconst pyel-nothing '(@)
  "value to return from a function/transform when it should
not contribute to the output code")

(defconst pyel-python-version "3.2.3"
  "python interpreter version whose ast pyel is written for")



(defvar test-variable-values nil
  "variables values for running tests")


(setq test-variable-values
      '((pyel-defined-classes nil)
        (pyel-function-definitions nil)
        (pyel-defined-functions nil)
        (pyel-obj-counter 0)
        (pyel-unique-obj-names nil)
        ;;(pyel-method-transforms nil)
        ;;(pyel-func-transforms nil)
        (pyel-marker-counter 0)
        (known-types ((number list vector string object hash)
                      (number list vector string object hash)
                      (number list vector string object hash)
                      (number list vector string object hash)
                      (number list vector string object hash)
                      (number list vector string object hash)
                      (number list vector string object hash)
                      (number list vector string object hash)
                      (number list vector string object hash)
                      (number list vector string object hash)))))


(defvar pyel-marker-counter 0)

(defvar pyel-default--init--method
    "(defmethod --init-- ((self %s))
     \"Default initializer\"
    )"
    
    "default initializer for pyel objects.")

  (defvar pyel-use-list-for-varargs nil
      "Determines if *varargs will be passed to function as a list or a vector,
  non-nil for list, otherwise vector.
  To be like python (vectors), this should be nil
  To be consistent with Emacs-Lisp (lists), this should be t.
     On the python side, this means that *varargs is a list instead of a tuple")

(defmacro pyel-block (&rest code)
  `(progn ,@ code))

;;TODO: this should be generalized and added to the transform code
(defvar pyel-context nil
  "list of current expansion contexts")

(defmacro using-context (context &rest code)
  `(progn
     (push ',context pyel-context)
     (let ((ret (progn ,@code)))
       (pop pyel-context)
       ret)))

(defmacro context-switch (&rest forms)
  `(cond ,@(mapcar (lambda (x)
                   `(,(let ((context (car x)))
                        (if (eq context t) t
                          `(member ',context pyel-context))) ,@(cdr x)))
                  forms)))



(defun get-context-group (context)
  (let ((groups pyel-context-groups)
        (found nil)
        group)
    (while groups
      (setq group (car groups)
            groups (cdr groups))
      (dolist (g group)
        (when (equal g context)
          (setq found group
                groups nil))))
    found))

;; (defun context-p (context)
;;   (member context pyel-context))
(defun context-p (context)
  ;;;;TODO: the extra features that this provides is probably not being used anywere...
  (let ((group (get-context-group context))
        (cont pyel-context)
        (ret nil)
        c)
    (while cont
      (setq c (car cont)
            cont (cdr cont))
      ;;if the context is in a group only return t if it is the first one in pyel-context
      (if (member c group)
          (setq ret (equal c context)
                cont nil)
        (when (equal c context)
          (setq ret t
                cont nil))))
    ret))



(defun context-depth (context)
"get the depth of CONTEXT in `pyel-context'"
;;TODO:
)

;;this is all temp for testing
  (setq known-types '((number object ) (number string)))

;;prevents error: "Wrong type argument: listp, string"
(setq known-types '((number list vector string object hash)
                    (number list vector string object hash)
                    (number list vector string object hash)
                    (number list vector string object hash)
                    (number list vector string object hash)
                    (number list vector string object hash)
                    (number list vector string object hash)                 
                    (number list vector string object hash)
                    (number list vector string object hash)
                    (number list vector string object hash)))
 
  (defun pyel-get-possible-types (&rest args)
    "return a list in the form (arg types).
  The car is the argument and the cdr is a list of possible types"
  
    ;;FOR TESTING
    (let ((types (if (>= (length known-types) (length args))
                     known-types
                   (append known-types '(string number list vector integer float)))))
  
      (mapcar* (lambda (arg type) (cons arg type))
               args types)))

;;TODO: have functions saved in another file,
;;      instead of putting them all at the top of the file, have some type of
;;      require/import mechanism to functions are not constantly being redefined
;;    option to place insert function defs instead of requires
(defmacro pyel-create-py-func (name args &rest type-switches)
  "return the function name"
  ;;create a template that will resolve arg types and create a new function 
  
  ;;-determine if enough type info is available to eliminate testing
  ;;-if testing is necessary, use `pyel-do-call-transform' like function to generate
  ;; the testing and calling structure and put that in a function
  ;;-create defun code if not yet defined
  ;;  add new func name to defined code list
  
  ;;temp solution: does not check types etc
  `(def-transform ,name pyel ()
     (lambda ,args
       (let ((fsym (intern (concat "pyel-" (symbol-name ',name) "")))
             ;;      (body (pyel-do-call-transform (pyel-get-possible-types ,@(mapcar (lambda (x) `(quote ,x))args))
             (body (pyel-do-call-transform (pyel-get-possible-types ,@args)
                                           ',args
                                           ',type-switches))
             (known-types nil)) ;;tmp
         (unless (member fsym pyel-defined-functions)
           (push (list 'defmacro fsym ',args
                       body)
                 pyel-function-definitions)
           (push fsym pyel-defined-functions)
           (fset fsym (lambda () nil)))
         (cons fsym (mapcar 'eval ',args))))))

(defmacro pyel-method-transform (name args &rest type-switches)
  "define transforms for method calls on primative types"
  ;;method transforms are defined like normal type-transforms
  ;;when a method call is being transformed the name is looked up in the list
  ;;of defined method transforms, if it found, this transform will override
  ;;the normal transform.
  (add-to-list 'pyel-method-transforms name)
  ;;TODO: should name be modified to avoid conflicts ?
  `(def-transform ,(pyel-method-transform-name name) pyel () 
     (lambda ,args
       (let ((fsym (intern (concat "pyel-" (symbol-name ',name) "-method")))
             (body (pyel-do-call-transform (pyel-get-possible-types ,@args)
                                           ',args
                                           ',type-switches))
             (known-types nil)) ;;tmp -- should this be before 'body' is set!!??
         
         (unless (member fsym pyel-defined-functions)
           (push (list 'defmacro fsym ',args
                       body)
                 pyel-function-definitions)
           (push fsym pyel-defined-functions)
           (fset fsym (lambda () nil)))
         (cons fsym (mapcar 'eval ',args))))))

(defmacro pyel-func-transform (name args &rest type-switches)
  "define transforms for function calls"
  ;;function transforms are defined like normal type-transforms
  ;;when a function call is being transformed the name is looked up in the list
  ;;of defined function transforms, if it found, this transform will override
  ;;the normal function call transform.
  (add-to-list 'pyel-func-transforms name)
  ;;TODO: should name be modified to avoid conflicts ?
  `(def-transform ,(pyel-func-transform-name name) pyel () 
     (lambda ,args
       (let ((fsym (intern (concat "pyel-" (symbol-name ',name) "-function")))
             (body (pyel-do-call-transform (pyel-get-possible-types ,@args)
                                           ',args
                                           ',type-switches))
             (known-types nil)) ;;tmp -- should this be before 'body' is set!!??
         
         (unless (member fsym pyel-defined-functions)
           (push (list 'defmacro fsym ',args
                       body)
                 pyel-function-definitions)
           (push fsym pyel-defined-functions)
           (fset fsym (lambda () nil)))
         (cons fsym (mapcar 'eval ',args))))))


;;TODO: this should be more general to allow for things like subscript to use it

;;TODO: rename pyel-def-funcall -> pyel-create-py-func
(defmacro pyel-def-funcall (name args &rest type-switches)
  "Define how to call the function NAME.
      NAME is a function that is called differently based on its argument types.
      An attempt will be made to test the least possible number of types.
      
      This defines a transforms in the pyel transform table with NAME and ARGS"
  `(def-transform ,name pyel ()
     (lambda ,args
       (pyel-do-call-transform (pyel-get-possible-types ,@args)
                               ',args
                               ',type-switches))))

;;TODO: rename pyel-def-funcall -> pyel-def-type-transform
(defmacro pyel-def-type-transform (name args &rest type-switches)
  "Define a transform NAME that produces code based on the types of ARGS
    TYPE-SWITCHES
    
    This defines a transforms in the pyel transform table with NAME and ARGS"
  `(def-transform ,name pyel ()
     (lambda ,args
       (pyel-do-call-transform (pyel-get-possible-types ,@args)
                               ',args
                               ',type-switches))))

;; (defmacro pyel-def-call-func (name args &rest type-switches)
;;   "like `pyel-def-call-template' except that it generates a macro that
;; is called directly, because of this NAME must be unique"
;;   `(defun ,name ,args
;;      ;;   (let (,(mapcar (lambda (arg) `(,arg ',arg)) args))
;;      (pyel-do-call-transform (pyel-get-possible-types ,@args)
;;                              ',args
;;                              ',type-switches)))


(defun pyel-expand-type-switch (type-switch)
  "expands the types switch form to a list of cond clauses"
  (flet ((helper (arg form)
                 (let ((type (car form))
                       (varlist (cadr form))
                       mod types ret and-or)
                   (if (consp type)
                       (progn
                         ;;TODO: this can never be 'and'
                         (setq and-or (car type))
                         (dolist (tp (cdr type))
                           (push `((,arg ,tp) ,varlist) ret))
                         `(,and-or ,@(reverse ret)))
                     `((,arg ,type) ,varlist))))
         (expander (type-switch)
                   
                   
                   (let ((args (car type-switch))
                         (forms (cdr type-switch))
                         and-or ret inner tmp tests)
                     (if (consp args)
                         (progn
                           (setq and-or (car args)) ;;TODO: verify and/or
                           (if (eq and-or 'and)
                               (dolist (form forms)
                                 (setq tests nil)
                                 (dolist (arg (cdr args))
                                   (push (car (helper arg form)) tests))
                                 (push `(and ,(reverse tests) ,(cadr form)) ret))
                             ;;else == or
                             (dolist (form forms)
                               (dolist (arg (cdr args))
                                 (setq tmp (helper arg form))
                                 (if (equal (car tmp) 'or)
                                     (dolist (x (cdr tmp))
                                       (push x ret))
                                   (push (helper arg form) ret))))))
                       
                       ;;else single arg
                       (dolist (form forms)
                         (setq tmp (helper args form))
                         (if (equal (car tmp) 'or)
                             (dolist (x (cdr tmp))
                               (push x ret))
                           (push tmp ret))))
                     (reverse ret))))
    (let ((ret nil))
      (dolist (ts type-switch)
        (dolist (e (expander ts))
          (push e ret)))
      (reverse ret))))


;;TODO: fix bug with  `pyel-expand-type-switch-2'
;;      the arg pattern (x x) should not expand unless
;;      x is a possible type of both args


(defun pyel-expand-type-switch-2 (arglist patterns)
  "has output identical to `pyel-expand-type-switch' just translates
      different syntax"
  (let ((group nil) 
        (groups nil)
        (ngroups nil)
        (ret nil)
        code)
    
    
    ;;stage1: collect into groups
    (while patterns
      (setq p (pop patterns))
      
      (if (not (eq p '->))
          (push-back p group)
        (push-back (pop patterns) group)
        (push-back group groups)
        (setq group nil)))
    
    (dolist (g groups)
      (let* ((g (reverse g))
             (code (car g))
             (g (cdr g))
             ;;      (param-types (make-vector (length (car g)) nil))
             type)
        
        (dolist (arg-pattern (reverse g)) ;;for each arg pattern
          (setq group-patterns nil)
          (dotimes (i (length arg-pattern)) ;;for each type or '_
            (setq type (nth i arg-pattern))
            (if  (not (eq type '_))
                (push `((,(nth i arglist) ,type) ,code) group-patterns)))
          (if (null group-patterns) ;;all types where _
              (setq ret (append ret (list (list t code))))
            (if (= (length group-patterns) 1)
                (setq ret (append ret (reverse group-patterns)))
              (setq ret (append ret (list (cons 'and 
                                                (list (mapcar 'car
                                                              (reverse group-patterns))
                                                      code))))))))))
    ret))



(defun pyel-do-call-transform (possible-types args type-switch)
  "This is responsible for  producing a call to NAME in the most
        efficient way possible with the known types"
  (let* ((possible-types (let ((ret nil)
                               arg)
                           ;;get entries in form (arg . type)
                           (dolist (p-t possible-types)
                             (setq arg (car p-t))
                             (dolist (type (cdr p-t))
                               (push (cons arg type) ret)))
                           ret))
         (c 0)
         (new-args (loop for a in args
                         collect (intern (format "__%s__" (symbol-name a)))))
         ;;list of symbols to replace
         ;;format: (symbol replace)
         (let-vars (append (mapcar* (lambda (a b) (list a b))
                                    args new-args)
                           ))
         (arg-replacements (append let-vars
                                   (mapcar (lambda (x)
                                             (list  (intern (format "$%s" x)) (list '\, x)))
                                           args)))
         
         (ts ) ;;??
         (valid nil) ;;list of valid arg--types
         (found nil)
         (lets nil)
         var value type all-good var-vals len)
    ;;        (print "possible types = ")
    ;;        (print possible-types)
    
    
    ;;collect all the arg-type--code pairs that are valid possibilities,
    ;;that is, members of possible-types.
    ;;This essentially throws out all the arg types that have been ruled out.
    (dolist (t-s (pyel-expand-type-switch-2 args type-switch))
      (if (equal (car t-s) 'and)
          (progn (setq all-good t
                       found nil)
                 (dolist  (x (cadr t-s)) ;;for each 'and' member type-switch
                   (dolist (pos-type possible-types) ;;for each arg type
                     (if (and (equal (eval (car x)) (car pos-type)) 
                              (equal (cadr x) (cdr pos-type)))
                         (setq found t)))
                   (setq all-good (if (and all-good found) t nil)))
                 (when all-good
                   (push t-s valid)))
        ;;else
        (if (eq (car t-s) t) ;;when all types are _
            (push t-s valid)
          ;;otherwise check if the type is one of the valid types
          
          
          (dolist(pos-type possible-types)
            (when (and (equal (eval (caar t-s)) (car pos-type))
                       (equal (cadar t-s) (cdr pos-type)))
              (push t-s valid))))));;TODO: break if found?
    
    
    
    ;;generate code to call NAME
    ;;if there is 2 posible types, use IF. For more use COND
    (setq len (length valid))
    
    (flet (
           (replace (code replacements)
                    (let ((ret nil)
                          found)
                      
                      (dolist (c code)
                        (setq found nil)
                        (dolist (r replacements)
                          (if (consp c)
                              (setq c (replace c replacements))
                            (if (and (equal c (car r))
                                     (not found))
                                (progn (push (cadr r) ret)
                                       (setq found t)))))
                        (unless found
                          (push c ret)))
                      (reverse ret)))
           
           (type-tester (x) (cadr (assoc x pyel-type-test-funcs)))
           (and-type-tester (x) (cadr (assoc (car x) pyel-type-test-funcs)))
           (get-replacement (arg) ;;returns arg replacement
                            (cadr (assoc arg arg-replacements)))
           
           (gen-cond-clause (t-s--c) ;;Type-Switch--Code
                            (if (equal (car t-s--c) 'and)
                                `((and ,@(mapcar '(lambda (x)
                                                    ;;TODO: test
                                                    `(,(type-tester (cadr x))
                                                      ,(get-replacement
                                                        (car x))))
                                                 (cadr t-s--c)))
                                  ,(replace (caddr t-s--c) arg-replacements))
                              
                              ;;TODO
                              (if (equal (car t-s--c) t) ;;all types where _
                                  `(t ,(replace (cadr t-s--c) arg-replacements))
                                `((,(type-tester (cadar t-s--c))
                                   ,(get-replacement (caar  t-s--c)))
                                  ,(replace (cadr t-s--c) arg-replacements)
                                  ))))
           
           (gen-varlist ()
                        (mapcar (lambda (x) `(,(cadr x) ,(list '\, (car x))))
                                let-vars)
                        ))
      
      (cond ((<= len 0) "ERROR: no valid type")
            ((= len 1)
             (if (eq (caar valid) 'and)
                   ;;; (eval (caddar valid))
                 (caddar valid)
                 ;;;(eval  (cadar valid))
               (cadar valid)
               ))
            ;;?TODO: are there possible problems with evaluating the arguments
            ;;       multiple times? Maybe they should be put in a list
            (t (let* ((clauses (mapcar 'gen-cond-clause valid))
                      (clauses (if (eq (caar clauses) t)
                                   clauses
                                 (cons
                                  '(t (error "invalid type, expected <TODO>"))
                                  clauses)))
                      (varlist (gen-varlist)))
                 `(backquote (let ,varlist
                               (cond ,@(reverse clauses))))))))))


(defun call-transform (template-name &rest args)
  "expand TEMPLATE-NAME with ARGS in the same way that `transform' would
if was called as (transform '(template-name args))
NOTE: this calls `transform' on all ARGS, but not TEMPLATE-NAME"
  (eval `(transform '(,template-name ,@(mapcar 'transform args)))))

(defun file-path-concat (&rest dirs)
  "concatenate strings representing file paths
prevents multiple/none '/' seporating file names"
  (let* ((first (strip-end (car dirs) "/"))
         (last (strip-start (car (last dirs)) "/"))
         (dirs (append (list first)
                       (mapcar '(lambda (x)  (strip-start (strip-end x "/") "/")) 
                               (cdr (butlast dirs)))
                       (list last))))
    (mapconcat 'identity dirs "/")))

(require 'transformer)
(require 'pyel-transforms)
(require 'pyel-tests)
(require 'pyel-preprocessor)  

(require 'pyel-mode)

(provide 'pyel)
;;pyel.el ends here

(setq pyel-use-list-for-varargs t)
