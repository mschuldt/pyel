
;; This is a tangled file  -- DO NOT EDIT --  Edit in pyel.org

(provide 'py-lib)
;;py-lib.el ends here









(defun py-range (start &optional end step)
  (unless end
    (setq end start
          start 0))
  (number-sequence start (1- end) step))











