;;pretty printer for pyel
(defvar pyel-pp-max-column 80)

(defvar pyel-pp-print-defs (make-hash-table :test 'eq)
  "hash table of print definitions. the key is the name of the function/macro")

(defvar pyel-pp-print-default-fn 'pyel-pp-function-call)

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

(defvar pyel-num-sexp-that-fit 0
  "the number of sexpressions <= N that can fit on the line
   set by (pyel-sexp-fits-on-line-p N)")

(defun pyel-sexp-fits-on-line-p (&optional n)
  "return non-nil if the N sexps after point fits within the column
restruction set by `pyel-pp-max-column'
N defaults to 1
if there is less then N sexps after the point, the number is
assigned to `pyel-num-sexp-that-fit'"
  (default n 1)
  (save-excursion
    (condition-case nil
        (let ((not-done t))
          (setq pyel-num-sexp-that-fit 0)
          (while (and not-done (< pyel-num-sexp-that-fit n))
            (goto-char (scan-sexps (point) 1))
            (if (<= (pyel-column-num) pyel-pp-max-column)
                (incf pyel-num-sexp-that-fit)
              (setq not-done nil)))
          (<= (pyel-column-num) pyel-pp-max-column))
      (scan-error pyel-num-sexp-that-fit))))

(defun pyel-sexp-n-left-in-list ()
  "return the number of sexp left in the list after point"
  (save-excursion
    (let ((count 0))
      (condition-case nil
          (while t
            (goto-char (scan-sexps (point) 1))
            (incf count))
        (scan-error count)))))

(defsubst pyel-at-list-p ()
  (looking-at "[ \t\n\r]*("))

(defun pyel-pp-varlist (&optional stack-symbols)
  "print the list after point in a let varlist style.
called with point on open paren.
when finished the point will be after the closing paren
if STACK-SYMBOLS is non-nil, stack non-lists on different lines
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
                          (pyel-pp-varlist stack-symbols)
                          (pyel-pp-newline-and-indent))
                      ;;else: everything fits
                      (pyel-pp-newline-and-indent))
                    (setq sym-without-newline nil))
                ;;else: we are at a non-list
                (goto-char (scan-sexps (point) 1))
                (if (not stack-symbols)
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

(defun pyel-pp-arglist ()
  "print the list after point in an arglist style.
called with point on open paren.
when finished the point will be after the closing paren
If there is room, the list is printed on the current line
otherwise the list is stacked, if possible each of
parameter type (&optional, &rest) gets its own line.
extended arg type for the 'def' macro are supported"
  (let ((end (save-excursion (pyel-jump-sexp) (point)))
        (space (pyel-sexp-fits-on-line-p))
        (type-re "&\\(optional\\|rest\\|kwonly\\|kwarg\\)")
        (group-sizes (pyel-pp-get-arglist-group-size))
        stack)
    (if space
        (pyel-jump-sexp)
      ;;else: group the param types together
      (pyel-enter-list)
      (if (= (length group-sizes) 1)
          ;;single type, just stack them
          (dotimes (_ (pyel-sexp-n-left-in-list))
            (pyel-jump-sexp)
            (if (not (pyel-at-closing-paren))
                (pyel-pp-newline-and-indent)))
        ;;else: contains multiple parameter types

        (while group-sizes
          ;;for each group print it on the current line if it fits,
          ;;otherwise stack it
          (setq stack
                (> (+ (pyel-column-num) (car group-sizes)) pyel-pp-max-column))
          (if (looking-at type-re)
              (progn
                (pyel-jump-sexp)
                (if stack
                    (pyel-pp-newline-and-indent))))
          (while (and (not (looking-at type-re))
                      (not (pyel-at-closing-paren)))
            (pyel-jump-sexp)
            (if stack
                (pyel-pp-newline-and-indent))
            (pyel-skip-whitespace))
          (if (and (not stack)
                   (not (pyel-at-closing-paren)))
              (pyel-pp-newline-and-indent))

          (setq group-sizes (cdr group-sizes))))
      (if (pyel-at-closing-paren)
          (pyel-exit-list)))))

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

(defun pyel-pp-max-per-line ()
  "print as many elements of the list at point on each line as possible
if the thing after point is not a list, skip over it"
  (if (pyel-at-list-p)
      (let (n)
        (pyel-enter-list)
        (setq n (pyel-sexp-n-left-in-list))
        (while (> n 0)
          (while (and (pyel-sexp-fits-on-line-p) (> n 0))
            (pyel-jump-sexp)
            (decf n))
          (if (not (pyel-at-closing-paren))
              (pyel-pp-newline-and-indent)))
        (if (pyel-at-closing-paren)
            (forward-char)))
    (pyel-jump-sexp)))

(defun pyel-pp-group-args (n)
  "prettyprint the function at point with N args per line
if the N args don't fit on the line, stack them"
  (if (pyel-at-list-p)
      (pyel-enter-list))
  (pyel-jump-sexp)
  ;;after the function name
  (while (eq (pyel-sexp-fits-on-line-p n) t)
    (pyel-jump-sexp n)
    (unless (pyel-at-closing-paren)
      (pyel-pp-newline-and-indent)))
  (if (pyel-at-closing-paren)
      (forward-char)))

(defun pyel-pp-sexp ()
  "prettyprint the sexp at point.
must be called with point at beginning of sexp.
If it is a list, the point must be on or before the open paren,
when finished the point will be after the closing paren"
  (if (pyel-at-list-p)
      (funcall (setq func (pyel-pp-get-next-print-def)))
    ;;else: just skip over it for now
    (pyel-jump-sexp)))

(defun pyel-pp-get-next-print-def ()
  "return the name of the function call after point"
  (save-excursion
    (let ((sym (if (re-search-forward "[ \t\n\r]*(?\\([^ \t\n\r)]*\\)" nil t)
                   (intern-soft (match-string 1)))))
      (gethash sym pyel-pp-print-defs pyel-pp-print-default-fn))))

(defun pyel-pp-get-print-fn (x)
  (let ((s (if (symbolp x) (symbol-name x) ""))
        n)
    (cond ((eq x 'newline)
           '(pyel-pp-newline-and-indent))
          ((string-match "^:" s)
           '(pyel-pp-sexp))
          ((eq x 'arglist)
           '(pyel-pp-arglist))
          ((eq x 'varlist)
           '(pyel-pp-varlist))
          ((string-match "^group\\([0-9]+\\)" s)
           (list 'pyel-pp-group-args
                 (string-to-number (match-string 1 s))))
          ((or (eq x 'no-stack)
               (eq x 'max))
           '(pyel-pp-max-per-line))
          ((functionp x)
           (list x))
          ((symbolp x)
           (list 'funcall x))
          ((listp x) x)
          (t (error "pyel-pp-get-print-fn: unrecognized print type")))))

(defmacro define-pp (name &rest args)
  (assert (symbolp name))
  (assert (> (length args) 0))
  (puthash name
           `(lambda ()
              (condition-case err
                  (progn
                    (if (pyel-at-list-p)
                        (pyel-enter-list))
                    (setq start (point))
                    (if (not (pyel-at-closing-paren))
                        (pyel-jump-sexp))

                    ,@(mapcar (lambda (x)
                                `(if (not (pyel-at-closing-paren))
                                     ,(pyel-pp-get-print-fn x)))
                              args)

                    (while (not (pyel-at-closing-paren))
                      (pyel-pp-newline-and-indent)
                      (pyel-pp-sexp))
                    (when (pyel-at-closing-paren)
                      (pyel-exit-list)))
                (error ,(format "Error with prettyprinter for '%s'" name))))
           pyel-pp-print-defs))


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
