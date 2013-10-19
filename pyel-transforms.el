
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

(make-transform-table 'pyel)

(def-transform assign pyel ()
    (lambda (targ val) (py-assign targ val)))
  
 ;;TODO: put all setq's in a single form: (setq a 1 b 2) etc

(defun py-assign (targets values)
  
  ;;make sure targets and lists are both in a list form
  (let ((wrap-values t))
    (if (and (listp (car targets))
             (eq (caar targets) 'tuple))
        (progn
          
          (if (eq (car values) 'tuple)
              (progn 
                (setq values (cadr values))
                (setq wrap-values nil))
            ;;(setq values (list values))
            )
          
          (setq targets (cadar targets))))
    
    (when wrap-values
      (setq values (list values)))
    
    
    ;;py-sssign2 does the main transforms
    ;;TODO: check for the special case a,b=b,a and create temp variables
    ;;TODO: check that legnth of the lists are the same
    
    (if (= (length targets) 1)
        (py-assign2 (car targets) (car values))
      (let* ((tmp-vars (loop for i from 1 to (length targets)
                             collect (intern (format "__%s__" i))))
             (let-vars (mapcar* (lambda (a b)
                                  (list a (transform b)))
                                tmp-vars values)))
        `(let ,let-vars
           ,(cons '@ (mapcar* 'py-assign2 targets tmp-vars)))))))


;;DOC: tranforms must be carefull not to transform code multiple times

(defun py-assign2 (target value)
  (let ((ctx (eval (car (last target))))

        (assign-value value)) 

    ;;the target code is reponsable for providing the correct assign function
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
  (lambda (value attr ctx)
    (pyel-attribute value attr ctx)))

(defun pyel-attribute (value attr ctx)
  (setq ctx (eval ctx))
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
                       `(@ ,attr ,(transform value)))
      
      
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
        (list 'oset t-value attr (transform assign-value))) ;;assign target
       ((eq ctx 'load) ;;assign value
        (list 'oref t-value attr))
       (t "Error in attribute-- invalid ctx"))
      )))

(def-transform num pyel ()
  (lambda (n)
    n
    ))

(def-transform name pyel ()
  (lambda (id ctx)
    (pyel-name id ctx)))

(defun pyel-name (id ctx)
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
      
      (when (setq new-id (assoc id pyel-variable-name-translations))
        (setq id (cadr new-id)))
      
      (when (and (eq ctx 'store)
                 (context-p 'function-def)
                 (context-p 'assign-target))
        (add-to-list 'let-arglist id))
      
      (cond 
       ((eq ctx 'load) id)
       ((eq ctx 'store)  (if (context-p 'for-loop-target)
                             id
                           (list 'setq id (transform assign-value))))
       (t  "<ERROR: name>"))
      )))

(def-transform list pyel ()
    (lambda (elts ctx)
      (pyel-list elts ctx)))
  

(defun pyel-list (elts ctx)  ;;IGNORING CTX
  (if (context-p 'macro-call)
      (mapcar 'transform elts)
    (cons 'list (mapcar 'transform elts))))

(defvar pyel-dict-test 'equal "test function for dictionaries")

(def-transform dict pyel ()
  (lambda (keys values)
    (pyel-dict keys values)))


(defun pyel-dict (keys values) ;;TODO: move to lambda in template and create template vars 
  (if keys

      `(let ((__h__ (make-hash-table :test ',pyel-dict-test))) ;;default length??
         ,(cons '@ (mapcar* (lambda (key value)
                                       `(puthash ,key ,value __h__))
                                     (mapcar 'transform  keys)
                                     (mapcar 'transform  values)))
         __h__)
    
    `(make-hash-table :test ',pyel-dict-test)))

(def-transform tuple pyel ()
  (lambda (elts ctx) ;;Ignoring ctx for now
    (cons 'vector (mapcar 'transform elts))))

(def-transform str pyel () 
  (lambda (s)
;;    (format "\"%s\"" s)
    s
    ))



;; (def-transform compare pyel ()
;;   (lambda (left ops comparators)
;;     ;;what if comparators has multiple items?
;;     `(,(read (car ops)) ,(transform left) ,(transform (car comparators)))))


(def-transform compare pyel ()
  (lambda (left ops comparators)
    ;;what if comparators has multiple items?
    (call-transform (read (car ops))
                    ;;,(transform left) ,(transform (car comparators)))))
                    ;;(transform left) (transform (car comparators)))))
                    left (car comparators))))

(pyel-create-py-func == (l r)
                     (number number) -> (= l r)
                     (string string) -> (string= l r)
                     ;;                       (object _) -> (--eq-- l r)
                     
                     (_ _) -> (equal l r))

(pyel-create-py-func > (l r)
                     (number number) -> (> l r)
                     (string string) -> `(and (not (string< l r)) (not (string= l r)))
                     (object _) -> (__gt__ l r))
;;TODO: other py types?
;;::Q does `string<' behave like < for strings in python?
(pyel-create-py-func < (l r)
                     (number number) -> (< l r)
                     (string string) -> (string< l r)
                     (object _) -> (__lt__ l r))
;;TODO: other py types?

(pyel-create-py-func >= (l r)
                     (number number) -> (>= l r)
                     (string string) -> (not (string< l r))
                     (object _) -> (__ge__ l r))

(pyel-create-py-func <= (l r)
                     (number number) -> (<= l r)
                     (string string) -> (or (string< l r) (string= l r))
                     (object _) -> (__le__ l r))

(pyel-create-py-func != (l r)
                     (number number) -> (not (= l r))
                     (string string) -> (not (string= l r))
                     (object _) -> (__ne__ l r)
                     (_ _) -> (not (equal l r)))
                                        ;

(def-transform if pyel ()
  (lambda (test body orelse)
    (let ((tst (transform test)))
      (setq _x tst)
      `(if  ,(if (equal tst []) nil tst)
              ;;?TODO: Have option to optimize in cases like this.
              ;;       Just include the else statements, if any
              (progn ,@(mapcar 'transform body))
              ,@(mapcar 'transform orelse)))))

(defvar pyel-obj-counter 0)

(defun pyel-next-obj-name ()
  (if pyel-unique-obj-names
      (format "obj-%d" (setq pyel-obj-counter (1+ pyel-obj-counter)))
    "obj"))

(def-transform call pyel ()
  ;;TODO: some cases funcall will need to be used, how to handle that?
  (lambda (func args keywords starargs kwargs)
    (pyel-call func args keywords starargs kwargs)))


(defun pyel-call (func args keywords starargs kwargs)
  (let ((t-func (transform func))
        new-func m-name  f-name )
    (if (member t-func pyel-defined-classes)
        ;;instantiate an object and call its initializer
        `(let ((__c (,t-func ,(pyel-next-obj-name))))
           (--init-- __c ,@(mapcar 'transform args))
           __c)
      (if (eq (car func) 'attribute)
          ;;method call
          
          (if (member (setq m-name (read (caddr func)))
                      pyel-method-transforms)
              ;;this methods transform is overridden
              ;;TODO:(?) check for correct number of arguments?
              (eval `(call-transform ',(pyel-method-transform-name m-name)
                                     ',(transform (cadr func))
                                     ,@(mapcar '(lambda (x) `(quote ,x)) args)));;Transform these args?
            ;;normal method call
            (using-context method-call
                           `(,(transform func) ,@(mapcar 'transform args))))
        
        ;;function call
        (when (setq new-func (assoc t-func pyel-function-name-translations))
          ;;translate name 
          (setq t-func (cadr new-func)))
        
        ;;TODO: check if there is a function transform defined
        (if (member t-func pyel-func-transforms)
            ;;this function transform is overridden
            (eval `(call-transform ',(pyel-func-transform-name t-func)
                                   ;;',(transform (cadr func))
                                   ,@(mapcar '(lambda (x) `(quote ,x)) args)))
          
          ;;normal function call
          `(,t-func ,@(mapcar 'transform args)))))))

;;doc: context macro-call
(defun pyel-while (test body orelse)
  ;;pyel-while is special. it gets to handle the macro definitions
  (let* ((tst (transform test))
         (else (mapcar 'transform orelse))
         break-code 
         continue-code
         macro-name
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
      (setq code (using-context while (mapcar 'transform body))
            break-code (if break-while '(catch '__break__)
                         pyel-nothing)
            continue-code (if continue-while '(catch '__continue__)
                            pyel-nothing)
            wile `(,@break-code
                   (while
                       ,(if (equal tst []) nil tst)
                     (,@continue-code
                      ,@code))))
      (if else
          `(@ ,wile ,@else)
        wile))))



;; (defun pyel-while (test body orelse)
;;   (let* ((tst (transform test))
;;          (else (mapcar 'transform orelse))
;;          (wile `(while ,(if (equal tst []) nil tst)
;;                   ,@(mapcar 'transform body))))
    
;;     (if else
;;         `(@ ,wile ,@else)
;;       wile)))

(def-transform while pyel ()
  (lambda (test body orelse)
    (pyel-while test body orelse)))

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

    ;;create default assignment code
    (when (and defaults
               (context-p 'function-def))
      
      ;;`assign-defaults' only exists under function-def context
      (setq assign-defaults (mapcar* (lambda (arg default)
                                       `(setq ,arg (or ,arg ,default)))
                                     (reverse args) (reverse defaults))))
    
    ;;&optional
    (when defaults
      (insert-at args (- (length args) (length defaults)) '&optional))
    ;;&rest
    (when vararg
      (setq args (append args (list '&rest vararg)))
      (when (and (not pyel-use-list-for-varargs)
                 (context-p 'function-def))
        (push `(setq, vararg (list-to-vector ,vararg)) assign-defaults)))
    
    args))

(def-transform arg pyel ()
  (lambda (arg annotation) ;;Ignoring annotation
    (read arg)))


(def-transform def pyel ()
  (lambda (name args body decoratorlist returns)
    (pyel-def name args body decoratorlist returns)))

(defun transform-last-with-context (context code)
  ;;TODO: this does not work: fix and replace code in `pyel-def
  (let*  ((last-line (using-context context
                           (transform (car (last code)))))
           (first (mapcar 'transform (subseq code 0 (1- (length code))))))
     (append first (list last-line))))

(defun pyel-def (name args body decoratorlist returns)
  (let* ((name (read (_to- name)))
         (func 'defun)
         t-body
         arglist

         ;;trans-template vars
         (assign-defaults (list pyel-nothing));;holds assignment code set by the arguments transform
         return-middle 
         let-arglist
         global-vars
         docstring
          ;;;
         (ret pyel-nothing)
         (args (using-context function-def (transform (car args))))
         )

    (when (context-p 'lambda-def)
      (setq func 'lambda
            name pyel-nothing))
    
    (using-context
     function-def
     (context-switch
      (class-def (using-context method-def
                                (setq last-line (using-context last-function-line
                                                               (transform (car (last body))))
                                      first (mapcar 'transform (subseq body 0 (1- (length body))))
                                      t-body (append first (list last-line)))

                                ;;TODO: let-arlist for methods like
                                ;;      and *args ...
                                (push `(defmethod ,name
                                         ((,(car args) ,class-def-name)
                                          ,@(cdr args))
                                         
                                         ,@t-body)
                                      class-def-methods)))

      (t (setq last-line (using-context last-function-line
                                    (transform (car (last body))))
               first (subseq body 0 (1- (length body)))
               first (if first
                         (mapcar 'transform first)
                       nil)
               t-body (append first (list last-line)))
         
       ;;(setq t-body (transform-last-with-context
        ;;                'last-function-line body))
                
          ;;remove variables from the let arglist that have been declared global
          (setq let-arglist (let (arglist) (mapcar (lambda (x)
                                                     (unless (member x global-vars)
                                                       (push x arglist)))
                                                   let-arglist)
                                 arglist))
          ;;      ?remove variables that are defined in emacs?

          (setq docstring 
                (if (stringp (car t-body))
                    (pop t-body)
                  pyel-nothing))
          
          (when return-middle
            (setq ret '(catch '__return__)))
          
          (if let-arglist
                `(,func ,name ,args
                        ,docstring
                        ,@assign-defaults
                        (let ,let-arglist;;TODO: use lexical-let ??
                          (,@ret
                          ,@t-body
                          )))
            `(,func ,name ,args
                    ,docstring 
                    ,@assign-defaults
                    (,@ret
                     ,@t-body)))
          )))))

(def-transform bin-op pyel ()
    (lambda (left op right)
      (call-transform op left right)))
  
  
(pyel-create-py-func * (l r)
                    (number number) ->  (* l r)
                    (object _)      
                    (_ object)      -> (--mul-- l r)
                    (_ string)
                    (string _)      -> (pyel-mul-num-str l r))
  
  (pyel-create-py-func + (lhs rhs)
                    ;;this presumes that both args are the same type
                    (number number)  -> (+ lhs rhs)
                    (string _)
                    (_ string)       -> (concat lhs rhs)
                    (list _)
                    (_ list)         -> (append lhs rhs)
                    (vector _)
                    (_ vector)       -> (vconcat lhs rhs) ;;faster way?
                    ;;should the right side be checked if its an object?
                    (object _)
                    (_ object)       -> (--add-- lhs rhs));;correct way to call it?
  

(pyel-create-py-func - (l r)
                  (number number) -> (- l r)
                  (object _)
                  (_ object) -> (--sub-- l r))


(pyel-create-py-func ** (l r) ;;pow
                  (number number) -> (expt l r)
                  (object _)
                  (_ object) -> (--pow-- l r))



(pyel-create-py-func / (l r)
                     ;; (float _)
                     ;; (_ float) -> (/ l r)
                     (number _)
                     (_ number) -> (/ (* l 1.0) r)
                     (object _) -> (--truediv-- l r))
;;                    (_ object) ;;?


(pyel-create-py-func // (l r) ;;floored (normal) division 
                     (number _)
                     (_ number) -> (/ l r)
                     (object _) -> (--floordiv-- l r))
;;                    (_ object) ;;?

(pyel-create-py-func ^ (l r) ;;bit xor
                  (number number) -> (logxor l r)
                  (object _)
                  (_ object) -> (--xor-- l r))

(pyel-create-py-func & (l r) ;;bit and
                  (number number) -> (logand l r)
                  (object _)
                  (_ object) -> (--and-- l r)) ;;?

(pyel-create-py-func | (l r) ;;bit or
                  (number number) -> (logior l r)
                  (object _)
                  (_ object) -> (--or-- l r));;?


(pyel-create-py-func % (l r) ;;bit or
                     (number number) -> (% l r)
                     (object _) -> (--mod-- l r));;?

(defclass PySlice nil ;;TODO: name?
  ((start :initarg :start)
   (end :initarg :end)
   (step :initarg :step)))


(def-transform index pyel ()
  (lambda (value)
    (transform value)))

(def-transform slice pyel ()
  (lambda (lower upper step)
    (PySlice "slice"
             :start (transform lower)
             :end (transform upper)
             :step (transform step))))


(def-transform subscript pyel ()
  (lambda (value slice ctx)
    (pyel-subscript value slice ctx)))

(pyel-create-py-func subscript-load-index (name value) 
                     (list _) -> (nth value name)
                     (object _) -> (--getitem-- name value)
                     (vector _) -> (aref name value)
                     (string _) -> (char-to-string (aref name value))
                     (hash _) -> (gethash value name))


(pyel-create-py-func subscript-load-slice (name start end step)
                     (object _ _ _) -> (--getitem-- name (PySlice "slice"
                                                                   :start start
                                                                   :end  end
                                                                   :step  step))
                     ;;TODO implement step
                     (_ _ _ _) -> (subseq name start end))

(pyel-create-py-func subscript-store-slice (name start end step assign)
                     (object _ _ _) -> (--setitem-- name
                                                    (PySlice "slice"
                                                             :start start
                                                             :end  end
                                                             :step  step)
                                                    assign)
                     
                     ;;TODO implement step
                     (_ _ _ _) -> (setf (subseq name start end) assign))

(pyel-create-py-func subscript-store-index (name value assign) 
                     (list _) -> (setf (nth value name) assign)
                     (object _) -> (--setitem-- name value assign)
                     (vector _) -> (setf (aref name value) assign)
                     (hash _) -> (puthash value assign name))
;;                  (string _) -> not supported in python



(defun pyel-subscript (value slice ctx)
  (let* ((value (transform value))
         (slice (transform slice))
         (ctx (eval ctx))
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
  (lambda (name bases keywords starargs kwargs body decorator_list)
    (pyel-defclass name bases keywords starargs kwargs body decorator_list)))

(defun pyel-defclass (name bases keywords starargs kwargs body decorator_list)
  (let ((class-def-methods nil) ;; list of methods that are part of this class
        (class-def-slots nil) ;;list of slots that are part of this class
        (class-def-name (transform name)))

    ;;transform body with the class-def context, the transformed code
    ;;will store its methods and slots in class-def-methods and class-def-slots
    ;;respectively.
    (setq _x body)
    (using-context class-def

                   (add-to-list 'pyel-defined-classes name)
                   
                   (setq body (mapcar 'transform body))
                   (setq _x body)

                   ;;add default initializer if one has not been defined
                   (unless (member '--init-- (mapcar 'cadr class-def-methods))
                     (push (read (format pyel-default--init--method name))
                           class-def-methods))
                   
                   `(@ (defclass ,class-def-name  () ;; ,bases ??
                         (,@(reverse class-def-slots))
                         "pyel class")
                       
                       ,@(reverse class-def-methods)))))

(def-transform assert pyel ()
  (lambda (test msg) 
    (pyel-assert test msg)))

(defun pyel-assert (test msg)
    `(assert ,(transform test) t ,(transform msg)))

(pyel-method-transform append (obj thing)
                  (list _) -> (setq $obj (append obj (list thing)))
                  (_ _)    -> (append obj thing))

(pyel-func-transform len (thing)
                     (object) -> (--len-- thing)
                     (_)      -> (length thing))

(push '(range py-range) pyel-function-name-translations)

(pyel-translate-function-name 'map 'mapcar)

(pyel-translate-function-name 'input 'read-string)

;;

(pyel-method-transform extend(obj thing)
                  (list _) -> (setq $obj (append obj thing))
                  (_ _)    -> (append obj thing))

(pyel-method-transform insert (obj i x)
                       (list _) -> (let () (setq $obj (append (subseq obj 0 i)
                                                              (list x)
                                                              (subseq obj i))))
                       (object _) -> (insert obj i x))

(pyel-method-transform index (obj elem)
                  (list _) -> (list-index elem obj)
                  (string _) -> (string-match elem obj);;TODO: this uses regex, python does not
                  (vector _) -> (vector-index elem obj)

                  (object _)    -> (__index__ obj thing)) ;;?

(pyel-method-transform remove (obj x)
                       (list _) ->  (let ((i (list-index x obj)))
                                      (if i
                                          (setq $obj (append (subseq obj 0 i)
                                                             (subseq obj (1+ i))))
                                        (error "ValueError: list.remove(x): x not in list")))
                       (object _) -> (remove obj x))

(pyel-method-transform count (obj elem)
                  (string _) -> (count-str-matches obj elem)
                  (list _) -> (count-elems-list obj elem)
                  (vector _) -> (count-elems-vector obj elem)
                  (object _)  -> (count thing));;

;;

;;

(def-transform for pyel ()
  (lambda (target iter body orelse)
    (pyel-for target iter body orelse)))

;;TODO: for a,y in thing: ...
;;TODO: check if iter is an object, then do the iterator thing
(defun pyel-for (target iter body orelse)
  (if (eq (car target) 'tuple)
      "TODO: var unpacking"
    ;;create a temp target variable
    ;;in body, unpack that into the provided target variables

    (let* ((continue-for nil)
           (break-for nil)
           (code (using-context for (mapcar 'transform body)))
           (break-code (if break-for '(catch '__break__)
                         pyel-nothing))
           (continue-code (if continue-for '(catch '__continue__)
                            pyel-nothing)))
      (setq _x break-for)
      `(,@break-code
        (loop for ,(using-context for-loop-target
                                  (transform target))
              in ,(transform iter)
              do (,@continue-code
                  ,@(mapcar 'transform body)))
        ,@(mapcar 'transform orelse)))))

(def-transform global pyel ()
  (lambda (names)
    (if (context-p 'function-def)
        (progn (mapc (lambda (x) (add-to-list 'global-vars x)) names)
               pyel-nothing)
      (pyel-not-implemented "'global' calls outside of function definitions"))))

(def-transform lambda pyel ()
  (lambda (args body)
    (using-context lambda-def
                   (pyel-def "dkl" args body nil nil))))

;;

(def-transform aug-assign pyel (target op value)
  (lambda (target op value)
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

(def-transform return pyel (value)
  (lambda (value)
    
    (if (context-p 'last-function-line)
        (transform value)
      (setq return-middle t)
      `(throw '__return__ ,(transform value)))))

(def-transform break pyel ()
  (lambda ()
    ;;TODO verify that it is ok to just use one inter-template var for this
    (context-switch
     (while (setq break-while t))
     (for (setq break-for t)))
    '(throw '__break__ nil)))

(def-transform continue pyel ()
  (lambda ()
    ;;TODO verify that it is ok to just use one inter-template var for this
    (context-switch
     (while (setq continue-while t))
     (for (setq continue-for t)))
    '(throw '__continue__ nil)))

(def-transform except-handler pyel (type name body)
  ;;TODO: name?
  (lambda (type name body)
    `(,(or (transform type) 'error)
      ,@(mapcar 'transform body))))

(def-transform try pyel (body handlers orelse)
  ;;TODO: orelse
  (lambda (body handlers orelse)
    `(condition-case nil
         ,@(mapcar 'transform body)
       ,@(mapcar 'transform handlers))))

(def-transform unary-op pyel ()
  (lambda (op operand)
    (call-transform op operand)))

(pyel-create-py-func not (x)
                     (object) -> (--not-- x) ;;?
                     (_) -> (not x))

(pyel-create-py-func usub (x)
                     (number) -> (- x)
                     (object) -> (--usub-- x) ;;?
                     )

;;a not in b
;; function:    is_not(a, b)  (in the operator module)
(pyel-create-py-func not-in (l r)
                     (_ list) -> (not (member l r))
                     (_ vector) -> (not (vector-member l r))
                     (_ object) -> (--not-in-- r l) ;;?
                     )


;;a in b
;; function:    is_(a, b)
(pyel-create-py-func in (l r)
                     (_ list) -> (member l r)
                     (_ vector) -> (vector-member l r)
                     (_ object) -> (--in-- r l);;?
                     )

;;

(provide 'pyel-transforms)
;;pyel-transforms.el ends here

;;
