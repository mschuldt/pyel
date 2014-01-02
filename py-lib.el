
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









