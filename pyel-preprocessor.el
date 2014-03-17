
(defvar pyel-pp--macro-names nil
  "list of all macro names that the preprocessor recognizes
          Do not modify this directory. use <TODO: define> to create new definitions")

;;macros that don't need to be specially defined
(setq pyel-pp--macro-names '("save_excursion"
                             "save_window_excursion"
                             "cond"
                             "lambda"))

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

(defun pyel-preprocess-buffer ()
  (interactive)
  (cl-flet ((create-regex (name)
                          (format "\\(%s\\)[ \t\n]*("
                                  (replace-regexp-in-string "-" "_" name))))
    (let (re)
      (dolist (name pyel-pp--macro-names)
        ;;TODO group these names together to minimize transverses
        (setq re (create-regex name))
        (goto-char 1)
        (while (re-search-forward re nil :no-error)
          (replace-match (format "while %s%s:"
                                 pyel-py-macro-prefix
                                 (match-string 1))))))))

(defun pyel-create-new-marker ()
  (format "__pyel_marker_%d__" (incf pyel-marker-counter)))

(defvar pyel-marked-ast-pieces nil
  ;;used to share code between the preprocessor and the transforms
  "a-list of marked ast pieces
  element form: (marker . ast)")

(defun pyel-preprocess-buffer2 () ;;recursive function
  (interactive)
  (cl-flet ((create-regex (name)
                          (format "\\(%s\\)[ \t\n]*("
                                  (replace-regexp-in-string "-" "_" name))))
    (let (re marker p code line-start line-end done name)
      (dolist (name pyel-pp--macro-names)
        ;;TODO group these names together to minimize transverses
        (setq re (create-regex name))
        (goto-char 1)
        (while (re-search-forward re nil :no-error)
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
            (end-of-line) ;;the first already has whitespace removed
            (if (not (re-search-forward "^[^ \n]" nil :noerror))
                (progn
                  (goto-char 1) (end-of-line)
                  (while (re-search-forward "^ " nil :noerror)
                    (replace-match "")
                    (end-of-line)))
              (setq done t)))
                                        ;           (save-buffer)
          (push (list (read marker)
                      (read (_to- name))
                      (pyel-buffer-to-string :ast-only))
                pyel-marked-ast-pieces))))))

(provide 'pyel-preprocessor)
