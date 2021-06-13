(load (concat (file-name-directory load-file-name) "sanity.el"))
(load (concat (file-name-directory load-file-name) "elegance.el"))
(load (concat (file-name-directory load-file-name) "org.el"))



(setq package-selected-packages
      '(lsp-mode yasnippet lsp-treemacs helm-lsp projectile hydra flycheck company avy which-key helm-xref dap-mode posframe posframe helm-icons lsp-java all-the-icons company-quickhelp rust-mode))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)


(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; (load-theme 'doom-one t)
;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(helm-icons-enable)

(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(with-eval-after-load 'treemacs-icons
  (treemacs-resize-icons 15))

(which-key-mode)
(add-hook 'java-mode-hook #'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      comp-deferred-compilation t
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1

      ;; avoid resizing of popup while typing.
      company-tooltip-maximum-width 60
      company-tooltip-minimum-width 60

      ;; less noise
      company-frontends '(company-pseudo-tooltip-frontend)

      ;; less noise
      lsp-completion-show-detail nil
      lsp-completion-show-kind nil

      helm-buffer-details-flag nil

      lsp-idle-delay 0.1
      lsp-headerline-breadcrumb-enable t
      lsp-signature-function #'lsp-signature-posframe

      company-icon-size 15
      company-quickhelp-delay 0.1)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (add-hook 'lsp-mode-hook
            (lambda ()
              (setq-local company-format-margin-function
                          #'company-vscode-light-icons-margin)))
  (company-quickhelp-mode)
  (yas-global-mode))
