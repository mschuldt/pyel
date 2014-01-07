
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

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
  (format "<function %s at 0x18b071>" (if (and (listp func)
                                               (or (eq (car func) 'lambda)))
                                          "<lambda>"
                                        (symbol-name func))))

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

(defsubst py-repr-string (thing)
  (prin1-to-string (prin1-to-string thing)))

(defun _py-repr-sequence (seq)
  (mapconcat (lambda (x) (pyel-repr-function x)) seq ", "))

(defun py-list-repr (thing)
  (concat "[" (_py-repr-sequence thing) "]"))

(defun py-vector-repr (thing)
  (concat "(" (_py-repr-sequence thing) ")"))

(defun py-hex (n)
  (format "%X" n))

(defun py-bin (n) ;;Is there really no built in way to do this???
  (let (bin)
    (while (not (= n 0))
      (push (number-to-string (% n 2)) bin)
      (setq n (/ n 2)))
    (mapconcat 'identity (cons "0b" bin) "")))



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









