(defmacro pyel-!=1 (l r)
  (backquote (pyel-number!= (\, l) (\, r))))

(defmacro pyel-+1 (lhs rhs)
  (backquote (+ (\, lhs) (\, rhs))))

(defmacro pyel--1 (l r)
  (backquote (- (\, l) (\, r))))

(defmacro pyel-==1 (l r)
  (backquote (= (\, l) (\, r))))

(defmacro pyel-==6 (l r)
  (backquote
   (let ((__r__ (\, r))
         (__l__ (\, l)))
     (cond
      ((and (stringp __l__) (stringp __r__)) (string= __l__ __r__))
      (t (equal __l__ __r__))))))

(defmacro pyel-fcall16 (func &rest args)
  (backquote ((\, func) (\,@ (pyel-sort-kwargs args)))))

(defmacro pyel-fcall31 (func &rest args)
  (backquote
   (cond
    ((listp'(\, func)) (funcall (\, func) (\,@ (pyel-sort-kwargs args))))
    ((vfunction-p (\, func)) (funcall (\, func) (\,@ (pyel-sort-kwargs args))))
    ((py-class-p (\, func))
     (call-method (\, func) --new-- (\,@ (pyel-sort-kwargs args))))
    ((py-instance-p (\, func))
     (call-method (\, func) --call-- (\,@ (pyel-sort-kwargs args))))
    (t ((\, func) (\,@ (pyel-sort-kwargs args)))))))

(defmacro pyel-not127 (obj)
  (backquote
   (let ((__obj__ (\, obj)))
     (cond
      ((numberp __obj__) (eq __obj__ 0))
      ((stringp __obj__) (eq __obj__ ""))
      ((listp __obj__) (null __obj__))
      ((py-object-p __obj__) (pyel-object-bool __obj__))
      ((py-object-p __obj__) (pyel-object-bool __obj__))
      ((py-object-p __obj__) (pyel-object-bool __obj__))
      ((vectorp __obj__) (eq __obj__ []))
      ((hash-table-p __obj__) (= (hash-table-count __obj__) 0))
      (t (not __obj__))))))

(defmacro pyel-not64 (obj)
  (backquote (not (\, obj))))

(defmacro pyel-set2 (sym val)
  (backquote (setq (\, sym) (\, val))))

(provide 'pyel_pyel-extras)
