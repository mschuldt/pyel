(require 'cl)
(require 'py-iter_pyel-extras)

(define-class py-list-iter
  nil

  (def --init-- (self lst) nil
       (setattr self lst lst)
       (setattr self length (pyel-fcall15 length lst)))

  (def --next-- (self) nil
       (let (lst ret)
         (pyel-set2 lst (getattr self lst))
         (if lst
             (progn
               (pyel-set2 ret (pyel-fcall15 car lst))
               (setattr self lst (pyel-fcall15 cdr lst))
               ret)
           (py-raise StopIteration)))))

(define-class py-tuple-iter
  nil

  (def --init-- (self tup) nil
       (setattr self tup tup)
       (setattr self length (pyel-fcall15 length tup))
       (setattr self i 0))

  (def --next-- (self) nil
       (let (i ret)
         (pyel-set2 i (getattr self i))
         (if (pyel-<31 i (getattr self length))
             (progn
               (pyel-set2 ret (pyel-fcall15 aref (getattr self tup) i))
               (setattr self i (pyel-+9 (getattr self i) 1))
               ret)
           (py-raise StopIteration)))))

(define-class py-string-iter
  nil

  (def --init-- (self str) nil
       (setattr self s str)
       (setattr self length (pyel-fcall15 length str))
       (setattr self i 0))

  (def --next-- (self) nil
       (let (i ret)
         (pyel-set2 i (getattr self i))
         (if (pyel-<31 i (getattr self length))
             (progn
               (pyel-set2 ret
                          (pyel-fcall15 substring
                                        (getattr self s)
                                        i
                                        (pyel-+9 i 1)))
               (setattr self i (pyel-+9 (getattr self i) 1))
               ret)
           (py-raise StopIteration)))))

(define-class py-dict-iter
  nil

  (def --init-- (self d) nil
       (setattr self keys (pyel-fcall15 py-dict-keys d))
       (setattr self length (pyel-fcall15 length (getattr self keys))))

  (def --next-- (self) nil
       (let (keys ret)
         (pyel-set2 keys (getattr self keys))
         (if keys
             (progn
               (pyel-set2 ret (pyel-fcall15 car keys))
               (setattr self keys (pyel-fcall15 cdr keys))
               ret)
           (py-raise StopIteration)))))
(pyel-fcall15 provide (pyel-fcall15 quote py-iter))
