(require 'cl)
(require 'py-lib)
(require 'pyel_pyel-extras)

(def pyel-eval-buffer nil (interactive)
     (pyel-fcall16 py-eval (pyel-fcall16 pyel (pyel-fcall16 buffer-string)))
     (pyel-fcall16 pyel-eval-extra-generated-code))

(def pyel-buffer (&optional (out-buff . "*pyel-output*")) (interactive)
     (let (lisp)
       (pyel-set2 lisp (pyel-fcall16 pyel-buffer-to-lisp))
       (pyel-fcall16 switch-to-buffer-other-window out-buff)
       (pyel-fcall16 erase-buffer)
       (pyel-fcall16 lisp-interaction-mode)
       (pyel-fcall16 pyel-prettyprint lisp)
       (pyel-fcall16 goto-char 1)))

(def back-to-open-paren nil nil
     (let (pc c)
       (pyel-set2 pc 0)
       (while (py-and (pyel-not64 (pyel-fcall16 bobp)) (pyel-!=1 pc 1))
         (pyel-fcall16 backward-char)
         (pyel-set2 c (pyel-fcall16 thing-at-point (pyel-fcall16 quote char)))
         (if (py-bool (pyel-==1 (pyel-fcall16 py-ord c) 34))
             (progn (pyel-fcall16 forward-char)
                    (pyel-fcall16 backward-sexp))
           (if (py-bool (pyel-==6 c ")"))
               (pyel-set2 pc (pyel--1 pc 1))
             (if (py-bool (pyel-==6 c "("))
                 (pyel-set2 pc (pyel-+1 pc 1))))))
       (if (py-bool
            (py-and (pyel-fcall16 bobp)
                    (pyel-not64 (pyel-fcall16 looking-at "("))))
           nil
         t)))

(define-class slice
  nil

  (def --init-- (self start &optional (stop) (step)) (pyel-lambda)
       (if (py-bool (pyel-not127 stop))
           (progn (pyel-set2 stop start)
                  (pyel-set2 start 0)))
       (setattr self start start)
       (setattr self stop stop)
       (setattr self step step))

  (def --repr-- (self) (pyel-lambda)
       (pyel-fcall31 format
                     "slice(%s, %s, %s)"
                     (getattr self start)
                     (getattr self stop)
                     (getattr self step)))

  (def indices (self length) (pyel-lambda) nil))
