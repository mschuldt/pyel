(require 'cl)
(require 'py-lib)
(require 'pyel_pyel-extras)

(def pyel-eval-buffer nil (interactive)
     (pyel-fcall8 py-eval (pyel-fcall8 pyel (pyel-fcall8 buffer-string)))
     (pyel-fcall8 pyel-eval-extra-generated-code))

(def pyel-buffer (&optional (out-buff . "*pyel-output*")) (interactive)
     (let (lisp)
       (pyel-set2 lisp (pyel-fcall8 pyel-buffer-to-lisp))
       (pyel-fcall8 switch-to-buffer-other-window out-buff)
       (pyel-fcall8 erase-buffer)
       (pyel-fcall8 lisp-interaction-mode)
       (pyel-fcall8 pyel-prettyprint lisp)
       (pyel-fcall8 goto-char 1)))

(def back-to-open-paren nil nil
     (let (pc c)
       (pyel-set2 pc 0)
       (while (and (pyel-not2 (pyel-fcall8 bobp)) (pyel-!=1 pc 1))
         (pyel-fcall8 backward-char)
         (pyel-set2 c (pyel-fcall8 thing-at-point (pyel-fcall8 quote char)))
         (if (pyel-==1 (pyel-fcall8 py-ord c) 34)
             (progn (pyel-fcall8 forward-char)
                    (pyel-fcall8 backward-sexp))
           (if (pyel-==6 c ")")
               (pyel-set2 pc (pyel--1 pc 1))
             (if (pyel-==6 c "(")
                 (pyel-set2 pc (pyel-+1 pc 1))))))
       (if (and (pyel-fcall8 bobp) (pyel-not2 (pyel-fcall8 looking-at "(")))
           nil
         t)))

(define-class slice
  nil

  (def --init-- (self start &optional (stop) (step)) (pyel-lambda)
       (if (pyel-not3 stop)
           (progn (pyel-set2 stop start)
                  (pyel-set2 start 0)))
       (setattr self start start)
       (setattr self stop stop)
       (setattr self step step))

  (def --repr-- (self) (pyel-lambda)
       (pyel-fcall15 format
                     "slice(%s, %s, %s)"
                     (getattr self start)
                     (getattr self stop)
                     (getattr self step)))

  (def indices (self length) (pyel-lambda) nil))
