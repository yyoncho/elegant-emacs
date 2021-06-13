(defun org-dblock-write:block-update-time (params)
  (require 'dash)
  (let ((fmt (or (plist-get params :format) "%d. %m. %Y"))
        (server-language-alist (-map
                                (-lambda ((&alist 'name 'full-name 'lsp-install-server))
                                  (cons (intern (or lsp-install-server name))
                                        full-name))
                                (json-read-from-string (f-read-text "/home/yyoncho/Sources/lsp/lsp-mode/docs/lsp-clients.json")))))
    (require 'lsp-mode)
    (lsp--require-packages)
    (insert "*Server status*\n")
    ;; (setq widget-image-enable nil)
    ;; (push '("[ ]" . "☐") prettify-symbols-alist)
    ;; (push '("[X]" . "☑" ) prettify-symbols-alist)
    ;; (prettify-symbols-mode)
    (mapc (-lambda ((cln &as &lsp-cln 'server-id 'major-modes))
            (let ((operation (cond
                              ((and (lsp--server-binary-present? cln)
                                    (lsp--client-download-server-fn cln))
                               "Update")
                              ((and (lsp--server-binary-present? cln)
                                    (not (lsp--client-download-server-fn cln)))
                               "Installed")
                              ((lsp--client-download-server-fn cln)
                               "Install")
                              (t "Manual installation")))
                  (language (or (when major-modes
                                  (mapconcat (lambda (mode)
                                               (capitalize (s-replace "-mode" "" (symbol-name mode))))
                                             major-modes
                                             ", "))
                                (alist-get server-id server-language-alist)
                                "Missing")))
              (insert (format "  %s ([[_][%s]]) %s [[elisp:(lsp-install-server nil '%s)][%s]]\n"
                              server-id
                              language
                              (s-repeat (- 62 (+ (length operation)
                                                 (length (symbol-name server-id))
                                                 (length language)))
                                        ".")
                              server-id
                              operation))))
          (lsp--filter-clients #'identity))))

(add-hook
 'org-mode-hook
 (lambda ()
   (org-dblock-update t)
   (save-excursion
     (goto-char (point-max))
     (while (re-search-backward "#\\+BEGIN:\\|#\\+END:" nil t)
       (let ((ov (make-overlay (line-beginning-position)
                               (1+ (line-end-position)))))
         (overlay-put ov 'invisible t))))))

;; (-map
;;  (-lambda ((&alist 'server-name 'full-name))
;;    (cons (intern server-name) full-name))
;;  (json-read-from-string (f-read-text "/home/yyoncho/Sources/lsp/lsp-mode/docs/lsp-clients.json")))
