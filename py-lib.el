
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

(defun pyel-mul-num-str (left right)
    "not implemented"
    )

(defmacro pyel-div (l r)
  (cond ((or (floatp l)
             (floatp r))
         `(/ ,l ,r))
        ((integerp l)
         `(/ ,(* 1.0 l) ,r))
        ((integerp r)
         `(/ ,l ,(* 1.0 r)))
        (t `(/ (* ,l 1.0) ,r))))





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
    (setq body (transform (setq _x body)))

    (setq body (cons '(setq __idx (1+ __idx))  body)
          body (if target
                   (cons `(setq ,target (nth __idx __tmp-list)) body)
                 (append unpack-code body)))

    (when __for-continue
      (setq body `((catch '__continue__ ,@body))))

    ;; ! This assumes that all iters are the same size
    (setq body `((while (< __idx __len)
                   ,@body)
                 ,@else-body))

    (when __for-break
      (setq body `((catch '__break__ ,@body))))

    `(let* ((__tmp-list ,iter)
            ;;      ,@iter-lets
            ;;      ,@next-function-lets
            (__len (length __tmp-list))
            (__idx 0)
            )
       ,@body)))







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

(defun py-list (object)
  "tries to be like python's list function"
  (cond
   ((stringp object)
    (split-string object "" :omit-nulls))
   ((py-object-p object) (pyel-object-to-list object))
   ((vectorp object)
    (mapcar 'identity object))
   ((hash-table-p object)
    (let (keys)
      (maphash (lambda (key value)
                 (setq keys (cons key keys))) object)
      keys))
   ((listp object) (copy-list object))))

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



(defun py-list-append (list thing)
  "add THING to the end of LIST"
  (cond ;; ((eq (car list) 'py-empty-list)
        ;;  (setcar list thing))
        ((null list) (list thing))
        (t (while (not (null (cdr list)))
             (setq list (cdr list)))
           (setcdr list (list thing)))))

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

(defsubst py-string-index (obj str)
  (string-match (regexp-quote str) obj))

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





(provide 'py-lib)
;;py-lib.el ends here

