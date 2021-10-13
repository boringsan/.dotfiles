
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("a9a67b318b7417adbedaab02f05fa679973e9718d9d26075c6235b1f0db703c8" "0b3aee906629ac7c3bd994914bf252cf92f7a8b0baa6d94cb4dfacbd4068391d" "f91395598d4cb3e2ae6a2db8527ceb83fed79dbaf007f435de3e91e5bda485fb" default))
 '(lsp-haskell-completion-snippets-on nil)
 '(lsp-haskell-formatting-provider "brittany")
 '(package-selected-packages
   '(bufler popper dired-rainbow dired-single dired-ranger dired-collapse dired-hacks-utils dired-hacks dired-launch lsp-treemacs lsp-ivy dashboard yasnippet yaml-mode lsp-ui flycheck company writeroom-mode which-key vertico solaire-mode org-roam org-bullets monkeytype modus-themes magit-popup magit lsp-haskell keyfreq ivy-rich hydra helpful general evil-surround evil-collection eshell-git-prompt elm-mode doom-themes doom-modeline counsel-projectile avy all-the-icons-dired))
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
(put 'upcase-region 'disabled nil)
