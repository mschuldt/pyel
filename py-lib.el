
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

(defsubst pyel-string> (a b)
  (and (not (string< a b)) (not (string= a b))))

(defsubst pyel-string<= (a b)
  (or (string< a b) (string= a b)))

(defsubst pyel-string!= (a b)
  (not (string= a b)))

(defsubst pyel-number!= (a b)
  (not (= a b)))

(defsubst pyel-string<= (a b)
  (not (string< a b)))

(defun pyel-list-< (a b)
  "a < b"
  (let ((greator nil)
        e1 e2)
    (while (and a b (equal e1 e2))
      (setq e1 (car a)
            e2 (car b)
            a (cdr a)
            b (cdr b)))
    (pyel-< e1 e2)))
(defun pyel-list-> (a b)
  "a > b"
  (let ((greator nil)
        e1 e2)
    (while (and a b (equal e1 e2))
      (setq e1 (car a)
            e2 (car b)
            a (cdr a)
            b (cdr b)))
    (pyel-> e1 e2)))

(defsubst pyel-list>= (a b)
  (or (equal a b) (pyel-list-> a b)))

(defsubst pyel-list<= (a b)
  (or (equal a b) (pyel-list-< a b)))

(defun pyel-vector-> (a b)
  (let* ((greator nil)
         (len-a (length a))
         (len-b (length b))
         (len (min len-a len-b))
         (i 0)
         e1 e2)
    (while (and (< i len)
                (equal e1 e2))
      (setq e1 (aref a i)
            e2 (aref b i)
            i (1+ i)))
    (or (pyel-> e1 e2)
        (and (= i len)
             (equal e1 e2)
             (> len-a len-b)))))
(defun pyel-vector-< (a b)
  (let* ((greator nil)
         (len-a (length a))
         (len-b (length b))
         (len (min len-a len-b))
         (i 0)
         e1 e2)
    (while (and (< i len)
                (equal e1 e2))
      (setq e1 (aref a i)
            e2 (aref b i)
            i (1+ i)))
    (or (pyel-< e1 e2)
        (and (= i len)
             (equal e1 e2)
             (< len-a len-b)))))

(defsubst pyel-vector-<= (a b)
  (or (equal a b) (pyel-vector-< a b)))

(defsubst pyel-vector->= (a b)
  (or (equal a b) (pyel-vector-> a b)))

(defsubst !equal (a b)
  (not (equal a b)))

(defun pyel-alist-to-hash (alist)
  "Turn ALIST a hash table.
Each element in ALIST must have for form (a . b)"
  (let ((ht (make-hash-table
             :test 'equal
             :size (length alist))))
    (mapc (lambda (x)
            (puthash (car x) (cdr x) ht))
          alist)
    ht))

