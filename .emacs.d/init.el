(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar
(tab-bar-mode)              ; Enable the tab bar

(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-10"))

(column-number-mode)
;; (global-display-line-numbers-mode t)

;; Disable line numbers for some modes
;; (dolist (mode '(elm-compilation-mode-hook
;; 		elm-interactive-mode-hook
;; 		eshell-mode-hook
;; 		help-mode-hook
;; 		helpful-mode-hook
;; 		magit-popup-mode-hook
;; 		shell-mode-hook
;;                 term-mode-hook
;; 		org-mode-hook))
;;   (add-hook mode (lambda () (display-line-numbers-mode 0))))

(dolist (mode '(prog-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode t))))

;; Initialize package sources
(require 'package)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize use-package on non-Linux platforms
;(unless (package-installed-p 'use-package)
;  (package-install 'use-package))

(require 'use-package)

(if init-file-debug
    (setq use-package-verbose t
	  use-package-expand-minimally nil
	  use-package-compute-statistics t
	  debug-on-error t)
  (setq use-package-verbose nil
	use-package-expand-minimally t))

;(use-package use-package-ensure-system-package)
;(setq use-package-always-ensure t)
;(defun use-package-ensure-guix (name ensure-args state)
;(setq use-package-ensure-function 'use-package-ensure-guix)
;(use-package flycheck-elm)

;; (use-package fish-completion
;;   :ensure-system-package fish
;;   :config
;;   (global-fish-completion-mode))

;(use-package abbrev)

(use-package avy
  :custom
  ((avy-keys '(?d ?h ?o ?r ?i ?s ?e ?= ?a ?t ?1 ?n ?u))))

(use-package all-the-icons)

(use-package counsel
  :init
  (counsel-mode))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package dante
  :after haskell-mode
  :commands 'dante-mode
  :init
  (add-hook 'haskell-mode-hook 'flycheck-mode)
  ;; OR for flymake support:
  ;; (add-hook 'haskell-mode-hook 'flymake-mode)
  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
  (add-hook 'haskell-mode-hook 'dante-mode))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 11)))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-monokai-classic t)
  (doom-themes-visual-bell-config)
  ;(doom-themes-neotree-config)
  ;(setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  ;(doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package elm-mode
  :config
  (setq elm-package-json "elm.json")
  (setq elm-tags-regexps "/home/boring/.guix-profile/share/emacs/site-lisp/elm-tags.el")
  (setq elm-sort-imports-on-save t)
  (setq elm-tags-on-save t))

(use-package eshell-git-prompt
  :config
  (eshell-git-prompt-use-theme 'powerline))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  :config
  (evil-mode 1)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-translate-key
    '(motion normal visual)
    '(evil-motion-state-map
      magit-mode-map
      info-mode-map)
    "n" "j"
    "j" "h"
    "h" "n"
    "k" "p"
    "p" "k")
  (evil-collection-init))

(use-package general
  :after evil-collection
  :config
  (general-def global-map
    ;; Make ESC quit prompts
    "C-;"        'save-buffer
    "C-g"        'evil-normal-state
    "<escape>"   'keyboard-escape-quit
    "<f5>"       'eshell-toggle
    "<f6>"       'org-agenda
    "<f9>"       'find-file)
  (general-def
    :states      '(normal visual)
    "k"          'evil-paste-after
    "K"          'evil-paste-before
    "C-k"        'helm-show-kill-ring
    "M-k"        'counsel-evil-registers)
  (general-def
    :states      '(motion normal)
    ;:keymaps 'magit-mode-map
    "n"          'evil-next-visual-line
    "p"          'evil-previous-visual-line
    "j"          'evil-backward-char
    "h"          'evil-search-next
    "H"          'evil-search-previous
    "/"          'evil-avy-goto-word-1
    "?"          'evil-avy-goto-line
    "C-n"        'evil-avy-goto-line-below
    "C-p"        'evil-avy-goto-line-above)
  (general-def
    :states      '(insert visual emacs)
    "C-,"        'evil-delete-backward-char-and-join
    "C-."        'evil-delete-char
    "C-j"        'evil-complete-previous
    "C-l"        'evil-complete-next
    "M-n"        'evil-next-visual-line
    "M-p"        'evil-previous-visual-line
    "C-<return>" 'open-line)
  (general-create-definer boring/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (boring/leader-keys
    "SPC" '(evil-visual-line :which-key "visual line")
    "C-s" '(evil-avy-goto-word-1 :which-key "avy goto word")
    "p"  '(projectile-command-map :which-key "projectile")
    "g"  '(magit-status :which-key "magit status")
    "b"  '(projectile-switch-to-buffer :which-key "projectile buffers")
    "w"  '(writeroom-mode :which-key "toggle writeroom mode")
    "s"  '(:ignore t :which-key "sorting")
    "ss" '(sort-lines :which-key "sort lines")
    "sp" '(sort-paragraphs :which-key "sort paragraphs")
    "se" '(evil-ex-sort :which-key "evil ex sort")
    "t"  '(:ignore t :which-key "tabs/toggles")
    "t1" '(tab-bar-select-tab :which-key "select tab")
    "t2" '(tab-bar-select-tab :which-key "select tab")
    "t3" '(tab-bar-select-tab :which-key "select tab")
    "t4" '(tab-bar-select-tab :which-key "select tab")
    "tn" '(tab-bar-switch-to-next-tab :which-key "next tab")
    "tp" '(tab-bar-switch-to-prev-tab :which-key "previous tab")
    "tt" '(tab-bar-switch-to-recent-tab :which-key "recent tab")
    "tT" '(tab-bar-new-tab :which-key "new tab")
    "tx" '(tab-bar-close-tab :which-key "close tab")
    "tX" '(tab-bar-undo-close-tab :which-key "undo close tab")
    "tl" '(counsel-load-theme :which-key "choose theme")
    "ts" '(hydra-text-scale/body :which-key "scale text")))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("n" text-scale-increase "in")
  ("p" text-scale-decrease "out")
  ("RET" nil "finished" :exit t))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (setq ivy-use-virtual-buffers t)
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package keyfreq
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(use-package magit
  :ensure-system-package git
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :config
  (general-def
    :states '(normal visual)
    :keymaps 'magit-mode-map
    "n" 'evil-next-visual-line
    "j" 'evil-backward-char
    "p" 'evil-previous-visual-line
    "h" 'evil-search-next))

(use-package magit-popup
  :config
  (general-def magit-popup-mode-map
    "<f6>"       'magit-popup-quit
    "<f7>"       'magit-popup-quit))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

;; Org Mode Configuration ------------------------------------------------------

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  :custom
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
     (sequence "BOOK(b)" "TOREAD(n)" "|" "READ(d!)")))
  (org-ellipsis " ▾")
  (org-agenda-start-with-log-mode t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-agenda-diary-file "~/org/diary.org")
  (org-agenda-files '("~/org/"))
  (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode +1)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '("~/projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package solaire-mode
  ;; Ensure solaire-mode is running in all solaire-mode buffers
  :hook (change-major-mode . turn-on-solaire-mode)
  ;; ...if you use auto-revert-mode, this prevents solaire-mode from turning
  ;; itself off every time Emacs reverts the file
  :hook (after-revert . turn-on-solaire-mode)
  ;; To enable solaire-mode unconditionally for certain modes:
  :hook (ediff-prepare-buffer . solaire-mode)
  ;; Highlight the minibuffer when it is activated:
  ;;:hook (minibuffer-setup . solaire-mode-in-minibuffer)
  :config
  ;; The bright and dark background colors are automatically swapped the
  ;; first time solaire-mode is activated. Namely, the backgrounds of the
  ;; `default` and `solaire-default-face` faces are swapped. This is done
  ;; because the colors are usually the wrong way around. If you don't
  ;; want this, you can disable it:
  (setq solaire-mode-auto-swap-bg nil)
  (solaire-global-mode +1))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-show-early-on-C-h t)
  ;; make sure which-key doesn't show normally but refreshes quickly after it is
  ;; triggered.
  (setq which-key-idle-secondary-delay 0)
  (setq which-key-idle-delay 100))

(use-package writeroom-mode
  :diminish)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d74c5485d42ca4b7f3092e50db687600d0e16006d8fa335c69cf4f379dbd0eee" "71e5acf6053215f553036482f3340a5445aee364fb2e292c70d9175fb0cc8af7" "7b3d184d2955990e4df1162aeff6bfb4e1c3e822368f0359e15e2974235d9fa8" "79278310dd6cacf2d2f491063c4ab8b129fee2a498e4c25912ddaa6c3c5b621e" "82360e5f96244ce8cc6e765eeebe7788c2c5f3aeb96c1a765629c5c7937c0b5b" "1623aa627fecd5877246f48199b8e2856647c99c6acdab506173f9bb8b0a41ac" "711efe8b1233f2cf52f338fd7f15ce11c836d0b6240a18fffffc2cbd5bfe61b0" "37144b437478e4c235824f0e94afa740ee2c7d16952e69ac3c5ed4352209eefb" "7a994c16aa550678846e82edc8c9d6a7d39cc6564baaaacc305a3fdc0bd8725f" "7d708f0168f54b90fc91692811263c995bebb9f68b8b7525d0e2200da9bc903c" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "730a87ed3dc2bf318f3ea3626ce21fb054cd3a1471dcd59c81a4071df02cb601" "93ed23c504b202cf96ee591138b0012c295338f38046a1f3c14522d4a64d7308" "2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "b5fff23b86b3fd2dd2cc86aa3b27ee91513adaefeaa75adc8af35a45ffb6c499" "3c2f28c6ba2ad7373ea4c43f28fcf2eed14818ec9f0659b1c97d4e89c99e091e" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "dde8c620311ea241c0b490af8e6f570fdd3b941d7bc209e55cd87884eb733b0e" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "9efb2d10bfb38fe7cd4586afb3e644d082cbcdb7435f3d1e8dd9413cbe5e61fc" "cae81b048b8bccb7308cdcb4a91e085b3c959401e74a0f125e7c5b173b916bf9" "01cf34eca93938925143f402c2e6141f03abb341f27d1c2dba3d50af9357ce70" "5036346b7b232c57f76e8fb72a9c0558174f87760113546d3a9838130f1cdb74" "2899018e19d00bd73c10c4a3859967c57629c58a955a2576d307d9bdfa2fea35" "f7216d3573e1bd2a2b47a2331f368b45e7b5182ddbe396d02b964b1ea5c5dc27" "57bd93e7dc5fbb5d8d27697185b753f8563fe0db5db245592bab55a8680fdd8c" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "fe00bb593cb7b8c015bb2eafac5bfc82a9b63223fbc2c66eddc75c77ead7c7c1" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" "a3b6a3708c6692674196266aad1cb19188a6da7b4f961e1369a68f06577afa16" "f2927d7d87e8207fa9a0a003c0f222d45c948845de162c885bf6ad2a255babfd" "990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37" "8d7684de9abb5a770fbfd72a14506d6b4add9a7d30942c6285f020d41d76e0fa" default))
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   '(monkeytype abbrev org-bullets arduino-mode company-cabal dante geiser transient-dwim eshell-toggle eshell-git-prompt elm-mode speed-type guix avy evil-collection evil evil-goggles)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
