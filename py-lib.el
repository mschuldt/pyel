
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

(defun pyel-alist-to-hash (alist)
  "Turn ALIST a hash table."
  (let ((ht (make-hash-table
             :test 'equal
             :size (length alist))))
    (mapc (lambda (x)
            (puthash (car x) (cdr x) ht))
          alist)
    ht))

(defmacro def (name args decorator-list &rest body)
  ;;TODO: apply decorators
  (using-context
   function-def
   (if (member '&kwarg args)
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
             npositional nargs arg-index)
         
         (when (member '&kwarg args)
           (setq kwarg (car (last args))
                 args (subseq args 0 -2)
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
                       pos+optional rest arg-index index-value tmp)
                  (cond ((= len ,nargs)
                         nil)
                        ((> len ,nargs)
                         (setq pos+optional (subseq args 0 ,nargs)
                               rest (subseq args ,nargs)))
                        (t ;;(< len ,nargs)
                         (setq pos+optional
                               (append args (make-list (- ,nargs len) nil)))))

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
                (apply (lambda ,args-without-kwarg
                         (let (,kwarg)
                         ,@body))
                       args)))))
     
     ;;else: no &kwarg
     `(defun ,name ,args
          ,@body)
     )))

(defun py-list (&rest things)
  "tries to be like python's list function"
  (if (> (length things) 1)
      things
    (setq thing (car things))
    (cond
     ((stringp thing)
      (split-string thing "" :omit-nulls))
     ((vectorp thing)
      (mapcar 'identity thing))
     ((hash-table-p thing)
      (let (keys)
        (maphash (lambda (key value)
                   (setq keys (cons key keys))) thing)
        keys))
     ((listp thing) (copy-list thing)))))

(defun _py-str-sequence (seq)
  "convert SEQ to a string of its python representation
    does not include starting/ending parens or brackets"
  (mapconcat (lambda (x) (pyel-str-function x)) seq ", "))

(defun py-list-str (thing)
  (concat "[" (_py-str-sequence thing) "]"))
(defun py-vector-str (thing)
  (concat "(" (_py-str-sequence thing) ")"))

(defun py-function-str (func)
  "return a string representation of function FUNC"
  (let* ((obj (bound-method-p func))
        (obj-name (-to_ (getattr obj --name--))))
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
  (format "%X" n))

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

(defmacro py-eval (source)
  (if (stringp source)
      `(eval (pyel ,source))
    `(eval ,source)))

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

(defun count-str-matches (string substr)
  "count number of occurrences of SUBSTR in STRING"
  (with-temp-buffer
    (insert string)
    (goto-char 1)
    (how-many substr)))

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



(provide 'py-lib)
;;py-lib.el ends here









(defun py-range (start &optional end step)
  (unless end
    (setq end start
          start 0))
  (number-sequence start (1- end) step))



















(defun vector-member (elt vector)
 "Return non-nil if ELT is an element of VECTOR.  Comparison done with `equal'."
 (let ((i 0)
       (len (length vector))
       found)
  (while (and (not found)
          (< i len))
   (if (equal (elt vector i) elt)
    (setq found t)
    (setq i (1+ i))))
  found))









