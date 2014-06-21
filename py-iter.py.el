(require 'cl)
(require 'py-lib)
(require 'py-iter_pyel-extras)

(define-class py-list-iter
  nil

  (def --init-- (self lst) (pyel-lambda)
       (setattr self lst lst)
       (setattr self length (pyel-fcall16 length lst)))

  (def --iter-- (self) (pyel-lambda) self)

  (def --next-- (self) (pyel-lambda)
       (let (lst ret)
         (pyel-set2 lst (getattr self lst))
         (if (py-bool lst)
             (progn
               (pyel-set2 ret (pyel-fcall16 car lst))
               (setattr self lst (pyel-fcall16 cdr lst))
               ret)
           (py-raise StopIteration)))))

(define-class py-tuple-iter
  nil

  (def --init-- (self tup) (pyel-lambda)
       (setattr self tup tup)
       (setattr self length (pyel-fcall16 length tup))
       (setattr self i 0))

  (def --iter-- (self) (pyel-lambda) self)

  (def --next-- (self) (pyel-lambda)
       (let (i ret)
         (pyel-set2 i (getattr self i))
         (if (py-bool (pyel-<1 i (getattr self length)))
             (progn
               (pyel-set2 ret (pyel-fcall16 aref (getattr self tup) i))
               (setattr self i (pyel-+1 (getattr self i) 1))
               ret)
           (py-raise StopIteration)))))

(define-class py-string-iter
  nil

  (def --init-- (self str) (pyel-lambda)
       (setattr self s str)
       (setattr self length (pyel-fcall16 length str))
       (setattr self i 0))

  (def --iter-- (self) (pyel-lambda) self)

  (def --next-- (self) (pyel-lambda)
       (let (i ret)
         (pyel-set2 i (getattr self i))
         (if (py-bool (pyel-<1 i (getattr self length)))
             (progn
               (pyel-set2 ret
                          (pyel-fcall16 substring
                                        (getattr self s)
                                        i
                                        (pyel-+1 i 1)))
               (setattr self i (pyel-+1 (getattr self i) 1))
               ret)
           (py-raise StopIteration)))))

(define-class py-dict-iter
  nil

  (def --init-- (self d) (pyel-lambda)
       (setattr self keys (pyel-fcall31 py-dict-keys d))
       (setattr self length (pyel-fcall16 length (getattr self keys))))

  (def --iter-- (self) (pyel-lambda) self)

  (def --next-- (self) (pyel-lambda)
       (let (keys ret)
         (pyel-set2 keys (getattr self keys))
         (if (py-bool keys)
             (progn
               (pyel-set2 ret (pyel-fcall16 car keys))
               (setattr self keys (pyel-fcall16 cdr keys))
               ret)
           (py-raise StopIteration)))))
(pyel-fcall16 provide (pyel-fcall16 quote py-iter))
