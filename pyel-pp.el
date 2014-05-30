;;pretty printer for pyel
(defvar pyel-pp-max-column 80)

(defsubst pyel-column-num ()
  (- (point) (save-excursion (beginning-of-line) (point))))

(defsubst pyel-at-closing-paren ()
  (looking-at "[ \t\n\r]*)"))

(defun pyel-pp-newline-and-indent ()
  "insert a newline at point, move to the beginning of next line and indent"
  (insert "\n")
;;  (next-line)
  ;(beginning-of-line)
  (indent-for-tab-command))

(defun pyel-sexp-fits-on-line-p ()
  "return non-nil if the sexp after point fits within the column
restruction set by `pyel-pp-max-column'
This raises scan error if a sexp does not follow the point"
  (save-excursion
    (goto-char (scan-sexps (point) 1))
    (<= (pyel-column-num) pyel-pp-max-column)))

(defsubst pyel-at-list-p ()
  (looking-at "[ \t\n\r]*("))

(defun pyel-pp-list-as-stack (&optional dont-stack-symbols)
  "called with point on open paren.
when finished the point will be after the closing paren
if DONT-STACK-SYMBOLS is non-nil, keep non-lists on the same line
 symbols and lists are never printed on the same line"
  (let (beg end sym-without-newline)
    (condition-case nil
        (progn
          (pyel-skip-whitespace)
          (when (pyel-at-list-p)
            ;;most move one forward to get into the list
            (forward-char)
            (while (not (pyel-at-closing-paren))
              (pyel-skip-whitespace)
              (setq beg (point))
              (if (pyel-at-list-p)
                  (progn
                    (if sym-without-newline
                        ;;last elem is not followed by a newline
                        (pyel-pp-newline-and-indent))
                    (goto-char (scan-sexps (point) 1))
                    (setq end (pyel-column-num))
                    (if (> end pyel-pp-max-column)
                        (progn
                          (goto-char beg)
                          (pyel-print-as-stack dont-stack-symbols)
                          (pyel-pp-newline-and-indent))
                      ;;else: everything fits
                      (pyel-pp-newline-and-indent))
                    (setq sym-without-newline nil))
                ;;else: we are at a non-list
                (goto-char (scan-sexps (point) 1))
                (if dont-stack-symbols
                    (if (> (pyel-column-num) pyel-pp-max-column)
                        ;;the list of symbols is getting to long
                        (progn (goto-char beg)
                               (pyel-pp-newline-and-indent))
                      (setq sym-without-newline t))
                  (pyel-pp-newline-and-indent)
                  (setq sym-without-newline nil))))))
      (scan-error nil)))
  (when (pyel-at-closing-paren)
    (pyel-skip-whitespace)
    (forward-char)))

(defun pyel-pp-function-call ()
  "prettyprint a function call. must be called on a list of length 1 or greator
the point must be one the opening paren or immediately after"
  (condition-case nil
      (if (pyel-sexp-fits-on-line-p)
          ;;if it fits on the line, just skip over it
          (goto-char (scan-sexps (point) 1))

        (pyel-skip-whitespace)
        (if (pyel-at-list-p)
            ;;most move one forward to get into the function
            ;;otherwise  assume that we are already in it
            (forward-char))
        (goto-char (scan-sexps (point) 1))
        ;;now after the function name
        (if (not (pyel-at-closing-paren))
            ;;if there is room, keep the first arg on the same line
            (if (pyel-sexp-fits-on-line-p)
                (goto-char (scan-sexps (point) 1))))
        ;;now print the rest of the args on separate lines
        (while (not (pyel-at-closing-paren))
          (pyel-pp-newline-and-indent)
          (if (pyel-at-list-p)
              (pyel-pp-sexp)
            (goto-char (scan-sexps (point) 1))))

        (when (pyel-at-closing-paren)
          (pyel-skip-whitespace)
          (forward-char)))
    (scan-error nil)))

(defun pyel-pp-sexp ()
  "prettyprint the sexp at point.
must be called with point at beginning of sexp.
If it is a list, the point must be on or before the open paren,
when finished the point will be after the closing paren"
  (if (pyel-at-list-p)
      ;;TODO: check for printing definition
      (pyel-pp-function-call)
    ;;else: just skip over it for now
    (goto-char (scan-sexps (point) 1))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
                  (and (>= (current-column) 80) (progn (backward-sexp) t))))
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
