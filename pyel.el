
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

;;  PYEL -> translate PYthon to Emacs Lisp

(add-to-list 'load-path "~/programming/pyel/")
(add-to-list 'load-path "~/programming/code-transformer/")
(require 'eieio)
(require 'cl)

;;other requires are at the end

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

(defvar pyel-ast-backtrace nil
  "python backtrace, set by `pyel' when a syntax error occurs")

(defun pyel-py-ast-file-name ()
  "return the full file name of py-ast.el"
  (file-path-concat pyel-directory "py-ast.py"))

(setq pyel-tmp-file-counter (random (/ most-positive-fixnum 10)))

(defun pyel (python &optional no-line-and-col-nums include-defuns py-ast-only)
  "translate PYTHON into Emacs Lisp.
PYTHON is a string.
include line and column nums in output unless NO-LINE-AND-COL-NUMS is non-nil
If PY-AST-ONLY, return the un-evaled ast.
If INCLUDE-DEFUNS, include the list of pyel defined functions in the output
  this is ignored if PY-AST-ONLY is non-nil"
  (assert (eq lexical-binding nil) "pyel requires dynamic scoping")

  ;;this is called recursively to transform code in macro bodies
  ;;so this cannot be cleared here - it removes previous work
  ;;(setq pyel-marked-ast-pieces nil)
  
  (setq pyel-transform-status nil) ;;so far so good...

  (setq pyel-last-python-code python)

  (let* ((py-ast "")
         (el-code "")
         (current-transform-table (get-transform-table 'pyel))
         (python (with-temp-buffer
                   (insert python)
                   (pyel-preprocess-buffer2)
                   (buffer-string)))
         (pyel-context nil)
         (type-env (pyel-make-type-env pyel-global-type-env))
         (tmp-file (format "/tmp/pyel-%s.py" (incf pyel-tmp-file-counter)))
         (ast-command (format "cd %s;./%s %s"
                              pyel-directory
                              "py-ast.py";(pyel-py-ast-file-name)
                              tmp-file))
         return-type line ret)

    (with-temp-buffer
      (insert python)
      (write-region
       nil
       nil
       tmp-file nil 'silent))

    (setq py-ast (shell-command-to-string ast-command))
    (setq _x py-ast)
    (if (setq py-error (pyel-is-error py-ast))
        (progn
          (setq pyel-ast-backtrace py-ast
                pyel-python-error-line py-error)
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
        ;;TODO: this is a temp solution for convenience
        (mapc 'eval pyel-function-definitions)
        (delete-file tmp-file)
        ret
        ))))

(defun pyel-file (file &optional el-file extras-file no-error compile)
  "Convert python FILE to e-lisp file named EL-FILE
EL-FILE defaults to FILE.el, if such a file exists, it will be
overwritten without warning
If EXTRAS-FILE is given, save all the pyel generated functions/macros
in it. If EXTRAS-FILE is 't', automatically create a file name with
the format FILE_pyel-extras.el. if EXTRAS-FILE is nil, save the
the generated functions at the top of the output file.
If COMPILE is non-nil, byte compile resulting e-lisp.
If "
  (let ((pyel-function-definitions nil)
        (pyel-defined-functions nil)
        (pyel-context nil)
        (el-file (or el-file (format "%s.el" file)))
        (extras-file (if extras-file
                         (if (eq extras-file t)
                             (format "%s_pyel-extras.el" (remove-file-extension
                                                          file))
                           extras-file)))
        python error)
    (with-temp-buffer
      (insert-file-contents file)
      (setq python (pyel (buffer-string) t t))
      (if (equal python pyel-error-string)
          (if no-error
              (setq error t)
            (error "pyel-load: Error loading file %s" file)))  ;;x
      (if (not error)
          (progn
            (erase-buffer)
            (emacs-lisp-mode)
            (mapc (lambda (x)
                    (insert (format "(require '%s)\n" x)))
                  pyel-required)
            (if extras-file
                (progn
                  (insert (format "(require '%s)\n\n"
                                  (file-name-base extras-file)))
                  (with-temp-buffer
                    (emacs-lisp-mode)
                    (mapc '(lambda (x)
                             (pyel-prettyprint x)
                             (insert "\n"))
                          (pyel-sort-functions
                           pyel-function-definitions))
                    (insert (format "(provide '%s)\n"
                                    (file-name-base extras-file)))
                    (write-file extras-file)))
              (mapc '(lambda (x)
                       (pyel-prettyprint x)
                       (insert "\n"))
                    (pyel-sort-functions
                     pyel-function-definitions)))

            (pyel-prettyprint python)
            (write-file el-file))))))

(defvar pyel-last-python-code nil
  "last python string `pyel' attempted to transform")

(defun pyel-buffer-to-lisp (&optional ast-only)
  "transform and return python in current buffer to emacs-lisp"
  (pyel (buffer-string) nil nil ast-only))

(defvar pyel-pp-function 'pp-to-string
  "function that pretty prints pyel e-lisp code")

;; (defun pyel-buffer (&optional out-buff)
;;   "transform python in current buffer and display in OUT-BUFF,
;; OUT-BUFF defaults to *pyel-output*"
;;   (interactive)
;;   (let ((out (pyel-buffer-to-lisp))
;;         (buff (or out-buff "*pyel-output*")))
;;       (switch-to-buffer-other-window buff)
;;       (erase-buffer)
;;       ;;    (insert (funcall pyel-pp-function out))
;;       (lisp-interaction-mode)
;;       (pyel-prettyprint out)
;;       (goto-char 1)
;;       ;;(emacs-lisp-mode)
;;       ))

(defun pyel-transform-ast (ast &optional no-splice)
  "transform a python AST to Emacs Lisp, AST must be a string
AST can be generated by `pyel' with (pyel py-string t)"
  (with-transform-table 'pyel
                        (let ((code (transform (read  (format "(@ %s)" ast)))))
                          (if no-splice
                              code
                            (pyel-do-splices code)))))

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

(defun py-ast (code &optional pp include-attributes python2)
  "Return the python abstract syntax tree for python CODE
useing python3 unless PYTHON2 is non-nil"
  (let ((py-ast "")
        (el-code "")
        ret)

    (with-temp-buffer
      (insert "import ast" "\n")
      (insert (format "print(ast.dump(ast.parse(\"\"\"%s\"\"\")%s))"
                      code
                      (if include-attributes ",include_attributes=True" "")))
      (write-region nil nil pyel-tmp-file nil 'silent))

    (setq ret (shell-command-to-string (format "python%s %s"
                                               (if python2 "" "3")
                                               pyel-tmp-file)))
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
      (let (c)
        (if (eq (car code) '@) ;;special case: outer most list
            (if (> (length code) 2)
                (pyel-do-splices `(progn ,code))
              (pyel-do-splices (cadr code)))
          (let ((ncode nil))
            (while code
              (setq c (pop code))
              (cond ((and (listp c) (not (listp (cdr c)))) ;;cons cell
                     (push (cons (pyel-do-splices (car c))
                                 (pyel-do-splices (cdr c))) ncode))
                    ((listp c)
                     (if (equal (car c) '@)
                         (setq ncode (append (reverse (pyel-do-splices (cdr c)))
                                             ncode))
                       (push (pyel-do-splices c) ncode)))
                    (t (push c ncode))))
            (if (listp ncode) (reverse ncode) ncode))))
    code))

(defun pyel-reload ()
  (interactive)
  (pyel-reset)
  (dolist (f '(pyel
               pyel-tests
               pyel-transforms
               pyel-mode
               pyel-pp
               pyel-preprocessor
               pyel-tests-generated
               py-lib
               transformer))
    (setq features (remove f features)))
  (require 'pyel))

(defun pyel-reset()
  "reset internal variables"
  (interactive)
  (setq pyel-method-name-arg-signature (make-hash-table :test 'eq)
        pyel-global-type-env (pyel-make-type-env)
        pyel-function-definitions nil
        pyel-defined-functions nil
        pyel-method-transforms nil
        pyel-func-transforms nil
        pyel-func-transforms2 nil
        pyel-marked-ast-pieces nil
        pyel-ast-backtrace nil        
        pyel-context nil))

(defvar pyel-method-name-format-string "_%s-method%s"
  "format string for the method transform names
It must accept two args, the name of the method
and its arg signature")

(defun pyel-method-transform-name (method-name &optional arglist)
  "Return the name of the temlate that transform the method METHOD-NAME.
    template names are modified to avoid potential conflict with other templates
  the arglist must be placed in a list before passing so that the code can
   tell if the arglist is empty or not provided. 
  ARGLIST is used to generate a name that is unique to that arglist signature"
  (assert (and (listp arglist) (listp (car arglist)))
          "Invalid arglist. Expected a list of a list")
  (let* ((signature (if arglist (pyel-arglist-signature (car arglist)) "_"))
         (name (format pyel-method-name-format-string
                       (symbol-name method-name) signature)))
    (if arglist
        (assert (equal (pyel-extract-arg-descriptor signature)
                       (pyel-arg-descriptor (car arglist)))
                "Invalid method name"))
    (intern name)))

(defun pyel-func-transform-name (func-name &optional kwarg)
  "like `pyel-method-transform-name' for functions"
  (intern (format "_%s%s-function_"
                  (if kwarg "-kwarg" "")
                  (symbol-name func-name))))

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

(defun pyel-replace-in-thing (from to thing)
  "replace character FROM to TO in THING
THING may be a symbol, string or list"
  (cond
   ;;tmp fix:
   ;;special case for numbers to handle being called
   ;;on the arg list in the def transform
   ;;(numbers are from the default values for kwonlyargs)
   ;;TODO: call _to- only on names, not such large lists
   ((numberp thing) thing)

   ((stringp thing)
    (replace-regexp-in-string from to  thing))
   ((symbolp thing)
    (intern (replace-regexp-in-string from to  (symbol-name thing))))
   ((and (listp thing) (listp (cdr thing)))
    (mapcar (lambda (x) (pyel-replace-in-thing from to x)) thing))
   ((listp thing) ;;cons cell
    (cons (pyel-replace-in-thing from to (car thing))
          (pyel-replace-in-thing from to (cdr thing))))
   (t (error "invalid thing"))))


(defun _to- (thing)
  (pyel-replace-in-thing "_" "-" thing))
(defun -to_ (thing)
  (pyel-replace-in-thing "-" "_" thing))

(defun pyel-change-ctx (form ctx)
  "change ctx of form to CTX"
  (let ((type (and (listp form) (car form))))
    (cond ((eq type 'name)
           (list (car form) (cadr form) (list 'quote ctx)))
          ;;TODO: attribute and other forms (if needed)
          (t form))))

(defun pyel-make-ast (type &rest args)
  "Generate pyhon ast.
This is used when the ast form is needed by a transform that is manually
 called from another transform"
  (flet ((assert_n_args (type expect have)
                        (assert (= expect have)
                                (format "pyel-make-ast -- ast type '%s'expects %s args. received %s args" type expect have)))
         (correct_ctx (ctx)
                      (if (symbolp ctx)
                          (pyel-make-ast ctx)
                        ctx))
         (correct_to_string (name)
                            (if (stringp name)
                                name
                              (if (symbolp name)
                                  (symbol-name name)
                                (error "invalid type for 'name'")))))

    ;;TODO: should have seporate functions to check
    ;;      the validity of the ast instead of having
    ;;      the correction functions do it
    (case type

      (subscript ;;args: value slice ctx
       (assert_n_args 'subscript 3 (length args))

       (let ((ctx (correct_ctx (car (last args)))))
         (list 'subscript (car args) (cadr args) ctx)))

      (name ;;args: name ctx
       (assert_n_args 'name 2 (length args))
       (let* ((name (correct_to_string (car args)))

              (ctx (correct_ctx (car (last args)))))

         (list 'name name ctx)))
      (load
       '(quote load))
      (store
       '(quote store)))))

(defmacro macrop (sym)
  (if (boundp sym)
      (list 'macrop-1 sym)
    `(macrop-1 (quote ,sym))))

(defun macrop-1 (function)
  ;;this is mostly taken from `describe-function-1'
  (let* ((advised (and (symbolp function) (featurep 'advice)
                       (ad-get-advice-info function)))
         ;; If the function is advised, use the symbol that has the
         ;; real definition, if that symbol is already set up.
         (real-function
          (or (and advised
                   (let ((origname (cdr (assq 'origname advised))))
                     (and (fboundp origname) origname)))
              function))
         ;; Get the real definition.
         (def (if (symbolp real-function)
                  (symbol-function real-function)
                function)))
    (eq (car-safe def) 'macro)))

(defun callable-p (object)
  (if (symbolp object)
      (or (fboundp object)
          (functionp object)) ;;necessary?
    (functionp object)))

(defun pyel-split-list (lst sym)
  "split list LST into two sub-lists at separated by SYM
  The return value is the two sub-lists consed together"
  (let ((current (not sym))
        first)
    
    (while (and (not (eq current sym))
                lst)
      (setq current (pop lst))
      (push current first)
      )
    
    (cons (reverse (if (eq (car first) sym) (cdr first) first)) lst)))


(defun pyel-eval-last-sexp-1-function (eval-last-sexp-arg-internal)
  "Evaluate sexp before point; print value in minibuffer.
With argument, print output into current buffer.

This function is redefined to print python objects in a
reasonable manner. The origional definition has been stored
in `pyel-orig-eval-last-sexp-1'"
  (let ((standard-output (if eval-last-sexp-arg-internal (current-buffer) t))
        (val (eval (eval-sexp-add-defvars (preceding-sexp)) lexical-binding)))
    ;; Setup the lexical environment if lexical-binding is enabled.
    (if (and pyel-object-prettyprint
             (fboundp 'py-object-p)
             (py-object-p val))
        (setq val (pyel-repr val)))
    (eval-last-sexp-print-value val)))

(fset 'pyel-orig-eval-last-sexp-1 'eval-last-sexp-1)
(fset 'eval-last-sexp-1 'pyel-eval-last-sexp-1-function)

(defvar pyel-object-prettyprint t
  "if non-nil, objects will be printed with their pyel repr value
during interactive emacs-lisp sessions where possible")
        
(defun pyel-toggle-object-prettyprint ()
  (interactive)
  (setq pyel-object-prettyprint (not pyel-object-prettyprint)))

(defun pyel-get-generated-function (name)
  "return the generated function/macro definition for NAME"
  (get-matching-item pyel-function-definitions
                     (lambda (x) (eq (cadr x) name))))

(defun pyel-strip-leading-nil (list)
  "remove all nil items from the front of LIST until the first non-nil item"
  (while (and (not (null list))
              (not (car list)))
    (setq list (cdr list)))
  list)

(defun pyel-strip-trailing-nil (list)
  "remove all nil items from the back of LIST until the last non-nil item"
  (setq list (reverse list))
  (while (and (not (null list))
              (not (car list)))
    (setq list (cdr list)))
  (reverse list))

(defun filter (func list)
  (let ((newlist ()))
    (dolist (e list)
      (if (funcall func e)
          (setq newlist (cons e newlist))))
    (reverse newlist)))

(defvar pyel-directory ""
  "Path to pyel files. must include py-ast.py, pyel.el etc")

(defmacro vfunction-p (f)
  `(and (boundp ',f)
        (functionp ,f)))

(defmacro pyel-empty-list-p (list)
  `(eq ,list 'py-empty-list))

(set (defvar pyel-type-test-funcs nil
       "alist of types used in pyel-call-transform for the switch-type
            and the function used to test for that type")
     '((string stringp)
       (number numberp)
       (integer integerp)
       (int integerp)
       (float floatp)
       (vector vectorp)
       (empty-list pyel-empty-list-p)
       (list listp)
       (cons consp)
       (hash hash-table-p)
       (hash-table hash-table-p)
       (symbol symbolp)
       (array arrayp)
       ;;         (object object-p)
       (class py-class-p)
       (instance py-instance-p)
       (object py-object-p)
       (function functionp)
       (func fboundp)
       (vfunction vfunction-p)
       (vfunc vfunction-p)
       (callable callable-p)))

(defvar pyel-negated-function-tests nil
  "A list of automatically created negated functions from `pyel-type-test-funcs'
  stored here just for convenient inspection")

;;create negated test functions
(let (new func fname)
  (setq pyel-negated-function-tests nil)
  (mapc (lambda (x)
          (setq name (cadr x)
                !name (intern (concat "!" (symbol-name name)))
                func `(defsubst ,!name (x) (not (,name x))))
          (add-to-list 'pyel-negated-function-tests func)
          (eval func)
          (push (list (intern (concat "!" (symbol-name (car x))))
                      !name)
                new))
        pyel-type-test-funcs)
  (setq pyel-type-test-funcs (append pyel-type-test-funcs new)))

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

(defvar pyel-func-kwarg-transforms nil
  "list of function names that have kwarg transforms defined for them")

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
        (pyel-fully-functional-functions nil)
        ;;(pyel-method-transforms nil)
        ;;(pyel-func-transforms nil)
        (pyel-marker-counter 0)))

(defvar pyel-marker-counter 0)

(defvar pyel-tmp-file  "/tmp/pyel-ast.py"
  "Name of temp file to use for AST generation")

(defvar pyel-interactive nil
  "non-nil during interactive session translation and evaluation")

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
     (let (_using-context_ret_)
       (condition-case err
           (setq _using-context_ret_ (progn ,@code))
         (error (pop pyel-context)
                (error (format "context %s: %s" ',context err))))
       (pop pyel-context)
       _using-context_ret_)))

(def-edebug-spec using-context (symbolp &rest form))

(defmacro remove-context (context &rest code)
  "remove CONTEXT and translate CODE, then restore context"
  `(let ((pyel-context (remove ',context pyel-context)))
     ,@code))

(def-edebug-spec remove-context (symbolp &rest form))

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

(defvar pyel-type-declaration-function '_pyel_declare_type_
  "name of the function that is used to communicate variable types
to the pyel translator.
Type declarations are replaced with a call to this function.")

(setq pyel-type-declaration-function2 (_to- pyel-type-declaration-function))

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
(defsubst pyel-env-set (sym val env)
  (puthash sym val (pyel-env-get-ht env)))
(defsubst pyel-env-set-parent (env parent)
  (aset env pyel-env-parent parent))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;function type
;;  in type environments, function symbols get
;;  mapped to these function types
(defsubst pyel-make-func-type (func-type arg-type return-type)
  (vector func-type arg-type return-type))
(defsubst pyel-func-func-type (function-type)
  (aref function-type 0))
(defsubst pyel-func-args-type (function-type)
  (aref function-type 1))
(defsubst pyel-func-return-type (function-type)
  (aref function-type 2))
(defsubst pyel-is-func-type (type)
  (and (vectorp type) (= (length type) 3)))

(defun pyel-env-get (sym env)
  "return a list of possible types for SYM in ENVironment"
  (let ((val (gethash sym (pyel-env-get-ht env)))
        parent)
    (if val
        val
      (if (setq parent (pyel-env-get-parent env))
          (pyel-env-get sym parent)))))

(defvar pyel-global-type-env (pyel-make-type-env)
  "global type environment used for type Reconstruction")

(defmacro pyel-declare-el-func (function returns)
  `(pyel-declare-el-func-fn ',function ',returns))

(defun pyel-declare-el-func-fn (function returns)
  (assert (symbolp function) "FUNCTION name must be a symbol")
  ;;TODO: check that RETURNS is valid
  (setq returns (if (or (eq returns 'any)
                        (eq returns nil))
                    pyel-possible-types
                  returns))
  (pyel-env-set function
                (pyel-make-func-type function nil returns)
                pyel-global-type-env))

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
      '(length))

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

(defvar pyel-last-transform nil
  "name of the last transform that was expanded with
`pyel-do-call-transform'")

(defun pyel-filter-non-args(args)
  "remove '&optional' and '&rest' from ARGS list"
  (filter (lambda (x) (not (or (eq x '&optional)
                               (eq x '&rest))))
          args))

(defmacro pyel-dispatch-func (name args &rest type-switches)
  "Define a transform that creates a runtime function that
dispatches on argument type as defined by TYPE-SWITCHES.
The transform will have the same NAME and ARGS and must be called with a
function like `call-transform', it will return a call to
the function it creates.
After the resulting transform is called, it adds the name of the
created function in `pyel-defined-functions' and adds the function 
definition to `pyel-function-definitions'

Use `pyel-func-transform' to define transforms for functions that
will be automatically called.

NOTE: if the name of the function to be created is already in
 `pyel-defined-functions', the function will not be updated
"
  ;;temp solution: does not check types etc
  (let* ((striped-args (mapcar 'strip_ args))
         (args-just-vars (pyel-filter-non-args striped-args))
         (rest-arg (if (eq (car (last striped-args 2)) '&rest)
                       (car (last striped-args)) nil))
         (non-rest (if rest-arg (subseq striped-args 0 -2)))
         (name-base (concat "pyel-" (symbol-name name) ""))
         ;;(fsym (intern (concat "pyel-" (symbol-name name) "")))
         )

    `(def-transform ,name pyel ()
       (lambda ,striped-args
         (setq pyel-last-transform ',name)
         (let ((body (pyel-do-call-transform (pyel-get-possible-types
                                              ;;,(cons 'list args-just-vars))
                                              ,(if rest-arg
                                                   `(append ,(cons 'list non-rest)
                                                            ,rest-arg)
                                                 (cons 'list args-just-vars)))
                                               ',args
                                             ',type-switches))
               (_pyel_name (intern (concat ,name-base
                                     (number-to-string _pyel-type-sig))))
               ;;(_pyel_name (intern ,name-base ))
               )
           (unless (member _pyel_name pyel-defined-functions)
             (push (list 'defmacro _pyel_name ',striped-args
                         body)
                   pyel-function-definitions)
             (push _pyel_name pyel-defined-functions)
             (fset _pyel_name (lambda () nil)))
           (cons _pyel_name ,(if rest-arg
                           `(append (list ,@(subseq args-just-vars 0 -1)) ,rest-arg)
                         (cons 'list args-just-vars))))))))

(defmacro pyel-method-transform (name args &rest type-switches)
  "Defines a transform for methods that dispatches on NAME and ARG length.
The syntax and the function creation is the same as with `pyel-dispatch-func'.
These transforms are automatically called for methods during translation time.
The transform will be dispatched on NAME and the possible number
of arguments that ARGS allows.
During translation time, if no transform is found for a method call that
matches NAME and has the proper arg length then no transform will be called."
  (add-to-list 'pyel-method-transforms name)

  ;;temp solution: does not check types etc
  (let* ((striped-args (mapcar 'strip_ args))
         (args-just-vars (pyel-filter-non-args striped-args))
         (rest-arg (if (eq (car (last striped-args 2)) '&rest)
                       (car (last striped-args)) nil))
         (non-rest (if rest-arg (subseq striped-args 0 -2)))
         (name-base (format "pyel-%s-method%s"
                            (symbol-name name)
                            (pyel-arglist-signature args)))
         (transform-name (pyel-method-transform-name name (list args))))

    (pyel-add-method-name-sig name args)
    
    `(def-transform ,transform-name pyel ()
       (lambda ,striped-args
         (setq pyel-last-transform ',name)
         (let ((body (pyel-do-call-transform (pyel-get-possible-types
                                              ,(if rest-arg
                                                   `(append ,(cons 'list non-rest)
                                                            ,rest-arg)
                                                 (cons 'list args-just-vars)))
                                             ',args
                                             ',type-switches))
               (_pyel_name (intern (concat ,name-base
                                     (number-to-string _pyel-type-sig)))))

           (unless (member _pyel_name pyel-defined-functions)
             (push (list 'defmacro _pyel_name ',striped-args
                         body)
                   pyel-function-definitions)
             (push _pyel_name pyel-defined-functions)
             (fset _pyel_name (lambda () nil)))
           (cons _pyel_name ,(if rest-arg
                             `(append (list ,@(subseq args-just-vars 0 -1)) ,rest-arg)
                           (cons 'list args-just-vars))))))))

(defmacro pyel-func-transform (name args &rest type-switches)
  (add-to-list 'pyel-func-transforms name)
  ;;TODO: should name be modified to avoid conflicts ?
  `(pyel-func-transform-1 ,name ,args nil ,@type-switches))

(defmacro pyel-func-kwarg-transform (name args &rest type-switches)
  (add-to-list 'pyel-func-kwarg-transforms name)
  `(pyel-func-transform-1 ,name ,args t ,@type-switches))

(defmacro pyel-func-transform-1 (name args is-kwarg-transform &rest type-switches)
  "Define a transform for function calls.
This is just like `pyel-method-transform' except that the
ARG signature has no effect on the transform dispatch"
  
  (let* ((striped-args (mapcar 'strip_ args))
         (args-just-vars (pyel-filter-non-args striped-args))
         (rest-arg (if (eq (car (last striped-args 2)) '&rest)
                       (car (last striped-args)) nil))
         (non-rest (if rest-arg (subseq striped-args 0 -2)))
         (name-base (concat "pyel-"
                            (symbol-name name) "-"
                            (if is-kwarg-transform "kwarg-" "")
                            "function")))
    `(def-transform ,(pyel-func-transform-name name is-kwarg-transform) pyel ()
       (lambda ,striped-args
         (setq pyel-last-transform ',name)
         (let ((body (pyel-do-call-transform (pyel-get-possible-types
                                              ,(if rest-arg
                                                   `(append ,(cons 'list non-rest)
                                                            ,rest-arg)
                                                 (cons 'list args-just-vars)))
                                             ',args
                                             ',type-switches))
               ;;NOTE: if the way this name is constructed changes,
               ;; the aliases for py-list, pyel-str-function,
               ;; and pyel-repr-function will have to be updated.
               (name (intern (concat ,name-base
                                     (number-to-string _pyel-type-sig)))))
           (unless (member name pyel-defined-functions)
             (push (list 'defmacro name ',striped-args
                         body)
                   pyel-function-definitions)
             (push name pyel-defined-functions)
             (fset name (lambda () nil)))
           (cons name ,(if rest-arg
                           `(append (list ,@(subseq args-just-vars 0 -1)) ,rest-arg)
                         (cons 'list args-just-vars))))))))

(defvar pyel-func-transforms2 nil
  "list of functions whose translations are defined
with the macro `pyel-define-function-translation'")

(defmacro pyel-define-function-translation (name &rest body)
  "BODY will form the body of a function that is called during transform time
to tranlate a call to NAME, variables 'args' and 'kwargs'  are available at
this point. 'args' will be a list and 'kwargs will be an alist
This is called at the same time `pyel-func-transform' would be called"
  (add-to-list 'pyel-func-transforms2 name)

  `(def-transform ,(pyel-func-transform-name name) pyel ()
     (lambda (args kwargs)
       ,@body
       )))

;;TODO: this should be more general to allow for things like subscript to use it

(defmacro pyel-def-funcall (name args &rest type-switches)
  "Define how to call the function NAME.
      NAME is a function that is called differently based on its argument types.
      An attempt will be made to test the least possible number of types.

      This defines a transforms in the pyel transform table with NAME and ARGS"
  `(def-transform ,name pyel ()
     (lambda ,args
       (setq pyel-last-transform ',name)
       (pyel-do-call-transform (pyel-get-possible-types ,(cons 'list args))
                               ',args
                               ',type-switches))))

;;TODO: rename pyel-def-funcall -> pyel-def-type-transform
(defmacro pyel-def-type-transform (name args &rest type-switches)
  "Define a transform NAME that produces code based on the types of ARGS
    TYPE-SWITCHES

    This defines a transforms in the pyel transform table with NAME and ARGS"
  `(def-transform ,name pyel ()
     (lambda ,args
       (setq pyel-last-transform ',name)
       (pyel-do-call-transform (pyel-get-possible-types ,(cons 'list args))
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

(defun pyel-remove-nil (list)
  "remove all nil items from LIST"
  (let ((new nil))
    (dolist (e list)
      (when e
        (setq new (cons e new))))
    (reverse new)))

(defvar _pyel-type-sig 0
  "set by `pyel-do-call-transform'. Its value uniquely describes
which types swiches where successful eliminated from the most
recent transform. It is a binary number ranging from 1 to 2^n, where n
is the number of type switches. Each digit corresponds to a type switch
(in order), a value of 1 indicates that the type switch was included.")



(defun pyel-do-call-transform (possible~types args type-switch)
  "This is responsible for  producing a call to NAME in the most
      efficient way possible with the known types"

  ;; the args of the type transform are evaled here so there must
  ;; be no conflicts with the naming of internal variables
  ;; To avoid such conflicts, the let bound variables are all
  ;; defined with a tilde

  (let* ((n~args (length possible~types))
         (possible~types (let (ret arg)
                           ;;get entries in form (arg . type)
                           (dolist (p-t possible~types)
                             (setq arg (car p-t))
                             (dolist (type (cdr p-t))
                               (push (cons arg type) ret)))
                           ret))
         ;;if there is one possible type for every arg then we don't need to
         ;;use the default case unless the default is the only matchine case
         (use~default~p (not (= n~args (length possible~types))))
         (args~just~vars (pyel-filter-non-args (mapcar 'strip_ args)))
         (new~args (loop for a in args
                         collect (if (or (eq a '&optional)
                                         (eq a '&rest)
                                         (string-match-p "\\(^_\\)\\(.+\\)"
                                                         (symbol-name a))) nil
                                   (intern (format "__%s__" (symbol-name a))))))
         (arg~replacements4 (let (ar)
                              (mapcar (lambda (x) (if (string-match-p "\\(^_\\)\\(.+\\)"
                                                                      (symbol-name x))
                                                      (push (list (strip_ x) (list '\, (strip_ x))) ar)))

                                      args)
                              ar))
         ;;list of symbols to replace
         ;;format: (symbol replace)
         (let~vars (let (lv) (mapcar* (lambda (a b) (if b
                                                        (push (list a b) lv)))
                                      args new~args)
                        lv))
         ;;strip any leading underscores
         (args~ (mapcar (lambda (a)
                          (if (string-match "\\(^_\\)\\(.+\\)" (symbol-name a))
                              (intern (match-string 2 (symbol-name a))) a))
                        args))

         ;;the __x__ type replacements interfere with the (\, x) type replacements
         ;;so they must be seporated and done one at a time
         (arg~replacements1 let~vars)
         (arg~replacements2 (mapcar (lambda (x)
                                      (list  (intern (format "$%s" x)) (list '\, x)))
                                    args~just~vars))
         (arg~replacements3 (mapcar (lambda (x)
                                      (list (intern (format "$$%s" x)) (list 'quote (list '\, x))))
                                    args~just~vars))
         (arg~replacements (append arg~replacements1 arg~replacements2))

         (arg~quote~replacements (mapcar (lambda (x)
                                           (list x (list '\, x)))
                                         args~just~vars))
         ;;replacements for the case in which all types are known and nothing
         ;;is let-bound, arg~quote~replacements must come first
         (all~known~replacements (append arg~quote~replacements
                                         arg~replacements3
                                         arg~replacements2))
         (current~replace~list nil)
         
         ;; (arg~replacements (append let~vars
         ;;                           (mapcar (lambda (x)
         ;;                                     (list  (intern (format "$%s" x)) (list '\, x)))
         ;;                                   args~)))

         (c~ 0)
         (n -1)
         valid~ ;;list of valid arg--types
         found~ all~good len~ default~ default~n)

    (setq _pyel-type-sig 0)
    
    ;;collect all the arg-type--code pairs that are valid possibilities,
    ;;that is, members of possible~types.
    ;;This essentially throws out all the arg types that have been ruled out.
    (dolist (t~s (pyel-expand-type-switch-2 args~just~vars type-switch))
      (incf n)
      (if (equal (car t~s) 'and)
          (progn (setq all~good t)
                 (dolist  (~x (cadr t~s)) ;;for each 'and' member type-switch
                   (setq found~ nil) 
                   (dolist (pos~type possible~types) ;;for each arg type
                     (if (and (equal (eval (car ~x)) (car pos~type))
                              (pyel-type-compare (cadr ~x) (cdr pos~type)))
                         (setq found~ t)))
                   (setq all~good (if (and all~good found~) t nil)))
                 (when all~good
                   (push t~s valid~)
                   (setq _pyel-type-sig (logior _pyel-type-sig (expt 2 n)))))
        ;;else
        (if (eq (car t~s) t);when all types are _
            (progn (setq default~ t~s
                         default~n n))
          ;;otherwise check if the type is one of the valid types
          (dolist (pos~type possible~types)
            (when (and (equal (eval (caar t~s)) (car pos~type))
                       (pyel-type-compare (strip$ (cadar t~s)) (cdr pos~type)))
              (push t~s valid~);TODO: break if found?
              (setq _pyel-type-sig (logior _pyel-type-sig (expt 2 n))))))));

    (when (and (or (= (length valid~) 0)
                 use~default~p)
             default~)
        (push default~ valid~)
        (setq _pyel-type-sig (logior _pyel-type-sig (expt 2 default~n))))
        
    ;;generate code to call NAME
    ;;if there is 2 posible types, use IF. For more use COND
    (setq len~ (length valid~))

    (cond ((<= len~ 0)
           (error "unable to match dispatch types: %s" pyel-last-transform))
          ((= len~ 1)
           ;;there is only one possibility, so replace the args with their
           ;;quoted counterpart instead of replacing with the let bound vars
           (list 'backquote (pyel-replace-backquoted (if (eq (caar valid~) 'and)
                                                         (caddar valid~)
                                                       (cadar valid~))
                                                     all~known~replacements)))
          
          ;;?TODO: are there possible problems with evaluating the arguments
          ;;       multiple times? Maybe they should be put in a list
          (t (let* ((clauses (mapcar 'pyel-gen-cond-clause valid~))
                    (clauses (if (eq (caar clauses) t)
                                 clauses
                               (cons
                                '(t (error "invalid type, expected <TODO>"))
                                clauses)))
                    (varlist (pyel-gen-varlist)))
               `(backquote ,(if varlist
                                `(let ,varlist
                                   (cond ,@(reverse clauses)))
                              `(cond ,@(reverse clauses)))))))))

(defsubst pyel-type-compare (switch-type possible-type)
  (if (eq switch-type 'object)
      (or (eq possible-type 'instance)
          (eq possible-type 'class)
          (eq possible-type 'object))
    (eq switch-type possible-type)))

;;helper functions for pyel-do-call-transform
(defun pyel-replace (code replacements)
  (let ((ret nil)
        found)
    (dolist (c code)
      (setq found nil)
      (if (consp c)
          (push (pyel-replace c replacements) ret)
        (dolist (r replacements)
          (if (and (equal c (car r))
                   (not found))
              (progn (push (cadr r) ret)
                     (setq found t))))
        (unless found
          (push c ret))))
    (reverse ret)))

(defun pyel-replace-backquoted (code replacements)
  "only replace in code that is backquoted.
unquote or splice regions are ignored"
  ;;TODO: nested backquotes
    (let ((ret nil)
          found)
      (dolist (c code)
        (setq found nil)
        (if (and (consp c)
                 (not (eq (car c) '\,))
                 (not (eq (car c) '\,@)))
            (push (pyel-replace c replacements) ret)
          (dolist (r replacements)
            (if (and (equal c (car r))
                     (not found))
                (progn (push (cadr r) ret)
                       (setq found t))))
          (unless found
            (push c ret))))
      (reverse ret)))

(defsubst pyel-type-tester (x)
  (cadr (assoc x pyel-type-test-funcs)))

(defsubst pyel-and-type-tester (x)
  (cadr (assoc (car x) pyel-type-test-funcs)))

(defsubst pyel-get-replacement (arg) ;;returns arg replacement
  (cadr (assoc arg current~replace~list)))

;;bug fix maybe...
(defsubst pyel-get-replacement-OLD (arg) ;;returns arg replacement
  (or (cadr (assoc arg arg~replacements))
      (cadr (assoc arg arg~replacements4))))

;;replaces the vars, one type at a time
(defun pyel-replace-vars (code)
  (let* ((current-replace-list arg~replacements1)
         (code (pyel-replace code arg~replacements1))
         (current-replace-list arg~replacements2)
         (code (pyel-replace code arg~replacements2))
         (current-replace-list arg~replacements3))
    (pyel-replace code arg~replacements3)))

(defun pyel-gen-cond-clause (t-s--c) ;;Type-Switch--Code
  (if (equal (car t-s--c) 'and)
      (progn `((and ,@(mapcar '(lambda (x)
                                 ;;TODO: test
                                 `(,(pyel-type-tester (cadr x))
                                   ,(pyel-get-replacement-OLD
                                     (car x))))
                              (cadr t-s--c)))
               ,(pyel-replace-vars (caddr t-s--c))))

    ;;TODO
    (progn (if (equal (car t-s--c) t) ;;all types where _
               `(t ,(pyel-replace-vars (cadr t-s--c)))
             (let* ((str (symbol-name (cadar t-s--c)))
                    (quote-arg-p (string-match-p "\\(^\\$\\)\\(.+\\)"
                                                 str))
                    (type (if quote-arg-p (intern (match-string 2 str)) (cadar t-s--c)))
                    (tester (pyel-type-tester type))
                    (body (pyel-replace-vars (cadr t-s--c)))
                    (arg (pyel-get-replacement-OLD (caar t-s--c))))
               `((,tester ,(if quote-arg-p (list 'quote (list '\, (caar t-s--c))) arg))
                 ,body))))))

(defsubst pyel-gen-varlist ()
  (mapcar (lambda (x) `(,(cadr x) ,(list '\, (car x))))
          let~vars))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun pyel-get-trans--type (form)
  "return a cons cell with the form (transformed . type) where
'transformed is the transformed value of FORM and 'type' is the
possible type or types of FORM"
  (let* (t-form
         (type (if (symbolp form)
                   (progn (setq t-form form)
                          (pyel-env-get form type-env))
                 (setq t-form (using-context return-type?
                                             (transform form)))
                 return-type)))
    (if (pyel-is-func-type type)
        (setq type (pyel-func-return-type type)))
    (if (null type)
        ;;if type is not known, it could be anything
        (setq type pyel-possible-types))    
    ;;type for form must be a list
    (if (listp type)
        (cons t-form type)
      (cons t-form (list type)))))

(defun call-transform (template-name &rest args)
  "expand TEMPLATE-NAME with ARGS in the same way that `transform' would
if was called as (transform '(template-name args))
NOTE: this calls `transform' on all ARGS, but not TEMPLATE-NAME"
  (let (t-args) ;;t-args is set by 
    (setq known-types (mapcar (lambda (x)
                                (setq x (pyel-get-trans--type x)
                                      t-args (cons (car x) t-args))
                                (cdr x))
                              args)

          t-args (reverse t-args))
    (eval `(transform '(,template-name ,@(mapcar 'transform args))))))


(defun call-transform-no-trans (template-name &rest args)
  "like call-transform, except that ARGS are not transformed"
  (eval `(transform '(,template-name ,@args))))  

(defun strip$ (sym)
  (let ((str (symbol-name sym)))
    (if (string-match "\\(^\\$\\)\\(.+\\)" str)
        (intern (match-string 2 str))
      sym)))
(defun strip_ (sym)
  (let ((str (symbol-name sym)))
    (if (string-match "\\(^_\\)\\(.+\\)" str)
        (intern (match-string 2 str))
      sym)))

(defun pyel-arg-descriptor (arglist)
  "return the number of values that may be passed to ARGLIST
If ARGLIST contains &optional or &rest then return a cons of
the min and max values that may be passed.

This does not check if ARGLIST has a valid form"

  (let ((min 0)
        (max 0)
        optional)
    (when arglist
      (if (member '&rest arglist)
          (setq max 'I
                arglist (subseq arglist 0 -2)))
      (if (member '&optional arglist)
          (setq optional (pyel-split-list arglist '&optional)
                min (length (car optional)) ;;positional args
                max (if (eq max 'I) max
                      (+ min (length (cdr optional))))) ;;optional args
        (setq min (length arglist)
              max (if (eq max 'I)
                      max
                    min))))
    (if (or (equal min max)
            (and (= min 0)
                 (eq max 'I)))
        max
      (cons min max))))

(defun pyel-arglist-signature (arglist)
  (let ((num (pyel-arg-descriptor arglist)))
    (format "->%s<-" (if (or (numberp num)
                             (eq num 'I))
                         num
                       (format "%s~%s" (car num) (cdr num))))))

(defun pyel-extract-arg-descriptor (name)
  "extract the arglist descriptor from name"

  (assert (stringp name) "Name must be a string")
  (if (symbolp name) (setq name (symbol-name name)))
  (let (min max I?)
    (cond ((string-match "->\\([0-9I]+\\)<-" name)
           (setq min (match-string 1 name)
                 max min))

          ((string-match "->\\([0-9]+\\)~\\([0-9I]+\\)<-" name)
           (setq min (match-string 1 name)
                 max (match-string 2 name))))

    (if min
        (setq I? (intern max)
              max (if (eq I? 'I) 'I (string-to-number max))
              min (string-to-number min)))

    (cond ((null min) nil)
          ((or (equal min max)
               (and (= min 0)
                    (eq max 'I)))
           max)
          (t (cons min max)))))

(defun pyel-arg-descriptor-to-signature (descriptor)
  (format "->%s<-" (if (or (numberp descriptor)
                           (eq descriptor 'I))
                       descriptor
                     (format "%s~%s" (car descriptor) (cdr descriptor)))))

(defvar pyel-method-name-arg-signature (make-hash-table :test 'eq)
  "mapping of method transform names to a list of argument signatures")

(defun pyel-add-method-name-sig (name args)
  "Add the argument signature of ARGS to NAME in `pyel-method-name-arg-signature'"
  (let* ((signatures (gethash name pyel-method-name-arg-signature)))
    (add-to-list 'signatures (pyel-arg-descriptor args))
    (puthash name signatures pyel-method-name-arg-signature)))

(defun pyel-find-method-transform-name (name num-args)
  "find a matching method transform for NAME with NUM-ARGS
will return the name of the first match"
  (let ((signatures (gethash name pyel-method-name-arg-signature))
        found min max)
    (if signatures
        (progn (while signatures
                 (setq sig (car signatures)
                       signatures (cdr signatures))

                 (if (or (and (numberp sig)
                              (= sig num-args))

                         (eq sig 'I)

                         (and (consp sig)
                              (setq min (car sig)
                                    max (cdr sig))
                              (and (>= num-args min)
                                   (or (<= num-args max)
                                       (eq max 'I)))))
                     (setq signatures nil
                           found sig)))
               (if found
                   (intern (format pyel-method-name-format-string
                                   name
                                   (pyel-arg-descriptor-to-signature found)))))
      (error "method transform %s does not exist in the signature table"
             name))))

(defvar pyel-translation-messages nil
  "collects messages during pyel translations")

(defvar pyel-message-formats '((error "ERROR: %s")
                               (warn "WARNING: %s")
                               (recommend "RECOMMENDATION: %s"))
  "alist of message type and their format strings")

(defun pyel-notify (type msg)
  "add MSG to `pyel-translation-messages', TYPE specifies the format string
in `pyel-message-formats'"
  (push (format (or (cadr (assoc type pyel-message-formats))
                    (format "[%s]: %%s" (upcase (symbol-name type))))
                msg) pyel-translation-messages))

(defun pyel-skip-whitespace ()
  (skip-chars-forward " \t\n\r"))

(defun char-at-point ()
  (buffer-substring-no-properties (point) (1+ (point))))

(defun read-tree-positions ()
  "Create a tree of buffer positions corresponding to the source tree at the point
format [start end list-of-sub-trees] list-of-sub-trees is nil for leaves"
  (pyel-skip-whitespace)
  (let ((start (point))
        inner)
    (goto-char (1+ start))
    (setq inner (read-list-positions)) ;;asssumes we start on a list
    (vector start (point) inner)))

(defun read-list-positions ()
  (let (start end elems)
    (condition-case nil
        (while t
          (pyel-skip-whitespace)
          (setq start (point))
          (if (string= (char-at-point) "(")
              (push (get-tree-positions) elems)
            (setq end (scan-sexps start 1))
            (push (vector start end nil) elems)
            (goto-char end)))
      (scan-error (goto-char (1+ start))))
    (reverse elems)))

(defmacro pyel-string-nth (string index)
  (list 'substring string index
        (if (numberp index) (1+ index) (list '1+ index))))

(defsubst pyel-nth (n seq)
  (let ((tp (type-of seq)))
    (cond ((eq tp 'cons)
           (nth n seq))
          ((eq tp 'vector)
           (aref seq n))
          ((eq tp 'string)
           (substring seq n (1+ n))))))

(defun char-split-string (string)
  "split a string into its charaters"
  (cdr (butlast (split-string string ""))))


(defun strip-end (string &optional char)
  "if CHAR occurs at the end of STRING, remove it"
  (let ((split (char-split-string string))
        (char (or char " ")))
    
    (while (string= char (car (last split)))
      (setq split (butlast split)))
    (mapconcat 'identity split "")))

(defun strip-start (string &optional char)
  "if CHAR occurs at the beginning of STRING, remove all occurrences"
  (let ((split (char-split-string string))
        (char (or char " ")))
    
    (while (string= char (car split))
      (setq split (cdr split)))
    (mapconcat 'identity split "")))

;;built-in equivalent?
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
(require 'pyel-tests-generated)
(require 'pyel-preprocessor)

(require 'py-objects)
(require 'pyel-mode)
(require 'py-lib)
(require 'pyel-testing)

(pyel "this_fixes_a_bug") ;;prevents errors the first time pyel-run-tests is run
;;...I'm so sorry

(load "pyel.py")
(load "py-iter.py")
(provide 'pyel)
;;pyel.el ends here

(setq pyel-use-list-for-varargs t)
;;(setq pyel-directory "path/to/pyel/directory")
;;(require 'pyel)
