
(defmacro def-transform (name table-name varlist function)
  "NAME of function to be transformed, FUNCTION takes the args of NAME
it is the responsibility of FUNCTION to eval/transform its arguments
Bind variables according to VARLIST, like `let*' "
  `(puthash ',name (cons ',varlist ,function)  ,(get-transform-table table-name)))

;;;;;transform tables

(defvar current-transform-table nil
  "The tranform table currently in use by `tranform'")

(defvar transform-tables nil
  "alist of tranform tables. Form: (name . table)")

(defmacro make-transform-table (table-name &rest hash-args)
  "make a new transform table"
  `(push (cons ,table-name (make-hash-table ,@hash-args)) transform-tables))

(defun get-transform-table (table-name)
  (cdr (assoc table-name transform-tables)))

(defun set-transform-table (table-name)
  (setq current-transform-table (get-transform-table table-name)))

(defun get-transform (name table-name)
  (gethash name (get-transform-table table-name)))

;;transform modifiers,
(defvar transform-no-eval nil) ;;for debugging
(defvar transform-quote-args t);;TODO: this should be set by the transform def

(defun transform (&rest code)
  (cond ((> (length code) 1)
         (mapconcat 'transform code "\n")) ;;TODO: optional newline

        ;;special case: list whose car is a list
        ((and (= (length code) 1)
              (and (consp (car code))
                   (consp (caar code))))
         (cons (transform (caar code)) (mapcar 'transform (cdar code))))

        (t (let ((code (car code))
                 var--func)
             (if (and transform-quote-args (listp code))
                 (setq orig-code code
                       code `(,(car code)
                              ,@(mapcar (lambda (x) `(quote ,x)) (cdr code)))))
             (case (type-of code)
               ((cons list)
                (if (and (eq (type-of (car code)) 'symbol)
                         (setq var--func (gethash (car code)
                                                  current-transform-table)))
                    (let* ((varlist (car var--func))
                           (func (cdr var--func))
                           (args (cdr code))
                           fcall)
                      (when func ;;TODO: if not raise error
                        (setq fcall `(let* ,varlist (funcall ,func ,@args)))
                        (if transform-no-eval
                            fcall
                          (eval fcall))))
                  ;;else: no defined transform
                  (if (null (car code))
                      nil ;;TODO: why not transform the args?

                    `(,(car code) ,@(mapcar 'transform (cdr orig-code))))));;don't use quoted args

               ((symbol integer float string) code)

               (vector
                "<TODO: transform vector>")
               (hash-table
                "<TODO: transform hash-table>"))))))

;;DOES NOT WORK
;; (defun transform-with (table-name &rest code)
;;   (let ((current-transform-table (get-transform-table table-name)))
;;     (transform code)))

(defmacro with-transform-table (table-name &rest code)
  `(let ((current-transform-table (get-transform-table ,table-name)))
     ,@code))

;;TODO: declare transforms for edebug
;;      error checker

(provide 'transformer)
