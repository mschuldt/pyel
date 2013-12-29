
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

(defun set-transform-table (table-name)
  (setq current-transform-table (get-transform-table table-name)))


(defun get-transform-table (table-name)
  (cdr (assoc table-name transform-tables)))

(defun get-transform (name table-name)
  (gethash name (get-transform-table table-name)))


(defmacro translate-form (form)
  )

;;transform modifiers, 
(defvar transform-no-eval nil) ;;for debugging
(defvar transform-quote-args t);;this should be set by the transform def

(defun transform (&rest code) 
  (if (> (length code) 1)
      (mapconcat 'transform code "\n") ;;TODO: optional newline
    (let ((code (car code))
	  var--func)
      (when (and transform-quote-args (listp code))
	  (setq orig-code code
		code `(,(car code)
		       ,@(mapcar (lambda (x) `(quote ,x)) (cdr code)))))
      (case (type-of code)
	((cons list) ;;TODO: what if (car code) is not of type symbol? possible?
	 (if (and (eq (type-of (car code)) 'symbol)
		  (setq var--func (gethash (car code) current-transform-table)))
	     (let* ((varlist (car var--func))
		    (func (cdr var--func))
		   (args (cdr code))
		   fcall)
	       (when func
		 (setq fcall `(let* ,varlist (funcall ,func ,@args)))
		 (if transform-no-eval
		     fcall
		   (eval fcall))))
	   ;;else: no defined transform
	   (if (consp (car code))
	       (cons (transform (car code)) (mapcar 'transform (cdr code))) 
	     (if (null (car code))
		 nil ;;?
	       `(,(car code) ,@(mapcar 'transform (cdr orig-code))))))) ;;don't use quoted args

;;	(string (pp-to-string code));(concat "\""  (replace-regexp-in-string "\\\" "\\\\\" code) "\"")) ;;TODO: does this account for all cases?

	((symbol integer float string) code)

	(vector
	 "<vector>")
	(hash-table
	 "<hash-table>")))))

;;DOES NOT WORK
;; (defun transform-with (table-name &rest code)
;;   (let ((current-transform-table (get-transform-table table-name)))
;;     (transform code)))
  
		       
(defmacro with-transform-table (table-name &rest code)
  `(let ((current-transform-table (get-transform-table ,table-name)))
     ,@code))

;;WTF: when evaling buffer this would evaluate anyways!!
;; (when nil 
;;   (insert "hi")
;;   ;;TODO: use the emacs testing
;;   (setq transform-tables nil)
;;   (make-transform-table 'test)
;;   (get-transform-table 'test)
;;   (def-transform test and (lambda (&rest conditions)
;; 			    (mapconcat 'transform conditions " && ")))

;;   (gethash 'and (get-transform-table 'test))

;;   (set-transform-table 'test)

;;   ;;test. '(func (3 4) (4 2)) => '(func (quote (3 4)) (quote (4 2)))
;;   (let ((code '(func (3 4) (4 2))))
;;     `(,(car code) ,@(mapcar (lambda (x) `(quote ,x)) (cdr code)))
;;     )
 
;;   )

;;TODO: macro stepper
;;      error checker


(provide 'transformer)
