;;; ipyel.el --- like ielm, for pyel

;;this is ielm, with a few lines changed to support pyel
;; and occurences of 'ilem' changed to 'ipyel'

;; Copyright (C) 1994, 2001-2013 Free Software Foundation, Inc.

;; Author: David Smith <maa036@lancaster.ac.uk>
;; Maintainer: FSF
;; Created: 25 Feb 1994
;; Keywords: lisp

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Provides a nice interface to evaluating Emacs Lisp expressions.
;; Input is handled by the comint package, and output is passed
;; through the pretty-printer.

;; To start: M-x ipyel.  Type C-h m in the *ipyel* buffer for more info.

;;; Code:

(require 'comint)
(require 'pp)

;;; User variables

(defgroup ipyel nil
  "Interaction mode for Emacs Lisp."
  :group 'lisp)


(defcustom ipyel-noisy t
  "If non-nil, IPYEL will beep on error."
  :type 'boolean
  :group 'ipyel)

(defcustom ipyel-prompt-read-only t
  "If non-nil, the IPYEL prompt is read only.
The read only region includes the newline before the prompt.
Setting this variable does not affect existing IPYEL runs.
This works by setting the buffer-local value of `comint-prompt-read-only'.
Setting that value directly affects new prompts in the current buffer.

If this option is enabled, then the safe way to temporarily
override the read-only-ness of IPYEL prompts is to call
`comint-kill-whole-line' or `comint-kill-region' with no
narrowing in effect.  This way you will be certain that none of
the remaining prompts will be accidentally messed up.  You may
wish to put something like the following in your init file:

\(add-hook 'ipyel-mode-hook
	  (lambda ()
	     (define-key ipyel-map \"\\C-w\" 'comint-kill-region)
	     (define-key ipyel-map [C-S-backspace]
	       'comint-kill-whole-line)))

If you set `comint-prompt-read-only' to t, you might wish to use
`comint-mode-hook' and `comint-mode-map' instead of
`ipyel-mode-hook' and `ipyel-map'.  That will affect all comint
buffers, including IPYEL buffers.  If you sometimes use IPYEL on
text-only terminals or with `emacs -nw', you might wish to use
another binding for `comint-kill-whole-line'."
  :type 'boolean
  :group 'ipyel
  :version "22.1")

(defcustom ipyel-prompt "IPYEL> "
  "Prompt used in IPYEL.
Setting this variable does not affect existing IPYEL runs.

Interrupting the IPYEL process with \\<ipyel-map>\\[comint-interrupt-subjob],
and then restarting it using \\[ipyel], makes the then current
default value affect _new_ prompts.  Unless the new prompt
differs only in text properties from the old one, IPYEL will no
longer recognize the old prompts.  However, executing \\[ipyel]
does not update the prompt of an *ipyel* buffer with a running process.
For IPYEL buffers that are not called `*ipyel*', you can execute
\\[inferior-emacs-lisp-mode] in that IPYEL buffer to update the value,
for new prompts.  This works even if the buffer has a running process."
  :type 'string
  :group 'ipyel)

(defvar ipyel-prompt-internal "IPYEL> "
  "Stored value of `ipyel-prompt' in the current IPYEL buffer.
This is an internal variable used by IPYEL.  Its purpose is to
prevent a running IPYEL process from being messed up when the user
customizes `ipyel-prompt'.")

(defcustom ipyel-dynamic-return t
  "Controls whether \\<ipyel-map>\\[ipyel-return] has intelligent behavior in IPYEL.
If non-nil, \\[ipyel-return] evaluates input for complete sexps, or inserts a newline
and indents for incomplete sexps.  If nil, always inserts newlines."
  :type 'boolean
  :group 'ipyel)

(setq ipyel-prompt "IPYEL> "
      ipyel-prompt-internal "IPYEL> ")

(defcustom ipyel-dynamic-multiline-inputs t
  "Force multiline inputs to start from column zero?
If non-nil, after entering the first line of an incomplete sexp, a newline
will be inserted after the prompt, moving the input to the next line.
This gives more frame width for large indented sexps, and allows functions
such as `edebug-defun' to work with such inputs."
  :type 'boolean
  :group 'ipyel)

(defcustom ipyel-mode-hook nil
  "Hooks to be run when IPYEL (`inferior-emacs-lisp-mode') is started."
  :options '(turn-on-eldoc-mode)
  :type 'hook
  :group 'ipyel)
(defvaralias 'inferior-emacs-lisp-mode-hook 'ipyel-mode-hook)

(defvar * nil
  "Most recent value evaluated in IPYEL.")

(defvar ** nil
  "Second-most-recent value evaluated in IPYEL.")

(defvar *** nil
  "Third-most-recent value evaluated in IPYEL.")

(defvar ipyel-match-data nil
  "Match data saved at the end of last command.")

(defvar *1 nil
  "During IPYEL evaluation, most recent value evaluated in IPYEL.
Normally identical to `*'.  However, if the working buffer is an IPYEL
buffer, distinct from the process buffer, then `*' gives the value in
the working buffer, `*1' the value in the process buffer.
The intended value is only accessible during IPYEL evaluation.")

(defvar *2 nil
  "During IPYEL evaluation, second-most-recent value evaluated in IPYEL.
Normally identical to `**'.  However, if the working buffer is an IPYEL
buffer, distinct from the process buffer, then `**' gives the value in
the working buffer, `*2' the value in the process buffer.
The intended value is only accessible during IPYEL evaluation.")

(defvar *3 nil
  "During IPYEL evaluation, third-most-recent value evaluated in IPYEL.
Normally identical to `***'.  However, if the working buffer is an IPYEL
buffer, distinct from the process buffer, then `***' gives the value in
the working buffer, `*3' the value in the process buffer.
The intended value is only accessible during IPYEL evaluation.")

;;; System variables

(defvar ipyel-working-buffer nil
  "Buffer in which IPYEL sexps will be evaluated.
This variable is buffer-local.")

(defvar ipyel-header ;;mbs
  "*** Welcome to IPYEL ***  Type describe_mode() for help.\n"
  "Message to display when IPYEL is started.")

(defvar ipyel-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\t" 'comint-dynamic-complete)
    (define-key map "\C-m" 'ipyel-return)
    (define-key map "\C-j" 'ipyel-send-input)
    (define-key map "\e\C-x" 'eval-defun)         ; for consistency with
    (define-key map "\e\t" 'completion-at-point)  ; lisp-interaction-mode
    ;; These bindings are from `lisp-mode-shared-map' -- can you inherit
    ;; from more than one keymap??
    (define-key map "\e\C-q" 'indent-sexp)
    (define-key map "\177" 'backward-delete-char-untabify)
    ;; Some convenience bindings for setting the working buffer
    (define-key map "\C-c\C-b" 'ipyel-change-working-buffer)
    (define-key map "\C-c\C-f" 'ipyel-display-working-buffer)
    (define-key map "\C-c\C-v" 'ipyel-print-working-buffer)
    map)
  "Keymap for IPYEL mode.")
(defvaralias 'inferior-emacs-lisp-mode-map 'ipyel-map)

(defvar ipyel-font-lock-keywords
  '(("\\(^\\*\\*\\*[^*]+\\*\\*\\*\\)\\(.*$\\)"
     (1 font-lock-comment-face)
     (2 font-lock-constant-face)))
  "Additional expressions to highlight in IPYEL buffers.")

;;; Completion stuff

(defun ipyel-tab nil
  "Possibly indent the current line as Lisp code."
  (interactive)
  (when (or (eq (preceding-char) ?\n)
	    (eq (char-syntax (preceding-char)) ?\s))
    (ipyel-indent-line)
    t))

(defun ipyel-complete-symbol nil
  "Complete the Lisp symbol before point."
  ;; A wrapper for lisp-complete symbol that returns non-nil if
  ;; completion has occurred
  (let* ((btick (buffer-modified-tick))
	 (cbuffer (get-buffer "*Completions*"))
	 (ctick (and cbuffer (buffer-modified-tick cbuffer))))
    (lisp-complete-symbol)
     ;; completion has occurred if:
    (or
     ;; the buffer has been modified
     (not (= btick (buffer-modified-tick)))
     ;; a completions buffer has been modified or created
     (if cbuffer
	 (not (= ctick (buffer-modified-tick cbuffer)))
       (get-buffer "*Completions*")))))

(defun ipyel-complete-filename nil
  "Dynamically complete filename before point, if in a string."
  (when (nth 3 (parse-partial-sexp comint-last-input-start (point)))
    (comint-dynamic-complete-filename)))

(defun ipyel-indent-line nil
  "Indent the current line as Lisp code if it is not a prompt line."
  (when (save-excursion (comint-bol) (bolp))
    (lisp-indent-line)))

;;; Working buffer manipulation

(defun ipyel-print-working-buffer nil
  "Print the current IPYEL working buffer's name in the echo area."
  (interactive)
  (message "The current working buffer is: %s" (buffer-name ipyel-working-buffer)))

(defun ipyel-display-working-buffer nil
  "Display the current IPYEL working buffer.
Don't forget that selecting that buffer will change its value of `point'
to its value of `window-point'!"
  (interactive)
  (display-buffer ipyel-working-buffer)
  (ipyel-print-working-buffer))

(defun ipyel-change-working-buffer (buf)
  "Change the current IPYEL working buffer to BUF.
This is the buffer in which all sexps entered at the IPYEL prompt are
evaluated.  You can achieve the same effect with a call to
`set-buffer' at the IPYEL prompt."
  (interactive "bSet working buffer to: ")
  (let ((buffer (get-buffer buf)))
    (if (and buffer (buffer-live-p buffer))
  	(setq ipyel-working-buffer buffer)
      (error "No such buffer: %S" buf)))
  (ipyel-print-working-buffer))

;;; Other bindings

(defun ipyel-return nil
  "Newline and indent, or evaluate the sexp before the prompt.
Complete sexps are evaluated; for incomplete sexps inserts a newline
and indents.  If however `ipyel-dynamic-return' is nil, this always
simply inserts a newline."
  (interactive)
  (if ipyel-dynamic-return
      (let ((state
	     (save-excursion
	       (end-of-line)
	       (parse-partial-sexp (ipyel-pm)
				   (point)))))
	(if (and (< (car state) 1) (not (nth 3 state)))
	    (ipyel-send-input)
	  (when (and ipyel-dynamic-multiline-inputs
		     (save-excursion
		       (beginning-of-line)
		       (looking-at-p comint-prompt-regexp)))
	    (save-excursion
	      (goto-char (ipyel-pm))
	      (newline 1)))
	  (newline-and-indent)))
    (newline)))

(defvar ipyel-input)

(defun ipyel-input-sender (_proc input)
  ;; Just sets the variable ipyel-input, which is in the scope of
  ;; `ipyel-send-input's call.
  (setq ipyel-input input))

(defun ipyel-send-input nil
  "Evaluate the Emacs Lisp expression after the prompt."
  (interactive)
  (let (ipyel-input)			; set by ipyel-input-sender
    (comint-send-input)			; update history, markers etc.
    (ipyel-eval-input ipyel-input)))

;;; Utility functions

(defun ipyel-is-whitespace-or-comment (string)
  "Return non-nil if STRING is all whitespace or a comment."
  (or (string= string "")
      (string-match-p "\\`[ \t\n]*\\(?:;.*\\)*\\'" string)))

;;; Evaluation

(defvar ipyel-string)
(defvar ipyel-form)
(defvar ipyel-pos)
(defvar ipyel-result)
(defvar ipyel-error-type)
(defvar ipyel-output)
(defvar ipyel-wbuf)
(defvar ipyel-pmark)

(defun ipyel-eval-input (input-string)   ;;mbs
  "Evaluate the Lisp expression INPUT-STRING, and pretty-print the result."
  (setq input-string (pp-to-string (pyel input-string)))
  ;;TODO: should have a seporate list that new funcitons are added to, the list can be evaled and then cleared
  (pyel-eval-extra-generated-code)
  
  ;; This is the function that actually `sends' the input to the
  ;; `inferior Lisp process'. All comint-send-input does is works out
  ;; what that input is.  What this function does is evaluates that
  ;; input and produces `output' which gets inserted into the buffer,
  ;; along with a new prompt.  A better way of doing this might have
  ;; been to actually send the output to the `cat' process, and write
  ;; this as in output filter that converted sexps in the output
  ;; stream to their evaluated value.  But that would have involved
  ;; more process coordination than I was happy to deal with.
  ;;
  ;; NOTE: all temporary variables in this function will be in scope
  ;; during the eval, and so need to have non-clashing names.
  (let ((ipyel-string input-string)      ; input expression, as a string
        ipyel-form			; form to evaluate
	ipyel-pos			; End posn of parse in string
	ipyel-result			; Result, or error message
	ipyel-error-type			; string, nil if no error
	(ipyel-output "")		; result to display
	(ipyel-wbuf ipyel-working-buffer)	; current buffer after evaluation
	(ipyel-pmark (ipyel-pm)))
    (unless (ipyel-is-whitespace-or-comment ipyel-string)
      (condition-case err
	  (let ((rout (read-from-string ipyel-string)))
	    (setq ipyel-form (car rout)
		  ipyel-pos (cdr rout)))
	(error (setq ipyel-result (error-message-string err))
	       (setq ipyel-error-type "Read error")))
      (unless ipyel-error-type
	;; Make sure working buffer has not been killed
	(if (not (buffer-name ipyel-working-buffer))
	    (setq ipyel-result "Working buffer has been killed"
		  ipyel-error-type "IPYEL Error"
		  ipyel-wbuf (current-buffer))
	  (if (ipyel-is-whitespace-or-comment (substring ipyel-string ipyel-pos))
	      ;; To correctly handle the ipyel-local variables *,
	      ;; ** and ***, we need a temporary buffer to be
	      ;; current at entry to the inner of the next two let
	      ;; forms.  We need another temporary buffer to exit
	      ;; that same let.  To avoid problems, neither of
	      ;; these buffers should be alive during the
	      ;; evaluation of ipyel-form.
	      (let ((*1 *)
		    (*2 **)
		    (*3 ***)
		    ipyel-temp-buffer)
		(set-match-data ipyel-match-data)
		(save-excursion
		  (with-temp-buffer
		    (condition-case err
			(unwind-protect
			     ;; The next let form creates default
			     ;; bindings for *, ** and ***.  But
			     ;; these default bindings are
			     ;; identical to the ipyel-local
			     ;; bindings.  Hence, during the
			     ;; evaluation of ipyel-form, the
			     ;; ipyel-local values are going to be
			     ;; used in all buffers except for
			     ;; other ipyel buffers, which override
			     ;; them.  Normally, the variables *1,
			     ;; *2 and *3 also have default
			     ;; bindings, which are not overridden.
			     (let ((* *1)
				   (** *2)
				   (*** *3))
			       (kill-buffer (current-buffer))
			       (set-buffer ipyel-wbuf)
			       (setq ipyel-result
				     ;;mbs
                                     (pyel-repr (eval ipyel-form lexical-binding)))
			       (setq ipyel-wbuf (current-buffer))
			       (setq
				ipyel-temp-buffer
				(generate-new-buffer " *ipyel-temp*"))
			       (set-buffer ipyel-temp-buffer))
			  (when ipyel-temp-buffer
			    (kill-buffer ipyel-temp-buffer)))
		      (error (setq ipyel-result (error-message-string err))
			     (setq ipyel-error-type "Eval error"))
		      (quit (setq ipyel-result "Quit during evaluation")
			    (setq ipyel-error-type "Eval error")))))
		(setq ipyel-match-data (match-data)))
	    (setq ipyel-error-type "IPYEL error")
	    (setq ipyel-result "More than one sexp in input"))))

      ;; If the eval changed the current buffer, mention it here
      (unless (eq ipyel-wbuf ipyel-working-buffer)
	(message "current buffer is now: %s" ipyel-wbuf)
	(setq ipyel-working-buffer ipyel-wbuf))

      (goto-char ipyel-pmark)
      (unless ipyel-error-type
	(condition-case nil
	    ;; Self-referential objects cause loops in the printer, so
	    ;; trap quits here. May as well do errors, too
	    (setq ipyel-output (concat ipyel-output ipyel-result))
	  (error (setq ipyel-error-type "IPYEL Error")
		 (setq ipyel-result "Error during pretty-printing (bug in pp)"))
	  (quit  (setq ipyel-error-type "IPYEL Error")
		 (setq ipyel-result "Quit during pretty-printing"))))
      (if ipyel-error-type
	  (progn
	    (when ipyel-noisy (ding))
	    (setq ipyel-output (concat ipyel-output "*** " ipyel-error-type " ***  "))
	    (setq ipyel-output (concat ipyel-output ipyel-result)))
	;; There was no error, so shift the *** values
	(setq *** **)
	(setq ** *)
	(setq * ipyel-result))
      (setq ipyel-output (concat ipyel-output "\n")))
    (setq ipyel-output (concat ipyel-output ipyel-prompt-internal))
    (comint-output-filter (ipyel-process) (setq _x ipyel-output))))

;;; Process and marker utilities

(defun ipyel-process nil
  ;; Return the current buffer's process.
  (get-buffer-process (current-buffer)))

(defun ipyel-pm nil
  ;; Return the process mark of the current buffer.
  (process-mark (get-buffer-process (current-buffer))))

(defun ipyel-set-pm (pos)
  ;; Set the process mark in the current buffer to POS.
  (set-marker (process-mark (get-buffer-process (current-buffer))) pos))

;;; Major mode

(define-derived-mode inferior-emacs-lisp-mode comint-mode "IPYEL"
  "Major mode for interactively evaluating Emacs Lisp expressions.
Uses the interface provided by `comint-mode' (which see).

* \\<ipyel-map>\\[ipyel-send-input] evaluates the sexp following the prompt.  There must be at most
  one top level sexp per prompt.

* \\[ipyel-return] inserts a newline and indents, or evaluates a
  complete expression (but see variable `ipyel-dynamic-return').
  Inputs longer than one line are moved to the line following the
  prompt (but see variable `ipyel-dynamic-multiline-inputs').

* \\[comint-dynamic-complete] completes Lisp symbols (or filenames, within strings),
  or indents the line if there is nothing to complete.

The current working buffer may be changed (with a call to `set-buffer',
or with \\[ipyel-change-working-buffer]), and its value is preserved between successive
evaluations.  In this way, expressions may be evaluated in a different
buffer than the *ipyel* buffer.  By default, its name is shown on the
mode line; you can always display it with \\[ipyel-print-working-buffer], or the buffer itself
with \\[ipyel-display-working-buffer].

During evaluations, the values of the variables `*', `**', and `***'
are the results of the previous, second previous and third previous
evaluations respectively.  If the working buffer is another IPYEL
buffer, then the values in the working buffer are used.  The variables
`*1', `*2' and `*3', yield the process buffer values.

Expressions evaluated by IPYEL are not subject to `debug-on-quit' or
`debug-on-error'.

The behavior of IPYEL may be customized with the following variables:
* To stop beeping on error, set `ipyel-noisy' to nil.
* If you don't like the prompt, you can change it by setting `ipyel-prompt'.
* If you do not like that the prompt is (by default) read-only, set
  `ipyel-prompt-read-only' to nil.
* Set `ipyel-dynamic-return' to nil for bindings like `lisp-interaction-mode'.
* Entry to this mode runs `comint-mode-hook' and `ipyel-mode-hook'
 (in that order).

Customized bindings may be defined in `ipyel-map', which currently contains:
\\{ipyel-map}"
  :syntax-table emacs-lisp-mode-syntax-table

  (setq comint-prompt-regexp (concat "^" (regexp-quote ipyel-prompt)))
  (set (make-local-variable 'paragraph-separate) "\\'")
  (set (make-local-variable 'paragraph-start) comint-prompt-regexp)
  (setq comint-input-sender 'ipyel-input-sender)
  (setq comint-process-echoes nil)
  (set (make-local-variable 'comint-dynamic-complete-functions)
       '(ipyel-tab comint-replace-by-expanded-history
	 ipyel-complete-filename ipyel-complete-symbol))
  (set (make-local-variable 'ipyel-prompt-internal) ipyel-prompt)
  (set (make-local-variable 'comint-prompt-read-only) ipyel-prompt-read-only)
  (setq comint-get-old-input 'ipyel-get-old-input)
  (set (make-local-variable 'comint-completion-addsuffix) '("/" . ""))
  (setq mode-line-process '(":%s on " (:eval (buffer-name ipyel-working-buffer))))

  (set (make-local-variable 'indent-line-function) 'ipyel-indent-line)
  (set (make-local-variable 'ipyel-working-buffer) (current-buffer))
  (set (make-local-variable 'fill-paragraph-function) 'lisp-fill-paragraph)
  (add-hook 'completion-at-point-functions
            'lisp-completion-at-point nil 'local)

  ;; Value holders
  (set (make-local-variable '*) nil)
  (set (make-local-variable '**) nil)
  (set (make-local-variable '***) nil)
  (set (make-local-variable 'ipyel-match-data) nil)

  ;; font-lock support
  (set (make-local-variable 'font-lock-defaults)
       '(ipyel-font-lock-keywords nil nil ((?: . "w") (?- . "w") (?* . "w"))))

  ;; A dummy process to keep comint happy. It will never get any input
  (unless (comint-check-proc (current-buffer))
    ;; Was cat, but on non-Unix platforms that might not exist, so
    ;; use hexl instead, which is part of the Emacs distribution.
    (condition-case nil
	(start-process "ipyel" (current-buffer) "hexl")
      (file-error (start-process "ipyel" (current-buffer) "cat")))
    (set-process-query-on-exit-flag (ipyel-process) nil)
    (goto-char (point-max))

    ;; Lisp output can include raw characters that confuse comint's
    ;; carriage control code.
    (set (make-local-variable 'comint-inhibit-carriage-motion) t)

    ;; Add a silly header
    (insert ipyel-header)
    (ipyel-set-pm (point-max))
    (unless comint-use-prompt-regexp
      (let ((inhibit-read-only t))
        (add-text-properties
         (point-min) (point-max)
         '(rear-nonsticky t field output inhibit-line-move-field-capture t))))
    (comint-output-filter (ipyel-process) ipyel-prompt-internal)
    (set-marker comint-last-input-start (ipyel-pm))
    (set-process-filter (get-buffer-process (current-buffer)) 'comint-output-filter)))

(defun ipyel-get-old-input nil
  ;; Return the previous input surrounding point
  (save-excursion
    (beginning-of-line)
    (unless (looking-at-p comint-prompt-regexp)
      (re-search-backward comint-prompt-regexp))
    (comint-skip-prompt)
    (buffer-substring (point) (progn (forward-sexp 1) (point)))))

;;; User command

;;;###autoload
(defun ipyel nil   ;;mbs
  "Interactively evaluate Emacs Lisp expressions.
Switches to the buffer `*ipyel*', or creates it if it does not exist."
  (interactive)
  (let (old-point)
    (unless (comint-check-proc "*ipyel*")
      (with-current-buffer (get-buffer-create "*ipyel*")
	(unless (zerop (buffer-size)) (setq old-point (point)))
	(inferior-emacs-lisp-mode)))
    (switch-to-buffer "*ipyel*")
    (when old-point (push-mark old-point))))

(provide 'ipyel)

;;; ipyel ends here