(defmacro def (name args decorator-list &rest body)
  ;;TODO: apply decorators

  (if (and (= (length body) 1)
           (stringp (car body)))
      (push nil body))

  (using-context
   function-def
   (if (or (member '&kwarg args)
           (member '&kwonly args))
       (let ((n -1)
             (func-name (if (member 'pyel-inner-function-def decorator-list)
                            (progn
                              (setq decorator-list
                                    (remove 'pyel-inner-function-def
                                            decorator-list))
                              '(lambda))
                          (list 'defun name)))
             optional
             pos+optional rest kwarg
             npositional nargs arg-index
             kw-only-args kw-only-defaults)

         (when (member '&kwarg args)
           (setq kwarg (car (last args))
                 args (subseq args 0 -2)
                 args-without-kwarg args))
         (when (member '&kwonly args)
           (setq kwonly (pyel-split-list args '&kwonly)
                 args (car kwonly)
                 kwonly (cdr kwonly)
                 kw-only-args (mapcar 'car kwonly)
                 kw-only-defaults (mapcar 'cdr kwonly)
                 args-without-kwarg args))
         (when (member '&rest args)
           (setq rest (last args)
                 args (subseq args 0 -2)))
         (if (member '&optional args)
             (setq optional (pyel-split-list args '&optional)
                   positional (car optional)
                   optional (cdr optional))
           (setq positional args))

         (setq npositional (length positional)
               nargs (+ (length positional) (length optional))
               arg-index-alist (mapcar (lambda (x)
                                         (setq n (1+ n))
                                         (cons x n))
                                       (append positional optional)))

         `(,@func-name (&rest args)
                       ;;if this is called with keyword args they will be
                       ;;the in an alist in the car position.
                       (if (and (listp (car args))
                                (eq (caar args) :kwargs))
                           (let* ((kwargs (cdar args))
                                  (args (cadr args))
                                  (len (length args))
                                  (index 0)
                                  (kwargs-used 0)
                                  pos+optional rest arg-index index-value tmp
                                  ,@kw-only-args val
                                  )
                             (cond ((= len ,nargs)
                                    nil)
                                   ((> len ,nargs)
                                    (setq pos+optional (subseq args 0 ,nargs)
                                          rest (subseq args ,nargs)))
                                   (t ;;(< len ,nargs)
                                    (setq pos+optional
                                          (append args (make-list (- ,nargs len) nil)))))

                             ;;set kwonly arg values
                             ,@(mapcar* (lambda (arg default)
                                          `(if (setq val (assoc (quote ,arg) kwargs))
                                               (progn
                                                 (setq ,arg (cdr val))
                                                 (setq kwargs (remove val kwargs))
                                                 )
                                             (setq ,arg ,default)))
                                         kw-only-args kw-only-defaults)
                             
                             ;;make alist of index value pairs
                             (setq index-value
                                   (mapcar (lambda (kw)
                                             (if (setq arg-index
                                                       (assoc (car kw) ',arg-index-alist))
                                                 (list (cdr arg-index)
                                                       (cdr kw)
                                                       ;;need reference to remove arg later
                                                       (car arg-index))))
                                           kwargs))
                             ;;set the keyword args values in arg list
                             (setq tmp pos+optional)
                             (while tmp
                               (when (setq iv (assoc index index-value))
                                 (if (< (car iv) len)
                                     (signal 'TypeError (format ,(format "%s() got multiple values for keyword argument '%%s'" name) (caddr iv)))
                                   )
                                 (setq kwargs (remove (assoc (caddr iv) kwargs) kwargs))
                                 (setcar tmp (cadr iv))
                                 (setq kwargs-used (1+ kwargs-used)))
                               (setq tmp (cdr tmp))
                               (setq index (1+ index)))
                             (if (< (+ kwargs-used len) ,npositional)
                                 (signal 'TypeError (format ,(format "%s() takes at least %s arguments (%%s given)" name npositional) (+ kwargs-used len))))
                             (apply (lambda (,@(append positional optional rest) ,kwarg)
                                      ,@body)
                                    (append pos+optional
                                            (list rest (pyel-alist-to-hash kwargs)))))
                         ;;else: called without keyword args
                         (let ((kwargs (make-hash-table :size 0)))
                           ,@(mapcar (lambda (arg-value)
                                       (list 'setq (car arg-value)
                                             (cdr arg-value)))
                                     kwonly)
                           (apply (lambda ,args-without-kwarg
                                    (let (,kwarg)
                                      ,@body))
                                  args)))))

     ;;else: no keyword args
     `(defun ,name ,args
        ,@body)
     )))

(defun pyel-mul-num-str (left right)
  (let ((c 0)
        (ret "")
        num str)
    (if (numberp left)
        (setq num left
              str right)
      (setq num right
            str left))
    (while (< c num)
      (setq ret (concat ret str)
            c (1+ c)))
    ret))

(defmacro pyel-div (l r)
  (cond ((or (floatp l)
             (floatp r))
         `(/ ,l ,r))
        ((integerp l)
         `(/ ,(* 1.0 l) ,r))
        ((integerp r)
         `(/ ,l ,(* 1.0 r)))
        (t `(/ (* ,l 1.0) ,r))))





(setq pyel-for-loop-code-fns '((cons . pyel-for-loop-list-code)
                               (vector . pyel-for-loop-vector-code)
                               (string . pyel-for-loop-string-code)
                               (object . pyel-for-loop-object-code)))

(defsubst pyel-type-of (obj)
  (if (py-object-p obj)
      'object
    (type-of obj)))

(defmacro py-for (&rest args)
  "(for <targets> in <iter> <body> else <body>)
else is optional"
  
  ;;TODO: error checking for correct form
  (let* ((targets (pyel-split-list args 'in))
         (args (cdr targets))
         (targets (car targets))
         (iter (pop args)) ;;TODO: must iter be only one form?
         
         (body (pyel-split-list args 'else))
         (else-body (cdr body))
         (body (car body))
         
         (target (cond ((symbolp targets) ;;nil when there are multiple targets
                        targets)
                       ((= (length targets) 1)
                        (car targets))
                       (t nil)))
         
         (unpack-code (unless target
                        (let (ret)
                          (dotimes (i (length targets) (reverse ret))
                            (push `(setq ,(nth i targets)
                                         (nth ,i __target__))
                                  ret)))))
         (unpack-code (cons '(setq __target__ (nth __idx __tmp-list)) unpack-code))
         
         (current-transform-table (get-transform-table 'for-macro))
         __for-continue ;;these are set by the for-macro transforms
         __for-break
         )
    ;;TODO: when multiple targets, check that all lists are the same size
    (setq body (mapcar 'transform body))
    
    ;;TODO: expand to simpler cases when types are known
    
    `(let* ((__iter ,iter)
            (func (cdr (assoc (setq _t (pyel-type-of __iter)) pyel-for-loop-code-fns))))
       (if (null func)
           (error "invalid type")
         (eval (funcall func ',targets __iter ',body ',else-body
                        ,__for-break ,__for-continue) :lexical)))))


(defun pyel-for-loop-list-code (targets iter body else-body
                                        &optional break continue)
  (let* ((loop-body `(,@(if (= (length targets) 1)
                            `((setq ,(car targets) (nth __idx __tmp-lst)))
                          ;;unpack-code
                          (cons '(setq __target__ (nth __idx __tmp-lst))
                                (let (ret)
                                  (dotimes (i (length targets) (reverse ret))
                                    (push `(setq ,(nth i targets)
                                                 (pyel-nth ,i __target__))
                                          ret)))))
                      (setq __idx (1+ __idx))
                      
                      ,@body))
         (loop-body (if continue
                        `((catch '__continue__ ,@loop-body))
                      loop-body))
         
         (while-loop `(while (< __idx __len)
                        ,@loop-body))
         
         (while-loop (if break
                         `(catch '__break__ ,while-loop)
                       while-loop)))
    
    `(let* ((__tmp-lst ',iter)
            ;;      ,@iter-lets
            ;;      ,@next-function-lets
            (__len (length __tmp-lst))
            (__idx 0))
       ,while-loop
       ,@else-body)))


(defun pyel-for-loop-string-code (target iter body else-body
                                         &optional break continue)
  (let* ((loop-body `(,@(if (= (length target) 1)
                            `((setq ,(car target)
                                    (pyel-string-nth __tmp-str __idx)))
                          (error "ValueError: need more than 1 value to unpack"))
                      (setq __idx (1+ __idx))
                      ,@body))
         (loop-body (if continue
                        `((catch '__continue__ ,@loop-body))
                      loop-body))
         
         (while-loop `(while (< __idx __len)
                        ,@loop-body))
         
         (while-loop (if break
                         `(catch '__break__ ,while-loop)
                       while-loop)))
    
    `(let* ((__tmp-str ',iter)
            (__len (length __tmp-str))
            (__idx 0))
       ,while-loop
       ,@else-body)))

;;yes, I'm aware how repetitive it's getting

(defun pyel-for-loop-vector-code (targets iter body else-body
                                          &optional break continue)
  (let* ((loop-body `(,@(if (= (length targets) 1)
                            `((setq ,(car targets) (aref __tmp-lst __idx )))
                          ;;unpack-code
                          (cons '(setq __target__ (aref __tmp-lst __idx))
                                (let (ret)
                                  (dotimes (i (length targets) (reverse ret))
                                    (push `(setq ,(nth i targets)
                                                 (pyel-nth ,i __target__))
                                          ret)))))
                      (setq __idx (1+ __idx))

                      ,@body))
         (loop-body (if continue
                        `((catch '__continue__ ,@loop-body))
                      loop-body))

         (while-loop `(while (< __idx __len)
                        ,@loop-body))

         (while-loop (if break
                         `(catch '__break__ ,while-loop)
                       while-loop)))

    `(let* ((__tmp-lst ',iter)
            ;;      ,@iter-lets
            ;;      ,@next-function-lets
            (__len (length __tmp-lst))
            (__idx 0))
       ,while-loop
       ,@else-body)))


(defun pyel-for-loop-object-code (targets object body else-body
                                          &optional break continue)
  (let* ((loop-body `(,@(if (= (length targets) 1)
                            `((setq ,(car targets) (call-method __iter__ --next--)))
                          ;;unpack-code
                          (cons '(setq __target__ (call-method __iter__ --next--))
                                (let (ret)
                                  (dotimes (i (length targets) (reverse ret))
                                    (push `(setq ,(nth i targets)
                                                 (pyel-nth ,i __target__))
                                          ret)))))
                      ,@body))
         (loop-body (if continue
                        `((catch '__continue__ ,@loop-body))
                      loop-body))

         (while-loop `(condition-case nil
                          (while t
                            ,@loop-body)
                        (StopIteration nil)))

         (while-loop (if break
                         `(catch '__break__ ,while-loop)
                       while-loop)))

    ;;variable __iter is set by calling function
    `(let* (;;(__iter ,object)
            (__iter__ (condition-case nil
                          (call-method __iter --iter--)
                        (AttributeError
                         (py-raise (TypeError (format
                                               "'%s' object is not iterable"
                                               (getattr __iter --name--))))))))
       ,while-loop
       ,@else-body)))



(make-transform-table 'for-macro)

(def-transform break for-macro ()
  (lambda () (setq __for-break t)
    '(throw '__break__ nil)))

(def-transform continue for-macro ()
  (lambda () (setq __for-continue t)
    '(throw '__continue__ nil)))







(defun vector-member (elt vector)
  "Return non-nil if ELT is an element of VECTOR. Comparison done with `equal'."
  (let ((i 0)
        (len (length vector))
        found)
    (while (and (not found)
                (< i len))
      (if (equal (elt vector i) elt)
          (setq found t)
        (setq i (1+ i))))
    found))





(defun py-raise (exc &optional cause)
  "signal an error with the name of EXC, an class/object
EXC must be derived from BaseException"
  (if (py-object-p exc)
         ;;;;TODO: after `issubclass' is implemented
      ;; (or (and (py-class-p exc)
      ;;          (issubclass exc BaseException))
      ;;     (and (py-instance-p exc)
      ;;          (issubclass (py-type exc) BaseException)))
      (signal (intern (getattr exc --name--)) exc)
    (signal 'TypeError "TypeError: exceptions must derive from BaseException")))



(defun py-range (start &optional end step)
 (unless end
  (setq end start
   start 0))
 (number-sequence start (1- end) step))

(defun pyel-object-to-list (object)
  "assumes that py-object(OBJECT) == t"
  (let ((iter (condition-case nil
                  (call-method object --iter--)
                (AttributeError
                 (py-raise (TypeError (format
                                       "'%s' object is not iterable"
                                       (getattr object --name--)))))))
        list)
    (condition-case nil
        (while t
          (setq list (cons (call-method iter --next--) list)))
      (StopIteration (reverse list)))))

(defun pyel-hash-to-list (hash)
  (let (keys)
    (maphash (lambda (key value)
               (setq keys (cons key keys))) hash)
    keys))

(defun _py-str-sequence (seq)
  "convert SEQ to a string of its python representation
    does not include starting/ending parens or brackets"
  (if (vectorp seq)
      (setq seq (mapcar 'identity seq)))
  (if (listp seq)
      (if (listp (cdr seq))
          (mapconcat (lambda (x) (pyel-str-function x)) seq ", ")
        ;;cons cell
        ;;this should not happend from normal python
        ;;but maybe when interacting with lisp code from python
        (concat (pyel-str-function (car seq))
                " . "
                (pyel-str-function (cdr seq))))
    (error "invalid type")))

(defun py-list-str (thing)
  (concat "[" (_py-str-sequence thing) "]"))
(defun py-vector-str (thing)
  (concat "(" (_py-str-sequence thing) ")"))

(defun py-function-str (func)
  "return a string representation of function FUNC"
  (let* ((obj (bound-method-p func))
         (obj-name (if obj (-to_ (getattr obj --name--)) nil)))
    (if obj
        (format "<bound method %s.%s of %s object at 0x18b071>"
                obj-name
                (-to_ (bound-method-name func))
                obj-name)
      (format "<function %s at 0x18b071>" (if (and (listp func)
                                                   (or (eq (car func) 'lambda)))
                                              "<lambda>"
                                            (symbol-name func))))))

(defun py-hash-str (ht)
  (let (str)
    (maphash (lambda (key value)
               (push (concat (pyel-str-function key)
                             ": "
                             (pyel-str-function value))
                     str))
             ht)

    (concat "{" (mapconcat 'identity (reverse str) ", ") "}")))

;;temp fix for 'str' transform
;;The problem:
;; cannot pass a function name to the str transform because the tranform
;; treats it like a variable and it may not be bound as a variable
;;*This should be temporary because the 'str' transform cannot
;;expand this way to take advantage of known types
(defmacro pyel-str (thing)
  (if (symbolp thing)
      (if (boundp thing)
          (list 'pyel-str-function thing)
        (if (functionp thing)
            `(py-function-str (quote ,thing))
          thing;;error
          ))
    (list 'pyel-str-function thing)))

;;Currently, the repr and str transforms are not not called directly
;;so they never have the change to expand.
;;The expanded functions are used so we force expansion here.
;;required functions are `pyel-str-function' and `pyel-repr-function'
;;;NOTE: this is also done in `pyel-run-tests'
(let ((current-transform-table (get-transform-table 'pyel)))
  (call-transform (pyel-func-transform-name 'repr) nil)
  (call-transform (pyel-func-transform-name 'str) nil))

;;temp function. see `pyel-str' for details
(defmacro pyel-repr (thing)
  (if (stringp thing)
      (py-repr-string (py-repr-string thing))
    (if (symbolp thing)
        (if (boundp thing)
            (list 'pyel-repr-function thing)
          (if (functionp thing)
              `(py-function-str (quote ,thing))
            thing;;error
            ))
      (list 'pyel-repr-function thing))))

(defsubst py-repr-string (thing)
  (prin1-to-string thing))

(defun _py-repr-sequence (seq)
  (mapconcat (lambda (x) (pyel-repr-function x)) seq ", "))

(defun py-list-repr (thing)
  (concat "[" (_py-repr-sequence thing) "]"))

(defun py-vector-repr (thing)
  (concat "(" (_py-repr-sequence thing) ")"))

(defun pyel-symbol-str (sym)
  (if (eq sym t)
      "True"
    (case sym
      (nil "False")
      (integer "<class 'int'>")
      (float "<class 'float'>")
      (string "<class 'str'>")
      (cons "<class 'list'>")
      (vector "<class 'tuple'>")
      (hash-table "<class 'dict'>")
      (t (symbol-name sym)))))

(defun py-hex (n)
  (format "0x%x" n))

(defun py-bin (n) ;;Is there really no built in way to do this???
  (let (bin)
    (while (not (= n 0))
      (push (number-to-string (% n 2)) bin)
      (setq n (/ n 2)))
    (mapconcat 'identity (cons "0b" bin) "")))

(defvar pyel-print-function 'prin1
  "function that is used for printing by `py-print'")

(defun py-print (sep end file &rest args)
  (let ((sep (or sep " "))
        (end (or end "\n")))
    (progn (mapc (lambda (x)
                   (funcall pyel-print-function x)
                   (funcall pyel-print-function sep))
                 (butlast args))
           (funcall pyel-print-function (car (last args)))
           (funcall pyel-print-function end)
           nil)))

(defun py-eval (source &rest others)
  (if others
      (error "Only the first arg in `py-eval' is implemented"))
  (if (stringp source)
      (eval (pyel source))
    (py-raise (TypeError "eval() arg 1 must be a string, bytes or code object)"))))

;;TODO: when the built in type classes are finished and `py-type'
;;      returns them, the special cases for the types in
;;      `pyel-symbol-str' should be removed
(defun py-type (object)
  (cond ((or (eq object nil)
             (eq object t))
         "<class 'bool'>") ;;TODO
        ((py-class-p object)
         "<class 'type'>") ;;TODO
        ((py-instance-p object)
         (aref object obj-class-index)) ;;FIX: should special implicit lookup
        (t (type-of object))))



(defun pyel-exit ()
  (if pyel-interactive
      (progn (kill-buffer)
             (message "you killed ipyel")
             (throw 'ipyel-quit nil))
    ;;(kill-emacs)
    (save-buffers-kill-terminal)))

(defmacro py-number-to-int (num)
  (if (numberp num)
      (floor num)
    (list 'floor num)))

(defmacro py-str-to-int (str)
  (if (stringp str)
      (floor (string-to-int str))
    `(floor (string-to-int ,str))))

(defmacro py-number-to-float (num)
  (if (numberp num)
      (* 1.0 num)
    (list '* 1.0 num)))

(defmacro py-str-to-float (str)
  (if (stringp str)
      (* 1.0 (string-to-int str))
    (list '* 1.0 (list 'string-to-int str))))

(defun pyel-alist-to-hash2 (alist)
  "like `pyel-alist-to-hash' but elements hav the form (a b)"
  (let ((ht (make-hash-table
             :test 'equal
             :size (length alist))))
    (mapc (lambda (x)
            (puthash (car x) (cadr x) ht))
          alist)
    ht))

(defun pyel-list-to-dict (list)
  (let ((h (make-hash-table :test pyel-dict-test)) ;;default length??
        key-val)
    (mapcar (lambda (elem)
              (setq key-val (pyel-get-key-val elem))
              (puthash (car key-val) (cdr key-val) h))
            list)
    h))

(defun pyel-vector-to-dict (vec)
  (let ((h (make-hash-table :test pyel-dict-test)) ;;default length??
        key-val)
    (dotimes (i (length vec))
      (setq key-val (pyel-get-key-val (aref vec i)))
      (puthash (car key-val) (cdr key-val) h))
    h))

(defun pyel-object-to-dict (object)
  (let ((iter (condition-case nil
                  (call-method object --iter--)
                (AttributeError
                 (py-raise (TypeError (format
                                       "'%s' object is not iterable"
                                       (getattr object --name--)))))))
        (ht (make-hash-table :test pyel-dict-test))
        key-val)
    (condition-case nil
        (while t
          (setq key-val (pyel-get-key-val (call-method iter --next--)))
          (puthash (car key-val) (cdr key-val) ht))
      (StopIteration ht))))

(defun pyel-get-key-val (obj)
  "(k . v) -> (k . v)
\(k v) -> (k . v)
\[k v] -> (k . v)
'kv' -> ('k' . 'v')"
  (cond ((listp obj)
         (if (listp (cdr obj))
             (if (= (length obj) 2)
                 (cons (car obj) (cadr obj))
               (error "invalid length"))
           obj))
        ((vectorp obj)
         (if (= (length obj) 2)
             (cons (aref obj 0) (aref obj 1))
           (error "invalid length")))
        ((stringp obj)
         (if (= (length obj) 2)
             (cons (subseq obj 0 1) (subseq obj 1 2))
           (error "invalid length")))
        (t (error "invalid type"))))

(defun py-round (number &optional ndigits)
  (if ndigits
      (round-float number ndigits)
    (round number)))

(defun pyel-enumerate-list (list &optional start)
  (let ((ret nil)
        (c (or start 0)))
    (while list
      (setq ret (cons (list c (car list)) ret)
            list (cdr list)
            c (1+ c)))
    (reverse ret)))

(defun pyel-enumerate-vector (vec &optional start)
  (pyel-enumerate-list (mapcar 'identity vec) start))

(defun pyel-enumerate-hash (hash &optional start)
  (pyel-enumerate-list (pyel-hash-to-list hash) start))

(defun pyel-enumerate-string (str &optional start)
  (pyel-enumerate-list (split-string str "" :omit-nulls) start))

(defun pyel-enumerate-object (obj &optional start)
  (pyel-enumerate-list (pyel-object-to-list obj) start))



(defun py-list-append (list thing)
  "add THING to the end of LIST"
  (while (not (null (cdr list)))
    (setq list (cdr list)))
  (setcdr list (list thing)))

(defmacro py-append (list thing)
  "add THING to the end of LIST"
  `(cond ((null ,list) (setq ,list (list ,thing)))
         (t (py-list-append ,list ,thing))))

(defun py-insert (list index object)
  "insert OBJECT into LIST at INDEX"
  (let ((i 0)
        (rest list)
        first)
    (while (< i index)
      (setq first rest)
      (setq rest (cdr rest))
      (setq i (1+ i)))
    (setcdr first (cons object rest)))
  nil)

(defun py-find (str sub &optional start end)
  "Return the lowest index in S where substring sub is found,
such that sub is contained within S[start:end].  Optional
arguments start and end are interpreted as in slice notation.

Return -1 on failure."
  (let* ((start (or start 0))
        (index (string-match (regexp-quote sub) (substring str start end))))
    (if index
        (+ index start)
      -1)))

(defun list-index (elem list)
  "return the index of ELEM in LIST"
  (let ((m (member elem list)))
    (when m
      (- (length list) (length m)))))

(defun vector-index (elem vector)
  "return the index of ELEM in VECTOR"
  (let ((i 0)
        (len (length vector))
        found)

    (while (and (< i len)
                (not found))
      (if (equal (aref vector i) elem)
          (setq found i)
        (setq i (1+ i))))
    found))

(defun py-string-index (str sub)
  "Like STR.find() but raise ValueError when the substring SUB is not found."
  (let ((ret (py-find str sub)))
    (if (= ret -1)
        (py-raise (ValueError "substring not found"))
      ret)))

(defun py-list-remove (list item)
  "remove ITEM from LIST"
  (when (equal (car list) item)
    (setcar list (cadr list))
    (setcdr list (cddr list)))
  (let ((rest list)
        first)
    (while rest
      (if (equal (car rest) item)
          (progn (setcdr first (cdr rest))
                 (setq rest nil))
        (setq first rest
              rest (cdr rest))))
    nil))

;;;; this one is slower
;;;; maybe faster with a non-regexp search function?
;; (defun count-str-matches (string substr)
;;   "count number of occurrences of SUBSTR in STRING"
;;   (let ((quoted (regexp-quote substr))
;;      (start 0)
;;      (strlen (length string))
;;      (sublen (length substr))
;;      (count 0))
;;     (while (< start strlen)
;;       (setq start (string-match quoted string start))
;;       (if start (setq count (1+ count)
;;                    start (+ start sublen))
;;      (setq start strlen)))
;;     count))

(defun count-str-matches (string substr)
  "count number of occurrences of SUBSTR in STRING"
  (with-temp-buffer
    (insert string)
    (goto-char 1)
    (how-many (regexp-quote substr))))

(defun count-elems-list (list elem)
  "return how many times ELEM occurs in LIST"
  (let ((c 0))
    (dolist (x list)
      (if (equal x elem)
          (setq c (1+ c))))
    c))

(defun count-elems-vector (vector elem)
  "return how many times ELEM occurs in VECTOR"
  (let ((c 0)
        (i 0)
        (len (length vector)))
    (while (< i len)
      (if (equal (aref vector i) elem)
          (setq c (1+ c)))
      (setq i (1+ i)))
    c))

(defun py-list-extend (list iterable)
  "Extend LIST by appending elements from the ITERABLE"
  (let ((rest list)
        prev)

    (while rest
      (setq prev rest
            rest (cdr rest)))
    
    (cond ((py-object-p iterable)
           (_py-list-extend-with-object prev iterable))
          ((listp iterable)
           (_py-list-extend-with-list prev iterable))
          ((stringp iterable)
           (_py-list-extend-with-string prev iterable))
          ((vectorp iterable)
           (_py-list-extend-with-vector prev iterable))
          (t (py-raise (TypeError (format "TypeError: '%s' object is not iterable"
                                          (type-of iterable))))))))

(defun _py-list-extend-with-list (list extendlist)
  (while extendlist
    (setcdr list (list (car extendlist)))
    (setq list (cdr list)
          extendlist (cdr extendlist))))

(defun _py-list-extend-with-vector (list vector)
  (let ((len (length vector))
        (index 0))
    (while (< index len)
      (setcdr list (list (aref vector index)))
      (setq list (cdr list)
            index (1+ index)))
    nil))

(defun _py-list-extend-with-string (list string)
  (let ((len (length string))
        (index 0))
    (while (< index len)
      (setcdr list (list (char-to-string (aref string index))))
      (setq list (cdr list)
            index (1+ index)))
    nil))

(defun _py-list-extend-with-object (list object)
  "assumes that py-object(OBJECT) == t"
  (let ((iter (condition-case nil
                  (call-method object --iter--)
                (AttributeError
                 (py-raise (TypeError (format
                                       "'%s' object is not iterable"
                                       (getattr object --name--))))))))
    (condition-case nil
        (while t
          (setcdr list (list (call-method iter --next--)))
          (setq list (cdr list)))
      (StopIteration nil))))

(defun py-list-pop (list &optional index)
  "remove and return item at INDEX from LIST (default last)"
  (let ((rest list)
        (i 0)
        last ret)
    (if index
        (if (= index 0)
            (progn
              (setq ret (car list))
              (setcar list (cadr list))
              (setcdr list (cddr list))
              ret)
          ;; 0 < index < len(list)
          (while (< i index)
            (setq last rest
                  rest (cdr rest)
                  i (1+ i)))
          (setq ret (car rest))
          (setcdr last (cdr rest))
          ret)
      ;;pop last element
      (while (cdr rest)
        (setq prev rest
              rest (cdr rest)))
      (setq ret (car rest))
      (setcdr prev nil))
    ret))

(defun py-hash-pop (ht key)
  (let ((ret (gethash key ht)))
    (remhash key ht)
    ret))

(defun pyel-list-reverse (list)
  "reverse LIST *IN PLACE*"
  (let ((reversed (reverse list))
        (rest list))
    (while reversed
      (setcar rest (car reversed))
      (setq reversed (cdr reversed)
            rest (cdr rest)))))

(defun pyel-split (string &optional sep maxsplit)
  
  (let ((sep (or (and sep (regexp-quote sep)) "[ \f\t\n\r\v]+")) ;;correct default?
        (ret (split-string string sep t)))
    (if maxsplit
        ret ;;TODO
      ret)))

(defun pyel-strip-left (s &optional chars)
  "Remove whitespace or CHARS at the beginning of S."
  (let ((chars (if chars (format "\\`[%s]+" chars)
                 "\\`[ \t\n\r]+")))
    (if (string-match chars s)
        (replace-match "" t t s)
      s)))

(defun pyel-strip-right (s &optional chars)
  "Remove whitespace or CHARS at the end of S."
  (let ((chars (if chars (format "[%s]+\\'" chars)
                 "[ \t\n\r]+\\'")))
    (if (string-match chars s)
        (replace-match "" t t s)
      s)))

(defun pyel-strip (s &optional chars)
  "Remove whitespace or CHARS at the beginning and end of S."
  (pyel-strip-left (pyel-strip-right s chars) chars))

(defun pyel-dict-items (dict)
  (let (ret)
    (maphash (lambda (key value)
               (push (list key value) ret))
             dict)
    ret))

(defun pyel-dict-keys (dict)
  (let (ret)
    (maphash (lambda (key value)
               (push key ret))
             dict)
    ret))

(defun pyel-dict-values (dict)
  (let (ret)
    (maphash (lambda (key value)
               (push value ret))
             dict)
    ret))

(defun pyel-hash-popitem (ht)
  (let* ((key (catch '_pop_
                (maphash (lambda (k v)
                           (throw '_pop_ k))
                         ht)))
         (ret (list key (gethash key ht))))
    (remhash key ht)
    ret))



(defun pyel-gen-match-code (regex str)
  "return code that tests if REGEX matches STR
if STR is constant, return t if it matches, else nil"
  (let ((case-fold-search nil))
    (if (stringp str)
        (numberp (string-match regex str))
      `(let ((case-fold-search nil))
         (numberp (string-match ,regex ,str))))))


(defmacro py-islower (s)
  "S.islower() -> bool

Return t if all cased characters in S are lowercase and there is
at least one cased character in S, False otherwise."
  (pyel-gen-match-code "^[^A-Z]*[a-z]+[^A-Z]*$" s))

(defmacro py-isupper (s)
  "S.isupper() -> bool

Return True if all cased characters in S are uppercase and there is
at least one cased character in S, False otherwise."
(pyel-gen-match-code "^[^a-z]*[A-Z]+[^a-z]*$" s))

(defmacro py-istitle (s)
"  S.istitle() -> bool

    Return True if S is a titlecased string and there is at least one
    character in S, i.e. upper- and titlecase characters may only
    follow uncased characters and lowercase characters only cased ones.
    Return False otherwise.  "

  (pyel-gen-match-code "^[^a-zA-Z]*[A-Z][^A-Z]*$" s))

(defmacro py-isalpha (s)
    "S.isalpha() -> bool
  
  Return True if all characters in S are alphabetic
  and there is at least one character in S, False otherwise."
  
    (pyel-gen-match-code "^[a-zA-Z]+$" s))

(defmacro py-isalnum (s)
  "S.isalnum() -> bool

    Return True if all characters in S are alphanumeric
    and there is at least one character in S, False otherwise."

  (pyel-gen-match-code "^[0-9]+$" s))

(defun py-zfill (str width)
  " S.zfill(width) -> str

Pad a numeric string S with zeros on the left, to fill a field
of the specified width. The string S is never truncated."
  (let ((diff (- width (length str))))
    (if (> diff 0)
        (concat (make-string diff ?0) str)
      str)))

(defun py-title (s)
  "Return a titlecased version of S, i.e. words start with title case
characters, all remaining cased characters have lower case."
  (let ((case-fold-search nil))
    (if (eq s "")
        ""
      (if (string-match "^\\([^A-Za-z]*\\)\\([A-Za-z]\\)\\(.*\\)$" s)
          (concat (match-string 1 s)
                  (upcase (match-string 2 s))
                  (downcase (match-string 3 s)))
        s))))

(defun py-swapcase (s)
  "swapcase(...)
S.swapcase() -> str

Return a copy of S with uppercase characters converted to lowercase
and vice versa."
  (let ((i (length s)))
    (while (> i 0)
      (setq i (1- i))
      (aset s i (let ((char (aref s i)))
                  (if (eq (downcase char) char)
                      (upcase char)
                    (downcase char)))))
    s))

(defun py-startswith (s prefix &optional start end)
  "S.startswith(prefix[, start[, end]]) -> bool

Return True if S starts with the specified prefix, False otherwise.
With optional start, test S beginning at that position.
With optional end, stop comparing S at that position.
prefix can also be a tuple of strings to try."  
  (setq start (or start 0))
  (cond ((stringp prefix)
         (if (string-match (concat "^" (regexp-quote prefix)) (substring s start end))
             t nil))
        ((vectorp prefix)
         (let ((found nil)
               (i 0)
               (len (length prefix)))
           (while (< i len)
             (if (py-startswith s (aref prefix i) start end)
                 (setq found t
                       i len)
               (setq i (1+ i))))
           found))
        (t (py-raise (TypeError (format "startswith first arg must be str or a tuple of str, not %s" (py-type prefix)))))))

(defun py-splitlines (string &optional keepends)
  ;;based off code from `split-string'
  (let ((start 0)
        notfirst
        (list nil)
        (len (length string))
        str)

    (while (and (string-match "\n" string
                              (if (and notfirst
                                       (= start (match-beginning 0))
                                       (< start len))
                                  (1+ start) start))
                (< start len))
      (setq notfirst t
            str (substring string start (match-beginning 0)))
      (if keepends (setq str (concat str "\n")))
      (setq list (cons str list)
            start (match-end 0)))

    (setq str (substring string start))
    (unless (eq str "")
      (if keepends (setq str (concat str "\n")))
      (setq list (cons str list)))
    (nreverse list)))

(defun py-rstrip (s &optional chars)
  "S.rstrip([chars]) -> str

Return a copy of the string S with trailing whitespace removed.
If chars is given and not None, remove characters in chars instead."
  (pyel-strip-right s chars))

(defun py-lstrip (s &optional chars)
  "S.lstrip([chars]) -> str

Return a copy of the string S with leading whitespace removed.
If chars is given and not None, remove characters in chars instead."
  (pyel-strip-left s chars))

(defun pyel-rsplit (string &optional sep maxsplit)
  (pyel-split string sep maxsplit)) ;;TODO: properly implement this

(defun py-partition (s sep)
  "S.partition(sep) -> (head, sep, tail)

Search for the separator sep in S, and return the part before it,
the separator itself, and the part after it.  If the separator is not
found, return S and two empty strings."
  (if (string-match (format "^\\(.*\\)%s\\(.*\\)$" (regexp-quote sep))  s)
      (vector (match-string 1 s) sep (match-string 2 s))
    (vector s "" "")))

(defalias 'py-rpartition 'py-partition)

(defun py-rjust (str width &optional fillchar)
  "S.rjust(width[, fillchar]) -> str

Return S right-justified in a string of length width. Padding is
done using the specified fill character (default is a space)."
  (if (> (length fillchar) 1)
      (py-raise (TypeError
                 "The fill character must be exactly one character long")))
  (let ((diff (- width (length str)))
        (fillchar (or fillchar " ")))
    (if (> diff 0)
        (concat (make-string diff (string-to-char fillchar)) str)
      str)))

(defun py-ljust (str width &optional fillchar)
"S.ljust(width[, fillchar]) -> str

Return S left-justified in a Unicode string of length width. Padding is
done using the specified fill character (default is a space)."
  (if (> (length fillchar) 1)
      (py-raise (TypeError
                 "The fill character must be exactly one character long")))
  (let ((diff (- width (length str)))
        (fillchar (or fillchar " ")))
    (if (> diff 0)
        (concat str (make-string diff (string-to-char fillchar)))
      str)))

(defun pyel-reverse-string (string)
  (let ((start 0)
        (end (1- (length string)))
        tmp)
    (while (< start end)
      (setq tmp (aref string start))
      (aset string start (aref string end))
      (aset string end tmp)
      (setq start (1+ start)
            end (1- end)))
    string))

(defun py-rfind(str sub &optional start end)
  "S.rfind(sub[, start[, end]]) -> int

Return the highest index in S where substring sub is found,
such that sub is contained within S[start:end].  Optional
arguments start and end are interpreted as in slice notation.

Return -1 on failure."
  (let* ((start (or start 0))
         (index (string-match
                 (pyel-reverse-string (regexp-quote sub))
                 (pyel-reverse-string (substring str start end)))))
    (if index
        ;;(+ index start)
        (- (length str)  index (length sub))
      -1)))

(defun py-rindex (str sub &optional start end)
  "S.rindex(sub[, start[, end]]) -> int
 
 Like S.rfind() but raise ValueError when the substring is not found.  "
  (let ((ret (py-rfind str sub start end)))
    (if (= ret -1)
        (py-raise (ValueError "substring not found"))
      ret)))

(defun py-string-replace (string old new &optional count)
  "Return a copy of STRING with all occurrences of substring
OLD replaced by NEW.  If the optional argument COUNT is
given, only the first COUNT occurrences are replaced."
  ;;based on `replace-regexp-in-string'

  ;; To avoid excessive consing from multiple matches in long strings,
  ;; don't just call `replace-match' continually.  Walk down the
  ;; string looking for matches of REGEXP and building up a (reversed)
  ;; list MATCHES.  This comprises segments of STRING which weren't
  ;; matched interspersed with replacements for segments that were.
  ;; [For a `large' number of replacements it's more efficient to
  ;; operate in a temporary buffer; we can't tell from the function's
  ;; args whether to choose the buffer-based implementation, though it
  ;; might be reasonable to do so for long enough STRING.]
  (let ((case-fold-search nil)
        (replaced 0)
        (l (length string))
        (start 0)
        matches str mb me)
    (save-match-data
      (while (and
              (or (null count) (< replaced count))
              (< start l)
              (string-match old string start))
        (setq replaced (1+ replaced)
              mb (match-beginning 0)
              me (match-end 0))
        ;; If we matched the empty string, make sure we advance by one char
        (when (= me mb) (setq me (min l (1+ mb))))
        ;; Generate a replacement for the matched substring.
        ;; Operate only on the substring to minimize string consing.
        ;; Set up match data for the substring for replacement;
        ;; presumably this is likely to be faster than munging the
        ;; match data directly in Lisp.
        (string-match old (setq str (substring string mb me)))
        (setq matches
              (cons (replace-match new
                                   nil nil str)
                    (cons (substring string start mb) ; unmatched prefix
                          matches)))
        (setq start me))
      ;; Reconstruct a string from the pieces.
      (setq matches (cons (substring string start l) matches)) ; leftover
      (apply #'concat (nreverse matches)))))

(defun py-hash-table-clear (ht)
  "Remove all items from hash table HT"
  (maphash (lambda (key value)
             (remhash key ht))
           ht))

(defun py-fromkeys (keys &optional value)
  (let* ((len (length keys))
         (ht (make-hash-table :size len :test 'equal))
         (type (type-of keys))
         (i 0))
    (cond ((eq type 'cons)
           (while keys
             (puthash (car keys) value ht)
             (setq keys (cdr keys))))
          ((eq type 'string)
           (while (< i len)
             (puthash (substring keys i (1+ i)) value ht)
             (setq i (1+ i))))
          ((eq type 'vector)
           (while (< i len)
             (puthash (aref keys i) value ht)
             (setq i (1+ i)))
           )
          (t (error "py-fromkeys: invalid type for parameter 'keys'")))
    ht))

(defconst py-printable "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!\"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~ \t\n\r\x0b\x0c")

(setq py-printable-ht (make-hash-table :test 'equal
                                       :size (* (length py-printable) 2)))
(py-for c in py-printable
        (puthash c t py-printable-ht))

;;TODO: perhaps examining ascii values will be faster
(defun py-isprintable(s)
  "S.isprintable() -> bool

Return True if all characters in S are considered
printable in repr() or S is empty, False otherwise."
  (let ((good t)
        (len (length s))
        (i 0))
    (while (and good (< i len))
      (if (not (gethash (pyel-string-nth s i) py-printable-ht))
          (setq good nil))
      (setq i (1+ i)))
    good))



(provide 'py-lib)
;;py-lib.el ends here


