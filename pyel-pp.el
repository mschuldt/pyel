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
  (indent-for-tab-command))

(defvar pyel-num-sexp-that-fit 0
  "the number of sexpressions <= N that can fit on the line
   set by (pyel-sexp-fits-on-line-p N)")

(defsubst pyel-jump-sexp (&optional n)
  "jump over the next N s-expressions
raises scan-error if that is not possible"
  (default n 1)
  (goto-char (scan-sexps (point) n)))

(defun pyel-sexp-fits-on-line-p (&optional n)
  "return non-nil if the N sexps after point fits within the column
restriction set by `pyel-pp-max-column'
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

(defsubst pyel-enter-list ()
  (pyel-skip-whitespace)
  (forward-char))

(defun pyel-pp-list-within-bounds ()
  "return t if the current list is too long
point must be inside the list"
  (save-excursion
    (let ((ok t))
      ;; (if (pyel-at-list-p)
      ;;     (pyel-enter-list))
      (while (and (and (not (pyel-at-closing-paren))) ok)
        (if (> (pyel-column-num) pyel-pp-max-column)
            (setq ok nil)
          (pyel-jump-sexp)))
      (<= (pyel-column-num) pyel-pp-max-column))))

(defun pyel-pp-get-sizes ()
  "return a list of numbers corresponding to the printed
length of each element in the list after the point.
Must be called on or directly before the opening paren
this only works on lists that are all printed on the same line"
  (let ((lengths)
        start)
    (save-excursion
      (if (pyel-at-list-p)
          (pyel-enter-list))
      (condition-case nil
          (while t
            (pyel-skip-whitespace)
            (setq start (point))
            (pyel-jump-sexp)
            (push (- (point) start) lengths))
        (scan-error (reverse lengths))))))

(defun pyel-pp-get-arglist-group-size ()
  (let ((lengths)
        (type-re "&\\(optional\\|rest\\|kwonly\\|kwarg\\)")
        start current)
    (save-excursion
      (if (pyel-at-list-p)
          (pyel-enter-list))
      (setq start (point))
      (condition-case nil
          (while t
            (pyel-skip-whitespace)
            (when (looking-at type-re)
                  (push (- (point) start) lengths)
                  (setq start (point)))
            (pyel-jump-sexp))
        (scan-error (reverse (cons (- (point) start) lengths)))))))

(defun pyel-pp-max-point-in-list ()
  (save-excursion
    (condition-case nil
        (while t
          (pyel-jump-sexp))
      (scan-error (point)))))

(defsubst pyel-exit-list ()
  (pyel-skip-whitespace)
  (forward-char))

(defun pyel-pp-newline-maybe ()
  "newline if the rest of the current list is too long"
  (if (not (pyel-pp-list-within-bounds))
      (pyel-pp-newline-and-indent)))

(defun pyel-pp-goto-end ()
  "move to the end of the list. the point will be before the closing paren"
  (while (not (pyel-at-closing-paren))
    (pyel-jump-sexp)))

(defsubst pyel-pp-line-maybe ()
  "print the list on the current line if it fits. Otherwise do nothing
if called from within a list this will leave the point before the closing paren
if called with the point beore the opening paren, skip list entirely"
  (if (and (pyel-at-list-p)
           (pyel-sexp-fits-on-line-p))
      (pyel-jump-sexp)
    (if (pyel-pp-list-within-bounds)
        (pyel-pp-goto-end))))

(defun pyel-pp-stack-rest ()
  "stack the rest of this list
the first element is left on the current line
when done the point will be before the closing paren"
  (if (not (pyel-at-closing-paren))
      (pyel-jump-sexp))
  (while (not (pyel-at-closing-paren))
    (pyel-pp-newline-and-indent)
    (pyel-jump-sexp)))

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
                          (unless (pyel-at-closing-paren)
                          (pyel-pp-newline-and-indent)))
                      ;;else: everything fits
                      (unless (pyel-at-closing-paren)
                          (pyel-pp-newline-and-indent)))
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

(defun pyel-pp-group-args (n &optional dont-leave)
  "prettyprint the function at point with N args per line
if the N args don't fit on the line, stack them.
May also be called with the point after the function name.
If dont-leave is non-nil, do not exit current list,
when finished, the point will be right before the closing paren"
  (when (pyel-at-list-p)
    (pyel-enter-list)
    (pyel-jump-sexp))

  ;;after the function name
  (while (not (pyel-at-closing-paren))
    (dotimes (_ n)
      (unless (pyel-at-closing-paren)
        (pyel-skip-whitespace)
        (pyel-pp-sexp)))
    (unless (pyel-at-closing-paren)
      (pyel-pp-newline-and-indent)))
  ;;(pyel-pp-goto-end)
  (if (and (pyel-at-closing-paren)
           (not dont-leave))
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
          ((string-match "^group-?\\([0-9]+\\)" s)
           (list 'pyel-pp-group-args
                 (string-to-number (match-string 1 s))
                 :dont-leave))
          ((or (eq x 'no-stack)
               (eq x 'max))
           '(pyel-pp-max-per-line))
          ((eq x 'line\?)
           '(pyel-pp-line-maybe))
          ((eq x 'newline\?)
           '(pyel-pp-newline-maybe))
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
                    (when (pyel-at-list-p)
                      (pyel-enter-list)
                      (if (not (pyel-at-closing-paren))
                          (pyel-jump-sexp)))
                    ;;point now after the function name
                    ,@(mapcar (lambda (x)
                                `(if (not (pyel-at-closing-paren))
                                     ,(pyel-pp-get-print-fn x)))
                              args)

                    (while (not (pyel-at-closing-paren))
                      (pyel-pp-sexp)
                      (unless (pyel-at-closing-paren)
                        (pyel-pp-newline-and-indent)))
                    (when (pyel-at-closing-paren)
                      (pyel-exit-list)))
                (error ,(format "Error with prettyprinter for '%s'" name))))
           pyel-pp-print-defs))

