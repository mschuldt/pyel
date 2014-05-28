(defvar pyel-test-py-functions nil
  "list of generated python test functions.
when `pyel-run-tests' is run, these are translated to e-lisp
and compared to expected values")

(setq _pyel-tests nil)
(setq _pyel-structure-tests nil)

(defvar pyel-test-func-counter 0
  "just another counter")

(defun pyel-make-test-func-name ()
  (setq pyel-test-func-counter (1+ pyel-test-func-counter)))

(defun cl-prettyprint-to-string (form)
  (with-temp-buffer
    (cl-prettyprint form)
    (buffer-string)))

(defun pyel-test-list-form-p (form)
  "return t if FORM describes part of a pyel test.
All lists are a part of pyel tests except those whose
car is 'lambda or 'quote"
  (and
   (listp form)
   (> (length form) 0)
   (not (or (eq (car form) 'lambda)
            (eq (car form) 'quote)))))

(defun pyel-valid-test-form-p (form)
  "Returns t if FORM is a valid pyel test"
  (or (stringp form)

      (and (consp form)
           (>= (length form) 2)
           (stringp (car form))
           (or
            ;; form: ("test" expect)
            (and (= (length form) 2)
                 (not (pyel-test-list-form-p (cadr form)))
                 ;; (or (null (cadr form)) (eq (cadr form) t)
                 ;;     (not (symbolp (cadr form))))
                 t
                 )
            ;; form: ("setup" test-forms ...)
            (and (let ((ok t))
                   (dolist (x (cdr form))
                     (setq ok (and ok (and (consp x)
                                           (= (length x) 2)
                                           (stringp (car x))
                                       ;;;test-form: ("test1" result1)
                                           (or (and (not (pyel-test-list-form-p (cadr x)))
                                                    (or (null (cadr x))
                                                        (eq (cadr x) t)
                                                        ;;(not (symbolp (cadr x)))
                                                        t
                                                        ))
                                               ;;test-form: ("test1setup" ("test1" result1))
                                               (let ((subform (cadr x)))
                                                 (and (consp subform)
                                                      (= (length subform) 2)
                                                      (stringp (car subform))
                                                      (and (not (pyel-test-list-form-p (cadr subform)))
                                                           (or (null (cadr subform))
                                                               (eq (cadr subform) t)
                                                               ;;(not (symbolp (cadr subform)))
                                                               t
                                                               )))))))))
                   ok))))))

(ert-deftest pyel-test-valid-forms ()
  ;;valid forms
  (should (pyel-valid-test-form-p "test"))
  (should (pyel-valid-test-form-p '("test" nil)))
  (should (pyel-valid-test-form-p '("test" "expect")))
  (should (pyel-valid-test-form-p '("test" 'expect)))
  (should (pyel-valid-test-form-p '("test" 3)))
  (should (pyel-valid-test-form-p '("test" '(a b c))))
  (should (pyel-valid-test-form-p '("test" (lambda () c))))
  (should (pyel-valid-test-form-p '("setup" ("test1" 'result1))))
  (should (pyel-valid-test-form-p '("setup" ("test1setup" ("test1" 34)))))
  (should (pyel-valid-test-form-p '("setup" ("test1" 'result1) ("test2" "r3") ("test2" 3) ("test1setup" ("test1" 'result1)))))
  (should (pyel-valid-test-form-p '("setup" ("test1" '(a b c)) ("test2" (lambda () 4))  ("test1setup" ("test1" '(a b c))))))
  (should (pyel-valid-test-form-p '("setup" ("test1setup" ("test1" (lambda () 3))))))
  ;;invalid forms
  (should (not (pyel-valid-test-form-p 3)))
  (should (not (pyel-valid-test-form-p 'symbol)))
  (should (not (pyel-valid-test-form-p '(s))))
  (should (not (pyel-valid-test-form-p '(s 3))))
  (should (not (pyel-valid-test-form-p '("skld" "ldkj" "lskdjf"))))
  ;;(should (not (pyel-valid-test-form-p '("test" expect))))
  (should (not (pyel-valid-test-form-p '('a "expect"))))
  (should (not (pyel-valid-test-form-p '(3 expect))))
  (should (not (pyel-valid-test-form-p '((b c) 3))))
  (should (not (pyel-valid-test-form-p '((lambda ()) '(a b c)))))
  (should (not (pyel-valid-test-form-p '("setup" (3 result1)))))
  (should (not (pyel-valid-test-form-p '(3 ("test1" result1)))))
  (should (not (pyel-valid-test-form-p '("setup" ("test1setup" (34 "test1"))))))
  ;;(should (not (pyel-valid-test-form-p '("setup" ("test1setup" ("test1" sym))))))
  (should (not (pyel-valid-test-form-p '("setup" ("test1" result1) ("test2" "r3") ("test2" 3) ("test1setup" (1 result1))))))
  (should (not (pyel-valid-test-form-p '("setup" ("test1" '(a b c)) (test2 (lambda () 4))  ("test1setup" ("test1" '(a b c)))))))
  (should (not (pyel-valid-test-form-p '(("test1setup" ("test1" (lambda () 3))))))))

(defmacro pyel-create-tests (name &rest py-tests)
  (let ((complete nil)
        (py-ast nil)
        (el-ast nil)
        (c 0)
        ert-tests
        tests
        invalid-form
        trans)
    (message "creating tests for '%s'" name)
    (progv
        (mapcar 'car test-variable-values)
        (mapcar 'cadr test-variable-values)

      (flet ((pyel-create-new-marker () "test_marker"))
        (condition-case err
            (dolist (test (reverse py-tests))
              (or (setq valid-form (pyel-valid-test-form-p test)) (error nil))
              (cond ((and (consp test)
                          (>= (length test) 2)
                          (and (consp (cadr test))
                               (not (or (eq (caadr test) 'lambda)
                                        (eq (caadr test) 'quote))))
                          )
                     (let* ((tests)  ;;form: ("setup" ("test1" result1) ("test2" result2) ...)
                            (name-str (replace-regexp-in-string "-" "_" (symbol-name name)))
                            (test-name (concat "pyel_test_" name-str "_" (number-to-string (pyel-make-test-func-name))))
                            (d 0))

                       (push (setq _x (pyel-functionize (concat (car test)
                                                                (if (= (length test) 2)
                                                                    (if (listp (cadr test))
                                                                        ;;form:  ("setup" ("test" expect))
                                                                        (concat "\nreturn " (caadr test))
                                                                      ;;form: ("test" expect)
                                                                      (concat "return " (caaddr (cdr test))))
                                                                  ;;form ("setup" ("test1setup" ("test1" result1)) ...)
                                                                  (mapconcat (lambda (x) (concat "\nif n == " (number-to-string (setq d (1+ d))) ":\n"
                                                                                                 (if (and (listp (cadr x))
                                                                                                          ;;form:  ("setup" ("test" expect))
                                                                                                          (not (or (eq (caadr x) 'lambda)
                                                                                                                   (eq (caadr x) 'quote)
                                                                                                                   (null (caadr x)))))
                                                                                                     (concat (pyel-indent-py-code (car x)) "\n"
                                                                                                             (concat " return " (caadr x)))
                                                                                                   ;;form: ("test" expect)
                                                                                                   (concat " return " (car x)))))
                                                                             (cdr test) "\n")))
                                                        test-name (if (= (length test) 2) nil "n")))
                             pyel-test-py-functions)
                       (setq d 0)
                       (mapc (lambda (x)
                               (push `(ert-deftest
                                          ,(intern (format "pyel-test-%s-%s" name-str
                                                           (number-to-string (setq c (1+ c))))) ()
                                        (equal (eval (pyel ,(if (= (length test) 2)

                                                                (format "%s()" test-name)
                                                              (format "%s(%s)" test-name (setq d (1+ d))))))
                                               ,(if (and (listp (cadr x))
                                                         (not (or (eq (caadr x) 'lambda)
                                                                  (eq (caadr x) 'quote))))
                                                    (cadr (cadr x)) ;;form: ("setup" ("test" expect))
                                                  (cadr x)))) ;;;;form: ("test" expect)
                                     tests))
                             (cdr test))
                       (setq _pyel-tests (append _pyel-tests (reverse tests)))
                       ))

                    ((consp test) ;;form: ("test" expect)
                     (push `(ert-deftest
                                ,(intern (concat "pyel-" (symbol-name name)
                                                 (number-to-string (setq c (1+ c))))) ()
                              (equal (eval (pyel ,(concat (pyel-functionize (car test) "_pyel21312")
                                                          "\n_pyel21312()")))
                                     ,(cadr test)))

                           _pyel-tests))

                    (t (progn ;;form "test"
                         ;;check complete code transformation
                         (setq trans (pyel test))
                         (push `(ert-deftest ,(intern (format "pyel-transform-test-%s-%s"  name (pyel-make-test-func-name))) ()
                                  (equal (pyel ,test)
                                         ',trans))
                               _pyel-structure-tests)
                         ;;check python ast
                         (push `(ert-deftest ,(intern (format "pyel-py-ast-test-%s-%s"  name (pyel-make-test-func-name))) ()
                                  (equal (py-ast ,test)
                                         ,(py-ast test)))
                               _pyel-structure-tests)
                         ;;check transformed .py syntax tree
                         (push `(ert-deftest ,(intern (format "pyel-el-ast-test-%s-%s"  name (pyel-make-test-func-name))) ()
                                  (string= (pyel ,test nil nil t)
                                           ,(pyel test nil nil t)))
                               _pyel-structure-tests)))))
          (error (error "Error while creating test: '%s'. Error: %s" name (if valid-form
                                                                              err
                                                                            "Invalid form"))))))))

