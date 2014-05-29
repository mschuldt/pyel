;; This file contains some the code from the fb hackathon - the rest has now been merged into pyel.org
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

(defun pyel-transform-buffer (&optional out-buff)
  ;;TODO: replace this function in pyel.org
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
;;                    (semantic-tag-end func)
;;                    (get-buffer pyel-current-transform-buffer)
;;                    ))

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
        (pyel-transform-buffer pyel-output-buffer-name)))))

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
  ;;    (setq set-off t)
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

;;insert

;;append

                                        ;(pyel "'string'.count('i')")
                                        ;(pyel-count-method "string" "i")

;;(mpp pyel-defined-functions)

;;count

;;Index
                                        ;(pyel "a = ('a','b','c')
                                        ;assert a.index('b') == 1
                                        ;assert 'string'.index('in') == 3
                                        ;")

;;UnaryOp

                                        ;(pyel "not a
                                        ;-x" )

                                        ;(pyel "a in b
                                        ;a not in b")

;;TODO: option a in b to return bool like python for the element like e-lisp
