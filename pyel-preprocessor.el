(require 'python) ;;python-syntax-comment-or-string-p

(defvar pyel-pp--macro-names nil
  "list of all macro names that the preprocessor recognizes
          Do not modify this directory. use <TODO: define> to create new definitions")

;;macros that don't need to be specially defined
(setq pyel-pp--macro-names '("save_excursion"
                             "save_window_excursion"
                             "cond"
                             "lambda"
                             "with_temp_buffer"))

(defun pyel-declare-macro (name)
  "Declare NAME as a macro
TODO: not all macro translations will work when  declared this way."
  (unless (stringp name)
    (setq name (symbol-name name)))
  (push name pyel-pp--macro-names))

(defvar pyel-py-macro-prefix "__pyel__macro__"
  "prepend this to e-lisp macro call in python before generating ast")

;;TODO:
(defun pyel-reprocess (&optional filename output)
  "pre-process FILENAME, or the current buffer if nil
          write to OUTPUT, if nil write to buffer *pyel-pp-out*")

;;TODO:
(defun pyel-generate-built-in-macro-name-list ()
  "Find and add names of built in macros to `pyel-pp--macro-names'"
  )

(defun pyel-create-new-marker ()
  (format "__pyel_marker_%d__" (incf pyel-marker-counter)))

(defvar pyel-marked-ast-pieces nil
  ;;used to share code between the preprocessor and the transforms
  "a-list of marked ast pieces
  element form: (marker . ast)")

(defvar pyel-type-declaration-regexp
  "^[ \t]*\\([a-zA-Z1-9_]+\\)[ \t]+\\([a-zA-Z1-9_]+\\)\\([,a-zA-Z1-9_]*\\)[ \t]*$"
  "matches variable type declaration syntax
match fields: 1. type
              2. variable name
              3. list of comma separated variable names")

(defvar py-reserved-keywords
  (let ((ht (make-hash-table :test 'eq :size 100)))
    (mapc (lambda (x)
            (puthash x t ht))
          '(False      class      finally    is         return
                       None       continue   for        lambda     try
                       True       def        from       nonlocal   while
                       and        del        global     not        with
                       as         elif       if         or         yield
                       assert     else       import     pass
                       break      except     in         raise))
    ht)
  "hash table of reserved python keywords")

(defun pyel-convert-backticks ()
  (goto-char 1)
  (while (re-search-forward "`" nil :no-error)
    (when (not (python-syntax-comment-or-string-p))
      (backward-delete-char 1)
      (insert "quote(")
      (forward-sexp)
      (insert ")"))))

(defun pyel-convert-type-declarations ()
  (save-excursion
    (goto-char 1)
    (let (fmt-string type first rest)
      (while (re-search-forward pyel-type-declaration-regexp nil :no-error)
        (when (and (not (save-match-data (python-syntax-comment-or-string-p)))
                   (not (gethash (intern (match-string 1))
                                 py-reserved-keywords)))

          (setq type (match-string 1)
                first (match-string 2)
                rest (or (match-string 3) "")
                fmt-string (format "%s(%%s, %s)"
                                   pyel-type-declaration-function
                                   type))
          (back-to-indentation)
          (kill-line)
          (insert (format fmt-string first))
          (mapc (lambda (x)
                  (newline-and-indent)
                  (insert (format fmt-string x)))
                ;;first elem is empty string
                (subseq (split-string rest ",") 1)))))))

(defun pyel-preprocess-buffer () ;;recursive function
  (interactive)
  (python-mode)
  (pyel-convert-type-declarations)
  (pyel-convert-backticks)
  (cl-flet ((create-regex (name)
                          (format "\\(%s\\)[ \t\n]*("
                                  (replace-regexp-in-string "-" "_" name))))
    (let (re marker p code line-start line-end done name)
      (dolist (name pyel-pp--macro-names)
        ;;TODO group these names together to minimize transverses
        (setq re (create-regex name))
        (goto-char 1)
        (while (and (re-search-forward re nil :no-error)
                    (not (save-match-data (python-syntax-comment-or-string-p))))
          (setq marker (pyel-create-new-marker)
                line-start (line-number-at-pos))
          (replace-match marker)
          (insert "(")
          (backward-char) ;;cursor on (
          (setq p (point))
          (python-nav-forward-sexp)
          (setq line-end (line-number-at-pos))
          (push (list marker name (buffer-substring-no-properties p (point)))
                code)
          (delete-region p (point))
          (dotimes (n (- line-end line-start))
            ;;Q any problems with random newlines?
            (insert "\n"))))
      ;;now transform the code pieces
      (dolist (c code)
        (setq marker (first c)
              name (second c)
              c (third c))

        (with-temp-buffer
          ;;        (find-file "/tmp/pp.py")
          (insert c)
          (backward-delete-char 1) ;;delete the last ')'
          (goto-char (point-min))
          (delete-char 1) ;;delete the first '('
          (untabify (point-min) (point-max))
          ;;delete leading spaces until at least one line is without any
          (setq done nil)
          (while (not done)
            (goto-char 1)
            ;;(end-of-line) ;;the first already has whitespace removed
            (if (not (re-search-forward "^[^ \n]" nil :noerror))
                (progn
                  (goto-char 1) ;;(end-of-line)
                  (while (re-search-forward "^ " nil :noerror)
                    (replace-match "")
                    (end-of-line)))
              (setq done t)))
                                        ;           (save-buffer)
          (push (list (read marker)
                      (read (_to- name))
                      (read (pyel-buffer-to-string :ast-only)))
                pyel-marked-ast-pieces))))))

(provide 'pyel-preprocessor)
