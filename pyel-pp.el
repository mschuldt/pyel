;;pretty printer for pyel

(defvar pyel-pp-newline-functions nil
  "list of functions that should have a newline inserted before them")

(setq pyel-pp-newline-functions '("defun"
				  "defmacro"
				  "defclass"
				  "defmethod"))

(defun pyel-prettyprint (form)
  "pretty print FORM using modified version of cl-prettyprint"
  
  (let ((start (point))
	end regex deleted-progn)
    
    (flet ((cl--do-prettyprint ()
			       (pyel--do-prettyprint))
	   (gen-regex () (mapconcat (lambda (x)
				      (concat "(" x))
				    pyel-pp-newline-functions
				    "\\|")))
      (setq regex (gen-regex))
      ;;do the modified cl-prettyprint   
      (cl-prettyprint form))
    (setq end (point))
    (goto-char start)
    ;;remove the leading progn
    ;;TODO: instead map cl--do-prettyprint over the list if first elem is progn
    (skip-chars-forward " \n")
    (when (looking-at "(progn")
      (kill-word 1)
      (setq deleted-progn t))
    
    ;;add spaces before important functions
    (while (re-search-forward regex end :noerror)
      (goto-char (match-beginning 0))
      (insert "\n")
      (goto-char (match-end 0)))
    
    ;;delete last ')' if first progn was deleted
    (if (re-search-backward ")" start :noerrror)
	(delete-char 1)
      (message "invalid syntax"))
    ;;delete leading whitespace
    (goto-char 1)
    (skip-chars-forward " \n")
    (kill-region 1 (point))

    ;;reindent everything ::Q why is it not perfect alread?
    (indent-region (point-min) (point-max))
    ))


(defun pyel--do-prettyprint ()
  "mostly stolen from  `cl--do-prettyprint'"
  (skip-chars-forward " ")
  (if (looking-at "(")
      (let ((skip (or (looking-at "((") (looking-at "(prog")
		      (looking-at "(unwind-protect ")
		      (looking-at "(function (")
		      (looking-at "(cl--block-wrapper ")))
	    (two (or (looking-at "(defclass ")
		     (looking-at "(defun ")
		     (looking-at "(defmacro ")
		     (looking-at "(defmethod ")))
	    
	    (let (or (looking-at "(let\\*? ")
		     (looking-at "(while ")
		     (looking-at "(save-excursion ")))
	    (set (looking-at "(p?set[qf] ")))
	(if (or skip let
		(progn
		  (forward-sexp)
		  (and (>= (current-column) 60) (progn (backward-sexp) t))))
	    (let ((nl t))
	      (forward-char 1)
	      (cl--do-prettyprint)
	      (or skip (looking-at ")") (cl--do-prettyprint))
	      (or (not two) (looking-at ")") (cl--do-prettyprint))
	      (while (not (looking-at ")"))
		(if set (setq nl (not nl)))
		(if nl (insert "\n"))
		(lisp-indent-line)
		(cl--do-prettyprint))
	      (forward-char 1))))
    (forward-sexp)))


(provide 'pyel-pp)
