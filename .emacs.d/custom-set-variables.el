(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(lsp-haskell-formatting-provider "brittany")
 '(custom-safe-themes
   '("990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37" "a9a67b318b7417adbedaab02f05fa679973e9718d9d26075c6235b1f0db703c8" default))
 '(package-selected-packages
   '(dired-collapse dired-ranger dired-single dired-rainbow org-roam org-appear visual-fill-column org-bullets elm-mode lsp-haskell lsp-treemacs lsp-ivy lsp-ui company lsp-mode projectile magit evil-surround dashboard))
 '(safe-local-variable-values
   '((eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")
     (eval let
	   ((root-dir-unexpanded
	     (locate-dominating-file default-directory ".dir-locals.el")))
	   (when root-dir-unexpanded
	     (let*
		 ((root-dir
		   (expand-file-name root-dir-unexpanded))
		  (root-dir*
		   (directory-file-name root-dir)))
	       (unless
		   (boundp 'geiser-guile-load-path)
		 (defvar geiser-guile-load-path 'nil))
	       (make-local-variable 'geiser-guile-load-path)
	       (require 'cl-lib)
	       (cl-pushnew root-dir* geiser-guile-load-path :test #'string-equal))))
     (eval setq-local guix-directory
	   (locate-dominating-file default-directory ".dir-locals.el"))
     (eval add-hook 'after-save-hook #'org-babel-tangle 0 t))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
