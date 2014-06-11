(defmacro pyel-!=1 (l r)
  (backquote (pyel-number!= (\, l) (\, r))))

(defmacro pyel-+1 (lhs rhs)
  (backquote (+ (\, lhs) (\, rhs))))

(defmacro pyel--1 (l r)
  (backquote (- (\, l) (\, r))))

(defmacro pyel-==5 (l r)
  (backquote
   (let ((__r__ (\, r))
         (__l__ (\, l)))
     (cond
      ((and (numberp __l__) (numberp __r__)) (= __l__ __r__))
      (t (equal __l__ __r__))))))

(defmacro pyel-==6 (l r)
  (backquote
   (let ((__r__ (\, r))
         (__l__ (\, l)))
     (cond
      ((and (stringp __l__) (stringp __r__)) (string= __l__ __r__))
      (t (equal __l__ __r__))))))

(defmacro pyel-fcall15 (func &rest args)
  (backquote
   (cond
    ((vfunction-p (\, func)) (funcall (\, func) (\,@ (pyel-sort-kwargs args))))
    ((py-class-p (\, func))
     (call-method (\, func) --new-- (\,@ (pyel-sort-kwargs args))))
    ((py-instance-p (\, func))
     (call-method (\, func) --call-- (\,@ (pyel-sort-kwargs args))))
    (t ((\, func) (\,@ (pyel-sort-kwargs args)))))))

(defmacro pyel-not3 (x)
  (backquote
   (let ((__x__ (\, x)))
     (cond ((py-object-p __x__) (--not-- __x__))
           (t (not __x__))))))

(defmacro pyel-set2 (sym val)
  (backquote (setq (\, sym) (\, val))))

(provide 'pyel_pyel-extras)
