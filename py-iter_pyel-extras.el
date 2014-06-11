(defmacro pyel-+9 (lhs rhs)
  (backquote
   (let ((__rhs__ (\, rhs))
         (__lhs__ (\, lhs)))
     (cond
      ((and (numberp __lhs__) (numberp __rhs__)) (+ __lhs__ __rhs__))
      ((py-object-p __lhs__) (call-method __lhs__ --add-- __rhs__))
      (t (error "invalid type, expected <TODO>"))))))

(defmacro pyel-<31 (l r)
  (backquote
   (let ((__r__ (\, r))
         (__l__ (\, l)))
     (cond
      ((and (numberp __l__) (numberp __r__)) (< __l__ __r__))
      ((and (stringp __l__) (stringp __r__)) (string< __l__ __r__))
      ((and (listp __l__) (listp __r__)) (pyel-list-< __l__ __r__))
      ((py-object-p __l__) (call-method __l__ --lt-- __r__))
      ((and (vectorp __l__) (vectorp __r__)) (pyel-vector-< __l__ __r__))
      (t (error "invalid type, expected <TODO>"))))))

(defmacro pyel-fcall15 (func &rest args)
  (backquote
   (cond
    ((vfunction-p (\, func)) (funcall (\, func) (\,@ (pyel-sort-kwargs args))))
    ((py-class-p (\, func))
     (call-method (\, func) --new-- (\,@ (pyel-sort-kwargs args))))
    ((py-instance-p (\, func))
     (call-method (\, func) --call-- (\,@ (pyel-sort-kwargs args))))
    (t ((\, func) (\,@ (pyel-sort-kwargs args)))))))

(defmacro pyel-set2 (sym val)
  (backquote (setq (\, sym) (\, val))))

(provide 'py-iter_pyel-extras)
