
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

(make-transform-table 'pyel)

;; should not fset functions because the effect takes place globally
;; even when the name being set is let bound.
(pyel-dispatch-func set (_sym _val)
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
    ;;target transform via the variable assign-value.
    ;;assign-value is untransformed, the target transform must tranform it

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
        (attr (read (_to- (transform attr)))))

    ;;create slot for this attribute if it does not already exist
    (when (and (context-p 'method-def)
               (not (assoc attr class-def-slots)))
      (push `(,attr :initarg ,(intern (concat ":"
                                              (symbol-name attr)))
                    :initform nil)

            class-def-slots))
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
        ;;(list 'oset t-value attr (transform assign-value)) ;;assign target
        (list 'setattr t-value attr (transform assign-value)))
       ((eq ctx 'load) ;;assign value
        ;;(list 'oref t-value attr)
        (list 'getattr t-value attr))
       (t "Error in attribute-- invalid ctx"))
      )))

(def-transform num pyel ()
  (lambda (n &optional line col)
    n 
    ))

(def-transform name pyel ()
  (lambda (id ctx &optional line col)
    (pyel-name id ctx line col)))

(defun pyel-name (id ctx &optional line col)
  (let ((new-id)
        (id (read id))
        piece code)

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

      (when (and (not (context-p 'function-call))
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
                           (call-transform 'set id assign-value)))
       (t  "<ERROR: name>"))
      )))

(def-transform list pyel ()
  (lambda (elts ctx &optional line col)
    (pyel-list elts ctx line col)))

(defun pyel-list (elts ctx &optional line col)  ;;IGNORING CTX
  (if (context-p 'macro-call)
      (mapcar 'transform elts)
    (cons 'list (mapcar 'transform elts))))

(defvar pyel-dict-test 'equal "Test function for dictionaries")

(def-transform dict pyel ()
  (lambda (keys values &optional line col)
    (pyel-dict keys values line col)))

(defun pyel-dict (keys values line col) ;;TODO: move to lambda in template and create template vars
  (cons 'py-dict (mapcar* (lambda (key value)
                            (list key value))
                          (mapcar 'transform  keys)
                          (mapcar 'transform  values))))

(def-transform tuple pyel ()
  (lambda (elts ctx &optional line col) ;;Ignoring ctx for now
    (cons 'vector (mapcar 'transform elts))))

(def-transform str pyel ()
  (lambda (s &optional line col)
    ;;    (format "\"%s\"" s)
    s
    ))

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
                    (object _) -> (call-method l __gt__ r)
                    (vector vector) -> (pyel-vector-> l r)
                    )

;;TODO: other py types?

;;::Q does `string<' behave like < for strings in python?
(pyel-dispatch-func < (l r)
                    (number number) -> (< l r)
                    (string string) -> (string< l r)
                    (list list) -> (pyel-list-< l r)
                    (object _) -> (call-method l __lt__ r)
                    (vector vector) -> (pyel-vector-< l r))

(pyel-dispatch-func >= (l r)
                    (number number) -> (>= l r)
                    (string string) -> (pyel-string>= l r)
                    (list list)     ->  (pyel-list>= l r)
                    (object _) -> (call-method l __ge__ r)
                    (vector vector) -> (pyel-vector->= l r))

(pyel-dispatch-func <= (l r)
                    (number number) -> (<= l r)
                    (string string) -> (pyel-string<= l r)
                    (list list)     -> (pyel-list<= l r)
                    (object _) -> (call-method l __le__ r)
                    (vector vector) -> (pyel-vector-<= l r))

(pyel-dispatch-func != (l r)
                    (number number) -> (pyel-number!= l r)
                    (string string) -> (pyel-string!= l r)
                    (object _) -> (call-method l __ne__ r)
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
         (true-body (if (> (length body) 1)
                        (append (remove-context tail-context
                                                (mapcar 'transform
                                                        (or (subseq body 0 -1)
                                                            (list (car body)))))
                                (list (transform (car (last body)))))
                      (mapcar 'transform body)))
         (false-body (if (> (length orelse) 1)
                        (append (remove-context tail-context
                                                (mapcar 'transform
                                                        (or (subseq body 0 -1)
                                                            (list (car orelse)))))
                                (list (transform (car (last orelse)))))
                      (mapcar 'transform orelse))) 
         (progn-code (if (> (length true-body) 1)
                         '(@ progn)
                       '@)))

    `(if  ,(if (equal tst []) nil tst)

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
  (let ((t-func (using-context function-call
                               (transform func)))
        (keyword-args (using-context keywords-alist
                                     (mapcar (lambda (x) (transform (car x)))
                                             keywords)))
        new-func m-name f-name star-args kw-args)
    ;; (if (member t-func pyel-defined-classes)
    ;;     ;;instantiate an object and call its initializer
    ;;     `(let ((__c (,t-func ,(pyel-next-obj-name))))
    ;;        (--init-- __c ,@(mapcar 'transform args))
    ;;        __c)
    
    (if (eq (car func) 'attribute);;method call
        (if (and (member (setq m-name (read (caddr func)))
                         pyel-method-transforms)
                 (setq m-name (pyel-find-method-transform-name
                               m-name
                               (1+ (length args)))));;1+ because args does not include the object

            ;;this methods transform is overridden
            (progn
              ;;dynamic scoping saves the day again!
              (setq keyword-args keywords
                    star-args starargs
                    kw-args kwargs)

              (eval `(call-transform ',m-name
                                     ',(transform (cadr func))
                                     ,@(mapcar '(lambda (x) `(quote ,x)) args))))
          ;;normal method call
          (remove-context method-call-override
                          (using-context method-call
                                         `(,(transform func) ,@(remove-context method-call
                                                                               (mapcar 'transform args))))))

      (when (setq new-func (assoc t-func pyel-function-name-translations));;function call
        ;;translate name
        (setq t-func (cadr new-func)))

      ;;call function transform if one was defined
      (cond ((and keyword-args
                  (member t-func pyel-func-kwarg-transforms))
             ;;transform defined with `pyel-func-kwarg-transform'
             (eval `(call-transform ',(pyel-func-transform-name t-func t)
                                    ',keyword-args
                                    ,@(mapcar '(lambda (x) `(quote ,x)) args))))
            ((member t-func pyel-func-transforms)
             ;;transform defined with `pyel-func-transform'
             (eval `(call-transform ',(pyel-func-transform-name t-func)
                                    ;;',(transform (cadr func))
                                    ,@(mapcar '(lambda (x) `(quote ,x)) args))))
            

            ((member t-func pyel-func-transforms2)
             ;;transform defined with `pyel-define-function-translation'
             (eval `(call-transform ',(pyel-func-transform-name t-func)
                                    ;;,(mapcar '(lambda (x) `(quote ,x)) args)
                                    (mapcar 'transform args)
                                    keyword-args)))

             ;;normal function call
             ;;`(,t-func ,@(mapcar 'transform args))
             ;;TODO: this is dumb, convert `call-transform' to a macro?
             (t (eval `(call-transform 'fcall ,@(cons 't-func
                                                      (mapcar (lambda (x)
                                                                `(quote ,x))
                                                              (append args
                                                                      (mapcar 'car
                                                                              keywords))
                                                              )))))))))

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

  (let* ((args (mapcar 'transform args))
         (defaults (mapcar 'transform defaults)))

    ;;&optional
    (when defaults
      (setq defaults (mapcar* (lambda (arg default)
                                (setq arg (_to- arg))
                                (cons arg default))
                              (reverse args) (reverse defaults)))
        (setq args (append (subseq args 0 (- (length args) (length defaults)))
                           '(&optional)
                           defaults)))

    ;;&rest
    (when vararg
      (setq args (append args (list '&rest vararg)))
      (when (and (not pyel-use-list-for-varargs)
                 (context-p 'function-def))
        (push `(setq, vararg (list-to-vector ,vararg)) assign-defaults)))

    ;;&kwonly
    (when kwonlyargs
      (setq args (append args (cons '&kwonly
                                    (mapcar* 'cons
                                             (mapcar 'transform kwonlyargs)
                                             (mapcar 'transform kw_defaults))))))
                                    
    ;;&kwarg
    (when kwarg
      (setq args (append args (list '&kwarg kwarg))))

    args))

(def-transform arg pyel ()
  (lambda (arg annotation) ;;Ignoring annotation
    (read arg)))

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
  (let ((name (read (_to- name))))

    (when (context-p 'function-def)
      (push name let-arglist)) ;;do this before the let-arglists gets overridden for this transform

    (let* ((func 'def)
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
           (inner-defun (context-p 'function-def))
           (orig-name name)
           (decorators (mapcar 'transform decoratorlist))
           setq-code
           )

      (when (or (context-p 'lambda-def)
                (and inner-defun
                     (not (member '&kwarg args))))

        (setq decorators (cons 'pyel-lambda decorators)
              name nil))

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

        (t (setq last-line (using-context tail-context
                                          (transform (car (last body))))
                 first (subseq body 0 (1- (length body)))
                 first (if first
                           (mapcar 'transform first)
                         nil)
                 t-body (append first (list last-line)))

           ;;(setq t-body (transform-last-with-context
           ;;                'tail-context body))

           ;;remove variables from the let arglist that have been declared global
           (setq let-arglist (let (arglist) (mapcar (lambda (x)
                                                      (unless (or (member x global-vars)
                                                                  (member x args))
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

           `(,setq-code (,func ,name ,args ,decorators
                               ,docstring
                               ,@assign-defaults
                               (,let-arglist
                                (,@ret
                                 ,@t-body
                                 ))))
           ))))))

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
                    (object _)  -> (call-method l --mul-- r)
                    (string _)
                    (_ string)  -> (pyel-mul-num-str l r)
                    (_ _)       -> (* l r))

(pyel-dispatch-func + (lhs rhs)
                    (number _) -> (+ lhs rhs)
                    (string _) -> (concat lhs rhs)
                    (list _)   -> (append lhs rhs)
                    (object _) -> (call-method lhs --add-- rhs)
                    (_ number)  -> (+ lhs rhs)
                    (vector _)
                    (_ vector)  -> (vconcat lhs rhs)
                    (_ string) -> (concat lhs rhs)
                    (_ list)   -> (append lhs rhs))

(pyel-dispatch-func - (l r)
                    (number _) -> (- l r)
                    (object _) -> (call-method l --sub-- r)
                    (_ number) -> (- l r))

(pyel-dispatch-func ** (l r) ;;pow
                    (number _) -> (expt l r)
                    (object _) -> (call-method l --pow-- r)
                    (_ number) -> (expt l r))

(pyel-dispatch-func / (l r)
                    (number _) -> (pyel-div l r)
                    (object _) -> (call-method l --truediv-- r)
                    (_ number) -> (pyel-div l r))

(pyel-dispatch-func // (l r) ;;floored (normal) division
                    (number _) -> (/ l r)
                    (object _) -> (call-method l --floordiv-- r)
                    (_ number) -> (/ l r))

(pyel-dispatch-func ^ (l r) ;;bit xor
                    (number _) -> (logxor l r)
                    (object _) -> (call-method l --xor-- r)
                    (_ number) -> (logxor l r))

(pyel-dispatch-func & (l r) ;;bit and
                    (number _) -> (logand l r)
                    (object _) -> (call-method l --and-- r)
                    (_ number) -> (logand l r))

(pyel-dispatch-func | (l r) ;;bit or
                    (number _) -> (logior l r)
                    (object _) -> (call-method l --or-- r)
                    (_ number) -> (logior l r))

(pyel-dispatch-func % (l r)
                    (number _) -> (% l r)
                    (object _) -> (call-method l --mod-- r))

(defclass PySlice nil ;;TODO: name?
  ((start :initarg :start)
   (end :initarg :end)
   (step :initarg :step)))

(def-transform index pyel ()
  (lambda (value &optional line col)
    (transform value)))

(def-transform slice pyel ()
  (lambda (lower upper step)
    (PySlice "slice"
             :start (transform lower)
             :end (transform upper)
             :step (transform step))))

(def-transform subscript pyel ()
  (lambda (value slice ctx &optional line col)
    (pyel-subscript value slice ctx line col)))

(pyel-dispatch-func subscript-load-index (name value)
                    (list _) -> (nth value name)
                    (object _) -> (--getitem-- name value)
                    (vector _) -> (aref name value)
                    (string _) -> (char-to-string (aref name value))
                    (hash _) -> (gethash value name))

(pyel-dispatch-func subscript-load-slice (name start end step)
                    (object _ _ _) -> (--getitem-- name (PySlice "slice"
                                                                 :start start
                                                                 :end  end
                                                                 :step  step))
                    ;;TODO implement step
                    (_ _ _ _) -> (subseq name start end))

(pyel-dispatch-func subscript-store-slice (name start end step assign)
                    (object _ _ _) -> (--setitem-- name
                                                   (PySlice "slice"
                                                            :start start
                                                            :end  end
                                                            :step  step)
                                                   assign)

                    ;;TODO implement step
                    (_ _ _ _) -> (setf (subseq name start end) assign))

(pyel-dispatch-func subscript-store-index (name value assign)
                    (list _) -> (setf (nth value name) assign)
                    (object _) -> (--setitem-- name value assign)
                    (vector _) -> (setf (aref name value) assign)
                    (hash _) -> (puthash value assign name))
;;                  (string _) -> not supported in python

(defun pyel-subscript (value slice ctx &optional line col)
  (let* (;(value (transform value))
         (slice (transform slice))
         (ctx (cond ((context-p 'force-load) 'load)
                    ((context-p 'force-store) 'store)
                    (t (eval ctx))))
         start stop step)

    (when (object-p slice)
      (setq start (oref slice start)
            stop (oref slice end)
            step (oref slice step)))
    (if (eq ctx 'load)
        (if (object-p slice)
            (call-transform 'subscript-load-slice value start stop step) ;;load slice
          (call-transform 'subscript-load-index value slice)) ;;load index
      ;;else: store
      (if (object-p slice)
          (call-transform 'subscript-store-slice value start stop step assign-value)
        (call-transform 'subscript-store-index value slice assign-value)) ;;load index

      ;;      (test value start stop step assign-value)
      )))

(def-transform classdef pyel ()
  (lambda (name bases keywords starargs kwargs
                body decorator_list &optional line col)
    (pyel-defclass name bases keywords starargs kwargs
                   body decorator_list line col)))

(defun pyel-defclass (name bases keywords starargs kwargs
                           body decorator_list &optional line col)
  (let ((class-def-methods nil) ;; list of methods that are part of this class
        (class-def-slots nil) ;;list of slots that are part of this class
        (class-def-name (transform name))
        (t-bases (mapcar 'transform bases)))
    ;;transform body with the class-def context, the transformed code
    ;;will store its methods and slots in class-def-methods and class-def-slots
    ;;respectively.
    (when (context-p 'function-def)
      (push name let-arglist)
      (push '__defined-in-function-body t-bases))
    (remove-context
     function-def
     (using-context class-def
                    (add-to-list 'pyel-defined-classes name)
                    `(define-class ,name ,t-bases
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
                   (pyel-def "dkl" args body nil nil line col))))

(def-transform unary-op pyel ()
  (lambda (op operand &optional line col)
    (call-transform op operand)))

(pyel-dispatch-func not (x)
                    (object) -> (--not-- x) ;;?
                    (_) -> (not x))

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
  ;;this uses the inter-transform var 'comprehension-body'
  (assert (boundp 'comprehension-body)
          "`comprehension-body' must be defined for this transform")
  ;;TODO: ifs
  `(loop for ,(using-context for-loop-target
                             (transform target))
         in (py-list ,(transform iter))
         ,(if ifs
              (list '@ 'if
                       (cons (if (> (length ifs) 1)
                                 'and
                               '@)
                             (mapcar 'transform ifs)))
            pyel-nothing)
         do ,comprehension-body))

(def-transform list-comp pyel (elt generators)
  (lambda (elt generators &optional line col)
    (pyel-list-comp elt generators line col)))

(defun pyel-list-comp (elt generators &optional line col)
  (let* ((list-var '__list__)
         (comprehension-body `(setq ,list-var (cons ,(transform elt) ,list-var)))
         (i (length generators))
         code)
    ;;`comprehension-body' is an inter-transform var
    (while (> i 0)
      (setq i (1- i))
      ;;'comprehension-body' holds the inner code, and each transform
      ;; is the inner code for the preceding generator in 'generators'
      ;; (loop ... collect ...) produces a list, so no additional work is needed
      (setq comprehension-body (transform (nth i generators))))

    `(let ((,list-var nil))
       ,comprehension-body
       (reverse ,list-var))))

(def-transform dict-comp pyel (key value generators)
  (lambda (key value generators &optional line col)
    (pyel-dict-comp key value generators line col)))

(defun pyel-dict-comp (key value generators &optional line col)
  (let* ((hash-var '__dict__)
         (comprehension-body (list 'puthash (transform key)
                                   (transform value)
                                   hash-var))
         (i (length generators))
         code)
    (while (> i 0)
      (setq i (1- i))
      (setq comprehension-body (transform (nth i generators))))

    `(let ((,hash-var (make-hash-table :test 'equal)))
       ,comprehension-body
       ,hash-var)))

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
    (let ((tst (transform test)))
      `(if ,(if (equal tst []) nil tst)
           ,(transform body)
         ,(transform orelse)))))

(def-transform raise pyel ()
  (lambda (exc cause &optional line col)
    `(py-raise ,(transform exc)))) ;;TODO: ignoring cause

;;

(pyel-translate-function-name 'map 'mapcar)

(pyel-func-transform len (thing)
                     (hash)   -> (hash-table-count thing)
                     (object) -> (call-method thing --len--)
                     (_)      -> (length thing))

(push '(range py-range) pyel-function-name-translations)

(pyel-translate-function-name 'input 'read-string)

(defalias 'py-list 'pyel-list-function)
(pyel-func-transform list (object)
                     (string) -> (py-string-to-list object)
                     (object) -> (py-object-to-list object)
                     (vector) -> (py-vector-to-list object)
                     (hash)   -> (py-hash-to-list object)
                     (list)   -> (py-copy-list object))

(pyel-func-transform tuple (object)
                     (string) -> (py-string-to-vector object)
                     (list)   -> (py-list-to-vector object)
                     (vector) -> (py-copy-vector object)
                     (hash)   -> (py-hash-to-vector object)
                     (object) -> (py-object-to-vector object))

(pyel-translate-function-name 'hasattr 'obj-hasattr)

(pyel-translate-function-name 'isinstance 'obj-isinstance)

(pyel-func-transform str (thing)
                     (number) -> (number-to-string thing)
                     (string) -> (format "\"%s\"" thing)
                     (function) -> (py-function-str thing)
                     (list) -> (py-list-str thing)
                     (object) -> (call-method thing --str--)
                     (vector) -> (py-vector-str thing)
                     (hash) -> (py-hash-str thing)
                     (symbol) -> (symbol-name thing))

(pyel-translate-function-name 'str 'pyel-str)

(pyel-func-transform repr (thing)
                     (number) -> (number-to-string thing)
                     (string) -> (py-repr-string thing)
                     (function) -> (py-function-str thing)
                     (symbol) -> (pyel-symbol-str thing)
                     (list) -> (py-list-repr thing)
                     (object) -> (call-method thing --repr--)
                     (vector) -> (py-vector-str thing)
                     (hash) -> (py-hash-str thing))

(pyel-translate-function-name 'repr 'pyel-repr)

(pyel-translate-function-name 'hex 'py-hex)

(pyel-translate-function-name 'bin 'py-bin)

;;(pyel-translate-function-name 'print 'py-print)
(pyel-define-function-translation
 print
 `(py-print ,(cadr (assoc 'sep kwargs))
            ,(cadr (assoc 'end kwargs))
            nil ;;TODO: file=sys.stdout
            ,@args))

(pyel-define-function-translation
 pow
 (case (length args)
   (3 (list 'mod (list 'expt (car args) (cadr args)) (caddr args)))
   (2 (list 'expt (car args) (cadr args)))
   (t "ERROR") ;;TODO
   ))

(pyel-translate-function-name 'eval 'py-eval)

(pyel-translate-function-name 'type 'py-type)

(pyel-translate-variable-name 'int 'py-int)
(pyel-translate-variable-name 'float 'py-float)
(pyel-translate-variable-name 'tuple 'py-tuple)
(pyel-translate-variable-name 'dict 'py-dict)
(pyel-translate-variable-name 'list 'py-list)
(pyel-translate-variable-name 'string 'py-string)
(pyel-translate-variable-name 'bool 'py-bool)
(pyel-translate-variable-name 'type 'py-type)

(pyel-func-transform abs (object)
                     (number) -> (abs object)
                     (object) -> (call-method object --abs--))

(pyel-translate-function-name 'chr 'py-chr)

(pyel-translate-function-name 'ord 'py-ord)

(pyel-translate-function-name 'exit 'pyel-exit)

(pyel-func-transform int (object)
                     (string) -> (py-str-to-int object)
                     (number) -> (py-number-to-int object)
                     (object) -> (call-method object --int--))

(pyel-func-transform float (object)
                     (string) -> (py-str-to-float object)
                     (number) -> (py-number-to-float object)
                     (object) -> (call-method object --float--))

(pyel-func-kwarg-transform dict (kwargs)
                           (_)-> (pyel-alist-to-hash2 'kwargs))

(pyel-func-transform dict (&optional object)
                     (list)   -> (pyel-list-to-dict object)
                     (object) -> (pyel-object-to-dict object)
                     (vector) -> (pyel-vector-to-dict object)
                     (hash)   -> (copy-hash-table object))

(pyel-translate-function-name 'round 'py-round)

(pyel-func-transform enumerate (obj &optional start)
                     (list)   -> (pyel-enumerate-list obj start)
                     (string) -> (pyel-enumerate-string obj start)
                     (object) -> (pyel-enumerate-object obj start)
                     (vector) -> (pyel-enumerate-vector obj start)
                     (hash)   -> (copy-enumerate-hash obj start))

(pyel-define-function-translation
 interactive
 (setq interactive t))

(pyel-func-transform divmod (x y)
                     (_ float)
                     (_ float) -> (py-divmod-f x y)
                     (int int) -> (py-divmod-i x y)
                     (_ _)     -> (py-divmod x y))

(pyel-func-transform bool (object)
                     (object) -> (py-object-bool object)
                     (_) -> (py-bool object))

(pyel-func-transform iter (obj)
                     (list)   -> (py-list-iter obj)
                     (string) -> (py-string-iter obj)
                     (object) -> (py-object-iter obj)
                     (vector) -> (py-vector-iter obj)
                     (hash)   -> (py-hash-iter obj))

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
                           (hash) -> (pyel-dict-keys obj)
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