(defun pyel-create-tests-with-known-types (name known-types &rest py-code)
  "just like `pyel-create-tests-with-known-types' fakes the known types during the tests"
  ;;TODO
  )

(defun pyel-indent-py-code (code &optional indent)
  "Indent CODE by INDENT. CODE is a string. INDENT defaults to one space"
  (let ((indent (or indent " ")))
    (mapconcat 'identity (mapcar (lambda (x) (concat indent x))
                                 (split-string code "\n"))
               "\n")))

(defun pyel-generate-tests ()
  (interactive)
  ;;read in tests from pyel-tests.el
  ;;save resulting tests in  pyel-tests-generated.el
  ;;evaluate all the tests
  (let ((pyel-test-func-counter 0)
        pyel-test-py-functions
        _pyel-tests
        _pyel-structure-tests)

    (load-file (file-path-concat pyel-directory "pyel-tests.el"))
    (with-temp-buffer
      ;;save py test functions
      (insert (format "(setq pyel-test-py-functions '%s)"
                      (prin1-to-string pyel-test-py-functions)))
      ;;insert normal tests
      (mapc (lambda (x)
              (insert (prin1-to-string x) "\n"))
            _pyel-tests)
      ;;insert the other tests
      (mapc (lambda (x)
              (insert (prin1-to-string x) "\n"))
            _pyel-structure-tests)

      (insert "\n(provide 'pyel-tests-generated)")
      (write-file (file-path-concat pyel-directory "pyel-tests-generated.el")))))

