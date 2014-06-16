(defmacro pyel-+1 (lhs rhs)
  (backquote (+ (\, lhs) (\, rhs))))

(defmacro pyel-<1 (l r)
  (backquote (< (\, l) (\, r))))

(defmacro pyel-fcall15 (func &rest args)
  (backquote
   (cond
    ((vfunction-p (\, func)) (funcall (\, func) (\,@ (pyel-sort-kwargs args))))
    ((py-class-p (\, func))
     (call-method (\, func) --new-- (\,@ (pyel-sort-kwargs args))))
    ((py-instance-p (\, func))
     (call-method (\, func) --call-- (\,@ (pyel-sort-kwargs args))))
    (t ((\, func) (\,@ (pyel-sort-kwargs args)))))))

(defmacro pyel-fcall8 (func &rest args)
  (backquote ((\, func) (\,@ (pyel-sort-kwargs args)))))

(defmacro pyel-set2 (sym val)
  (backquote (setq (\, sym) (\, val))))

(provide 'py-iter_pyel-extras)