(define-pp let varlist newline)
(define-pp let* varlist newline)
(define-pp setq group-2)
(define-pp condition-case :var newline)
(define-pp while :test newline)
(define-pp if :test newline)
(define-pp when :test newline)
(define-pp unless :test newline)
(define-pp defvar :name :default newline)
(define-pp defun :name arglist newline)
(define-pp defsubst :name arglist newline)
(define-pp defmacro :name arglist newline)
(define-pp save-excursion newline?)
(define-pp save-window-excursion newline?)
(define-pp save-match-data newline?)
(define-pp save-restriction newline?)
(define-pp progn newline?)
(define-pp lambda arglist line?)
(define-pp eval-when-compile newline)
(define-pp defcustom :symbol :standard newline)
(define-pp eval-after-load :file newline)
(define-pp dolist :TODO newline)
(define-pp cond newline?)
(define-pp ignore-errors newline?)

(define-pp def :name arglist arglist newline?)
(define-pp define-class :name line? newline)
(define-pp py-for :vars :in line? newline)
(define-pp pyel-set group-2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar pyel-pp-newline-functions nil
  "list of functions that should have a newline inserted before them")

(setq pyel-pp-newline-functions '("defun"
                                  "defmacro"
                                  "defclass"
                                  "defmethod"
                                  "define-class"
                                  "def")

      pyel-pp-newline-function-re (mapconcat (lambda (x)
                                               (concat "(" x))
                                             pyel-pp-newline-functions
                                             "\\|"))


(defun pyel-prettyprint (form)
  "Insert a pretty-printed rendition of a Lisp FORM in current buffer."
  (let ((start (point))
        last re-indent)
    (insert "\n" (prin1-to-string form) "\n")
    (goto-char start)
    (pyel-pp-sexp)
    (setq last (point))
    (goto-char start)

    ;;fix quotes
    (while (search-forward "(quote " last t)
      (delete-char -8)
      (insert "'")
      (forward-sexp)
      (delete-char 1)
      (setq last (- last 8)
            re-indent t))

    ;;remove the leading progn
    (goto-char start)
    (skip-chars-forward " \n")
    (when (looking-at "(progn[ \n]")
      (kill-word 1)
      (goto-char last)
      (re-search-backward ")" nil :noerror)
      (delete-char 1)
      (setq last (- last 8)
            re-indent t))

      ;;add spaces before important functions
      (goto-char start)
      (while (re-search-forward pyel-pp-newline-function-re last :noerror)
        (goto-char (match-beginning 0))
        (insert "\n")
        (incf last)
        (goto-char (match-end 0)))

      ;; ;;delete leading whitespace
      ;; (goto-char 1)
      ;; (skip-chars-forward " \n")
      ;; (kill-region 1 (point))

      ;; ;;reindent everything
      ;; (indent-region (point-min) (point-max))
      (goto-char last)
      (if re-indent
          (indent-region start last))))



(provide 'pyel-pp)