(defalias 'pyel-verify 'pyel-run-tests)
(defun pyel-run-tests (&optional selector)
  "setup and run pyel test.
SELECTOR may be any of the following:
'pyel-test' all normal tests. This is the default
The following tests check code structure, but do not eval
generated lisp code.
'pyel-transform-test' check full code transform
'pyel-py-ast-test' check python AST
'pyel-el-ast-test' check lisp AST

'pyel' will run all tests'"
  (interactive)
  (setq selector (or selector
                     (let ((tests '(("all" . "pyel")
                                    ("standard" . "pyel-test")
                                    ("python AST" . "pyel-py-ast-test")
                                    ("lisp AST" . "pyel-el-ast-test")
                                    ("transform" . "pyel-transform-test"))))
                       (cdr (assoc (completing-read "select tests> "
                                                    (mapcar 'car tests)
                                                    nil t)
                                   tests)))))
  (flet ((pyel-create-new-marker () "test_marker"))
    (progv
        (mapcar 'car test-variable-values)
        (mapcar 'cadr test-variable-values)

      (if (or (string= selector "pyel-test")
              (string= selector "pyel"))
          (let ((tmp-file "/tmp/pyel-test-functions.el"))
            (message "Evaluating test functions...")
            ;;(mapc (lambda (x) (eval (pyel x))) pyel-test-py-functions)
            (find-file tmp-file)
            (erase-buffer)
            (mapc (lambda (x)
                    ;;macroexpand so edebug-defun can be used on it
                    (insert (cl-prettyprint-to-string (macroexpand (pyel x)))))
                  pyel-test-py-functions)
            (save-buffer)
            (kill-buffer)
            (load-file tmp-file)))

      (ert-run-tests-interactively selector)
      )))

(defun pyel-functionize (py-code &optional func-name &rest args)
  "wrap PY-CODE in a function definition
FUNC-NAME defaults to 'f'"
  (concat  "def " (or func-name "f") (if args (format "(%s)" (mapconcat 'identity args ", ")) "()") ":\n"
           (mapconcat 'identity (mapcar (lambda (x) (concat " " x))
                                        (split-string py-code "\n"))
                      "\n")))

(provide 'pyel-testing)

;;pyel-testing.el ends here
