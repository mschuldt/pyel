;; This file contains all the code from the fb hackathon  (except for ipyel.el)
;;
;;

;;TODO: cleanup and merge with pyel.org


;; parse both files with bolvinate
;; get the function/method the point of the point in python buffer
;;   get the line number that top of that function (relative to the top of the screen)
;; find the equivalent function/method in the emacs-lisp buffer
;; possition the python buffer so the function starts at the same line number
;;  relative to the top of the screen

;; ? bolvinate for emacs lisp

		    
(require 'ipyel)
(require 'pyel-pp)

;;;currently only supports one buffer at a time

(defvar pyel-output-buffer-format "*PYEL: %s*"
  "format string for buffer name,

formated with the name of the buffer being transformed")

(defvar pyel-current-transform-buffer  nil
  "name of python buffer that is being transformed")

  
(defun pyel-output-buffer-name nil
  "name of the buffer that holds the transformed python")

(defvar pyel-idle-timer nil
  "timer that transforms the code when changes are detected")

(defvar pyel-buffer-changed-p nil
  "this is set to t when the buffer is modified
and set back to nil when the transform is updated")

(defvar pyel-idle-wait-time 1
  "the number of seconds that that pyel would wait before transforming ")
(setq pyel-idle-wait-time 0.2)


(defvar pyel-python-error-overlay nil
  "overlay that markes error line in python buffer")

(defvar pyel-current-python-line 0
  "tracks the current line in python buffer
if the line changes, check if the current tag changes, if it has
then update the current tag overlay")
      
(defun pyel-signify-python-error (&optional line)
  "signal error on LINE in python buffer"
  (let ((line (or line pyel-python-error-line))
	ol) ;overlay
    
    ;;underline error line in red
    (pyel-remove-error-overlay)
    (save-excursion
      (switch-to-buffer pyel-current-transform-buffer)
      (goto-line line)
      (setq ol (make-overlay (line-beginning-position )
			  (line-end-position ))))
      
    (overlay-put ol 'face '(background-color . "red"))
    
    (setq pyel-python-error-overlay ol)
    ;;format modeline red
    
    ))

;;move-overlay
;;overlay-put

(defun pyel-remove-error-overlay ()
  (and pyel-python-error-overlay
       (delete-overlay pyel-python-error-overlay)))

(defun pyel-buffer (&optional out-buff)
  ;;TODO: replace this function in pyel.org
  ;;TODO: this function is now specialized for 'pyel-mode.el'. seporate from basic functionally
  "transform python in current buffer and display in OUT-BUFF,
OUT-BUFF defaults to *pyel-output*"
  (interactive)
  (let ((out (pyel-buffer-to-string))
	(buff (or out-buff "*pyel-output*"))
	error)
    (if (equal out pyel-error-string)
	(pyel-signify-python-error pyel-python-error-line)

      ;;no errors, remove error overlay if present
      (pyel-remove-error-overlay)
      (when pyel-show-translation
					
	(switch-to-buffer-other-window buff)
	(read-only-mode -1)
	(erase-buffer)
	;;    (insert (funcall pyel-pp-function out))
	(pyel-prettyprint out)
	;;(emacs-lisp-mode)
	(lisp-interaction-mode) ;;emacs-lisp-mode does not work with bovinate

	(read-only-mode 1)
	(other-window 1)
	(pyel-update-current-tag-overlay) ;;TODO: do this before switching back
	))))


;;build function and variable translation tables
;;get current function point is in (tag?)
;;put overlay with colored background in python output buffer
;;if not in a function or other tag, find the closest one

(defun pyel-get-python-tags ()
  (let (tags)
  (save-excursion
    (save-window-excursion ;;?
      (switch-to-buffer pyel-current-transform-buffer)
      (setq tags (semantic-fetch-tags))))
  tags))

(defun pyel-get-elisp-tags ()
  (let ((tmp-file  "/tmp/pyel-tmp.el")
	 tags str)
  (save-excursion
    (save-window-excursion ;;?
      (switch-to-buffer pyel-output-buffer-name)
      (read-only-mode -1) ;;needed now?
       (write-region nil nil tmp-file  nil 'silent)
       (read-only-mode 1)
       (find-file tmp-file)
;       (lisp-interaction-mode)
       (semantic-mode 1)
      (setq tags (semantic-fetch-tags))
      (kill-buffer)
      ))
  tags))

;; (pyel-get-elisp-tags)
;; (setq func (nth 4 (setq py-tags (pyel-get-python-tags))))
;; func
;; (semantic-tag-start func)
;; 370

;; (defun test ()
;;   (interactive)
;; (setq x (semantic-current-tag)))
;; x



;; (setq x (make-overlay (semantic-tag-start func)
;; 		      (semantic-tag-end func)
;; 		      (get-buffer pyel-current-transform-buffer)
;; 		      ))

;; (delete-overlay x)

;; (overlay-put x 'face '(background-color . "red"))


;; (semantic-tag-put-attribute func 'face '(background-color . "red"))


;; semantic tag funcs:
;;  semantic-tag-p 
;;  semantic-tag-start
;;  semantic-tag-end
;;  semantic-tag-bounds

;; (pyel-get-elisp-tags)

(defvar pyel-current-elisp-tag-overlay nil
  "overlay of current tag in the elisp buffer")
  
(defun pyel-update-current-tag-overlay ()
  "updates the overlay over the elisp tag corresponding to that current python tag
also centers the buffer around the tag"
  (and (overlayp pyel-current-elisp-tag-overlay)
       (delete-overlay pyel-current-elisp-tag-overlay)) ;;TODO: move instead
  
  (let* ((cbuff (current-buffer))
	 (tag (pyel-get-current-elisp-tag))
	 (start (semantic-tag-start tag))
	 (end (semantic-tag-end tag)))
	 
	 (setq pyel-current-elisp-tag-overlay
		(make-overlay start end (get-buffer pyel-output-buffer-name)))
    (overlay-put pyel-current-elisp-tag-overlay
		 'face '(background-color . "grey22"))

    (when (string= (buffer-name) pyel-current-transform-buffer)  ;;this should aways be true
      (other-window 1)
      (with-selected-window
	  (get-buffer-window pyel-output-buffer-name)
	(goto-char start)
	(recenter))
      (other-window 1))))


;; (defun pyel-current-elisp-tag-bounds ()
;;   (let ((tag pyel-get-current-elisp-tag))

;; (defun pyel-update-current-lisp-tag
  
  
(defun pyel-get-current-python-tag ()
  "return the python tag at point"
  (let (tag)
    (save-excursion
      (save-window-excursion
      (switch-to-buffer pyel-current-transform-buffer)
      (semantic-current-tag)))))

(defun pyel-get-current-elisp-tag ()
  (pyel-update-tags)
  (unless pyel-python-tags
    (message "(pyel) Failed to update python tags."))
  (unless pyel-elisp-tags
    (message "(pyel) Failed to update elisp tags."))
    
  (let ((py-tag (pyel-get-current-python-tag)))
    (and py-tag
	 pyel-python-tags
	 pyel-elisp-tags
	 (pyel-get-elisp-tag-equivalent py-tag))))

(require  'py-lib) ;;TODO: move to 

(defvar pyel-elisp-tags nil
  "semantic generated tags for the elisp bufffer")

(defvar pyel-python-tags nil
  "semantic generated tags for the python bufffer")


(defun pyel-update-tags ()
  "reparse python and elisp buffers for semantic tags"
  
  (setq pyel-elisp-tags (pyel-get-elisp-tags)
	pyel-python-tags (pyel-get-python-tags)))
   
(defun pyel-get-elisp-tag-equivalent (python-tag)
  "return the elisp tag that corresponds to PYTHON-TAG"
  (and pyel-elisp-tags
       python-tag
       ;;;have to get the elisp equivalent of the name with pyel
       (assoc (symbol-name (pyel (car python-tag))) pyel-elisp-tags)))

(defun pyel-update-transform ()
  "transform the python from `pyel-current-transform-buffer' and
insert the resulting emacs-lisp into `pyel-ouptu-buffer-name'"
  (if (string= (buffer-name) pyel-current-transform-buffer)
      (pyel-buffer pyel-output-buffer-name)
    (save-excursion
      (save-window-excursion
	(switch-to-buffer pyel-current-transform-buffer)
	(pyel-buffer pyel-output-buffer-name)))))

(defvar pyel-current-python-tag nil
  "saves the current semantic tag for the python buffer")

;;TODO: this does not remove the timer
(defun pyel-deactivate ()
  "deactivate the pyel mode"
  (cancel-timer pyel-idle-timer)
  (remove-hook 'after-change-functions 'pyel-changes-hook-function))

(defun pyel-idle-timer-func ()
  "function that is run when emacs goes idle, checks for changes
if changes are found, it transforms the code"
  (if (not (get-buffer "test.py"))
      (pyel-deactivate);;file has been closed
    
    (when pyel-buffer-changed-p
      ;;in case pyel-update-tranform crashed, set to nil before transforming to help prevent death loop
      (setq pyel-buffer-changed-p nil) 
      (pyel-update-transform))
    (let ((cline (line-number-at-pos))
	  (ptag))
      ;;if line number changed, check if if current tag changed,
      ;;if current tag has changed, then update its overlay
      (when pyel-show-translation
	(unless (= pyel-current-python-line cline)
	  (setq pyel-current-python-line cline
		ptag (pyel-get-current-python-tag))
	  (unless (equal pyel-current-python-tag ptag)
	    (pyel-update-current-tag-overlay)
	    (setq pyel-current-python-tag ptag)))))))

;;test
(defun pyel-changes-hook-function (a b c)
  "function that is added to `after-change-functions' hook"
  (when (and pyel-current-transform-buffer
	     (string= (buffer-name) pyel-current-transform-buffer))
    (setq pyel-buffer-changed-p t)))
;;;;;;
;(add-hook 'after-change-functions 'pyel-changes-hook-function)
; after-change-functions

;;TODO: this should be merged with pyel-mode
(defun pyel-live-mode (&optional arg) ;;TODO arg
  "toggle pyel minor mode to translate the current buffer
if arg is positive, turn on, else turn off"
  (interactive)
  ;; (let ((set-on set-off))
  ;; (when (numberp arg)
  ;;   (if (< arg 0)
  ;; 	(setq set-off t)
  ;;     (setq set-on t)))
  ;;TODO: check if current buffer is python
  (let ((buff (buffer-name)))
    ;;toggle on/off 
      (setq pyel-current-transform-buffer
	(if (string= buff pyel-current-transform-buffer)
	    nil ;;off
	  buff)) ;;on

      (if pyel-current-transform-buffer 
	  ;;just activated the mode
	  (progn
	  (setq pyel-output-buffer-name
		(format pyel-output-buffer-format  pyel-current-transform-buffer))
	  ;;TODO: actiave timer
	  (setq pyel-idle-timer (run-with-idle-timer pyel-idle-wait-time
						     :repeat
						     'pyel-idle-timer-func))
	  (add-hook 'after-change-functions 'pyel-changes-hook-function)
	  (setq pyel-buffer-changed-p t) ;;force first transform
	  (message "Live pyel enabled.")
	  )
	  
	;;Else: disable the mode
	(pyel-deactivate)
	(message "Live pyel disabled.")
	)))


(defun test ()
  (interactive)
  (python-nav-end-of-defun)
  )

(defun test ()
  (interactive)
  (setq x (thing-at-point 'defun)))

(defun pyel-eval-region (&optional start end)

  
  "Transform the (python) region to e-lisp, then eval it"
  (interactive)
  (eval (pyel (buffer-substring-no-properties
	       (or start (region-beginning))
	       (or end (region-end)))))
  (pyel-eval-extra-generated-code))

(defun pyel-eval-defun ()
  "transform the python function at point to e-lisp, then eval it"
  (interactive)
  (save-excursion
    (let ((start (progn (python-nav-beginning-of-defun) (point)))
	  (end (progn (python-nav-end-of-defun) (point))))
      (pyel-eval-region start end))))

(defun pyel-eval-buffer ()
  "translate and eval the whole buffer"
  (interactive)
  (pyel-eval-region (point-min) (point-max)))

(defvar pyel-show-translation t
  "if non-nil, pyel will display live translation everytime the buffer is changed")

(defun pyel-toggle-follow ()
  "toggle whether or not the translations are being followed"
  (interactive)
  (message "PYEL live translation toggled %s"
	   (if (setq pyel-show-translation (not pyel-show-translation))
	       "ON"
	     "OFF")))


(define-derived-mode pyel-mode python-mode "PYEL"
  "A mode writing pyel style python with live transformations"
   (pyel-live-mode)
   (abbrev-mode -1);;causing problems with expanding 'def'
   )

(define-key pyel-mode-map (kbd "C-c C-r") 'pyel-eval-region)
(define-key pyel-mode-map (kbd "C-M-x") 'pyel-eval-defun)
(define-key pyel-mode-map (kbd "C-c C-c") 'pyel-eval-buffer)
(define-key pyel-mode-map (kbd "C-c t") 'pyel-toggle-follow)

(defun run-pyel ()
  (interactive)
  (ipyel))

(defun pyel-eval-extra-generated-code ()
  "eval supporting functions in `pyel-function-definitions'"
 ;;TODO: write to file and then load so the code can be revied later
  (mapc 'eval pyel-function-definitions))

(defvar pyel-required '(cl)
"list of required featured used by pyel generated code")

;;test
(defun pyel-load (file)
  "similar to `load' but for python
convert python FILE to e-lisp, saving all generated code and byte compiling it
WARNING: will create file named FILE.el, overwriting without warning"

;;TODO: hash files and load elisp file if present in directory and python file has
;;      not changed
  (let ((pyel-function-definitions nil)
	(pyel-defined-functions nil)
	(pyel-context nil)
	(el-file (format "%s.el" file))
	python)
    (with-temp-buffer
      (insert-file-contents file)
      (setq python (pyel (buffer-string))) ;;TODO: error checking
      (with-temp-buffer
	(mapc (lambda (x) (cl-prettyprint `(require ',x)))
	      pyel-required)
	(insert "\n")
	(mapc (lambda (x) (cl-prettyprint x))
	      pyel-function-definitions)
	(if (equal (car python) 'progn)
	    (mapc (lambda (x) (cl-prettyprint x)) python)
	  (cl-prettyprint python))
	(write-file el-file)))
    (byte-compile-file el-file :load)))


(defun test ()
  (interactive)
  (end-of-buffer)
  (recenter-top-bottom)
  )

(provide 'pyel-mode)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;move to pyel.org

;;TODO: pyel-method-transform needs to handle methods with same names and different number of arguments => name mangling - how to handle *args ?


(pyel-method-transform remove (obj x)
		       (list _) ->  (let ((i (list-index x obj)))
				      (if i
					  (setq $obj (append (subseq obj 0 i)
							     (subseq obj (1+ i))))
					(error "ValueError: list.remove(x): x not in list")))
		       (object _) -> (remove obj x))

;;insert
(pyel-method-transform insert (obj i x)
		       (list _) -> (let () (setq $obj (append (subseq obj 0 i)
						      (list x)
						      (subseq obj i))))
		       (object _) -> (insert obj i x))




;;append
(pyel-method-transform extend(obj thing)
                  (list _) -> (setq $obj (append obj thing))
                  (_ _)    -> (append obj thing))


;(pyel "'string'.count('i')")
;(pyel-count-method "string" "i")

;;(mpp pyel-defined-functions)



;;count
(pyel-method-transform count (obj elem)
		  (string _) -> (count-str-matches obj elem)
                  (list _) -> (count-elems-list obj elem)
		  (vector _) -> (count-elems-list obj elem)
                  (object _)  -> (count thing))

;;Index
;(pyel "a = ('a','b','c')
;assert a.index('b') == 1
;assert 'string'.index('in') == 3
;")

(pyel-method-transform index (obj elem)
                  (list _) -> (list-index elem obj)
		  (string _) -> (string-match elem obj);;TODO: this uses regex, python does not
		  (vector _) -> (vector-index elem obj)

                  (object _)    -> (__index__ obj thing)) ;;?



;;UnaryOp

;(pyel "not a
;-x" )
 
(def-transform unary-op pyel ()
      (lambda (op operand)
        (call-transform op operand)))

(pyel-create-py-func not (x)
                    (object) -> (__not__ x) ;;?
		    (_) -> (not x))
(pyel-create-py-func usub (x)
		     (number) -> (- x)
		     (object) -> (__usub__ x) ;;?
		    )


;(pyel "a in b
;a not in b")

;;a not in b
;; function:  	is_not(a, b)  (in the operator module)
(pyel-create-py-func not-in (l r)
                       (_ list) -> (not (member l r))
		       (_ vector) -> (not (vector-member l r))
		       (_ object) -> (--not-in-- r l) ;;?
		       )


;;a in b
;; function:  	is_(a, b)
(pyel-create-py-func in (l r)
		     (_ list) -> (member l r)
		     (_ vector) -> (vector-member l r)
		     (_ object) -> (--in-- r l);;?
		     )


;;TODO: option a in b to return bool like python for the element like e-lisp

(defun vector-member (elt vector)
  "Return non-nil if ELT is an element of VECTOR.  Comparison done with `equal'."
  (let ((i 0)
	(len (length vector))
	found)
    (while (and (not found)
		(< i len))
      (if (equal (elt vector i) elt)
	  (setq found t)
	(setq i (1+ i))))
    found))


(defun list-index (elem list)
  "return the index of ELEM in LIST"
  (let ((m (member elem list)))
    (when m
      (- (length list) (length m)))))


(defun vector-index (elem vector)
  "return the index of ELEM in VECTOR"
  (let ((i 0)
	(len (length vector))
	found)

    (while (and (< i len)
		(not found))
      (if (equal (aref vector i) elem)
	  (setq found i)
	(setq i (1+ i))))
    found))


(defun count-str-matches (string substr)
  "count number of occurrences of SUBSTR in STRING"
  (with-temp-buffer
    (insert string)
    (goto-char 1)
    (how-many substr)))

(defun count-elems-list (list elem)
  "return how many times ELEM occurs in LIST"
  (let ((c 0))
    (dolist (x list)
      (if (equal x elem)
	  (setq c (1+ c))))
    c))
	   
(defun count-elems-vector (vector elem)
  "return how many times ELEM occurs in VECTOR"
  (let ((c 0)
	(i 0)
	(len (length vector)))
    (while (< i len)
      (if (equal (aref vector i) elem)
	  (setq c (1+ c)))
      (setq i (1+ i)))
    c))


;;modified:
(defun pyel-do-call-transform (possible-types args type-switch)
  "This is responsible for  producing a call to NAME in the most
      efficient way possible with the known types"
  (let* ((possible-types (let ((ret nil)
                               arg)
                           ;;get entries in form (arg . type)
                           (dolist (p-t possible-types)
                             (setq arg (car p-t))
                             (dolist (type (cdr p-t))
                               (push (cons arg type) ret)))
                           ret))
         (c 0)
         (new-args (loop for a in args
                         collect (intern (format "__%s__" (symbol-name a)))))
         ;;list of symbols to replace
         ;;format: (symbol replace)
         (let-vars (append (mapcar* (lambda (a b) (list a b))
                                     args new-args)
                            ))
	 ;;the __x__ type replacements interfere with the (\, x) type replacements
	 ;;so they must be seporated and done one at a time
	 (arg-replacements1 let-vars)
	 (arg-replacements2 (mapcar (lambda (x)
                                             (list  (intern (format "$%s" x)) (list '\, x)))
                                           args))
	 (arg-replacements (append arg-replacements1 arg-replacements2))

	 (current-replace-list nil)
         ;; (arg-replacements (append let-vars
         ;;                           (mapcar (lambda (x)
         ;;                                     (list  (intern (format "$%s" x)) (list '\, x)))
         ;;                                   args)))
                  
         (ts ) ;;??
         (valid nil) ;;list of valid arg--types
         (found nil)
         (lets nil)
         var value type all-good var-vals len)
    ;;        (print "possible types = ")
    ;;        (print possible-types)
    
    
    ;;collect all the arg-type--code pairs that are valid possibilities,
    ;;that is, members of possible-types.
    ;;This essentially throws out all the arg types that have been ruled out.
    (dolist (t-s (pyel-expand-type-switch-2 args type-switch))
      (if (equal (car t-s) 'and)
          (progn (setq all-good t
                       found nil)
                 (dolist  (x (cadr t-s)) ;;for each 'and' member type-switch
                   (dolist (pos-type possible-types) ;;for each arg type
                     (if (and (equal (eval (car x)) (car pos-type)) 
                              (equal (cadr x) (cdr pos-type)))
                         (setq found t)))
                   (setq all-good (if (and all-good found) t nil)))
                 (when all-good
                   (push t-s valid)))
        ;;else
        (if (eq (car t-s) t) ;;when all types are _
            (push t-s valid)
          ;;otherwise check if the type is one of the valid types
          
          
          (dolist(pos-type possible-types)
            (when (and (equal (eval (caar t-s)) (car pos-type))
                       (equal (cadar t-s) (cdr pos-type)))
              (push t-s valid))))));;TODO: break if found?
    
    
    
    ;;generate code to call NAME
    ;;if there is 2 posible types, use IF. For more use COND
    (setq len (length valid))
    
    (flet ((replace (code replacements)
                    (let ((ret nil)
                          found)
                      
                      (dolist (c code)
                        (setq found nil)
                        (dolist (r replacements)
                          (if (consp c)
                              (setq c (replace c replacements))
                            (if (and (equal c (car r))
                                     (not found))
                                (progn (push (cadr r) ret)
                                       (setq found t)))))
                        (unless found
                          (push c ret)))
                      (reverse ret)))

           (type-tester (x) (cadr (assoc x pyel-type-test-funcs)))
           (and-type-tester (x) (cadr (assoc (car x) pyel-type-test-funcs)))
           ;;(get-replacement (arg) ;;returns arg replacement
           ;;                 (cadr (assoc arg arg-replacements)))
           (get-replacement (arg) ;;returns arg replacement
                            (cadr (assoc arg current-replace-list)))

	   ;;bug fix maybe...
	   (get-replacement-OLD (arg) ;;returns arg replacement
				(cadr (assoc arg arg-replacements)))

	   ;;replaces the vars, one type at a time
	   (replace-vars (code)
			 (let* ((current-replace-list arg-replacements1)
				(code (replace code arg-replacements1))
				(current-replace-list arg-replacements2))
			   (replace code arg-replacements2)))
	    
           (gen-cond-clause (t-s--c) ;;Type-Switch--Code
                            (if (equal (car t-s--c) 'and)
                                `((and ,@(mapcar '(lambda (x)
                                                    ;;TODO: test
                                                    `(,(type-tester (cadr x))
                                                      ,(get-replacement-OLD
                                                        (car x))))
                                                 (cadr t-s--c)))
				  ,(replace-vars (caddr t-s--c)))
				     
                              ;;TODO
                              (if (equal (car t-s--c) t) ;;all types where _
                                  `(t ,(replace-vars (cadr t-s--c)))
                                `((,(type-tester (cadar t-s--c))
                                   ,(get-replacement-OLD (caar t-s--c)))
                                  ,(replace-vars (cadr t-s--c))
                                  ))))
           
           (gen-varlist ()
                          (mapcar (lambda (x) `(,(cadr x) ,(list '\, (car x))))
                                  let-vars)
                          ))
      
      (cond ((<= len 0) "ERROR: no valid type")
            ((= len 1)
             (if (eq (caar valid) 'and)
                 ;;; (eval (caddar valid))
                 (caddar valid)
               ;;;(eval  (cadar valid))
               (cadar valid)
               ))
            ;;?TODO: are there possible problems with evaluating the arguments
            ;;       multiple times? Maybe they should be put in a list
            (t (let* ((clauses (mapcar 'gen-cond-clause valid))
                      (clauses (if (eq (caar clauses) t)
                                   clauses
                                 (cons
                                  '(t (error "invalid type, expected <TODO>"))
                                  clauses)))
                      (varlist (gen-varlist)))
                 `(backquote (let ,varlist
                               (cond ,@(reverse clauses))))))))))

