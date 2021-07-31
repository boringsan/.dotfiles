(setq inhibit-startup-message t)
(setq custom-file "~/.emacs.d/custom-set-variables.el")

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar
(tab-bar-mode)              ; Enable the tab bar
(show-paren-mode t)         ; Highlight matching parenthesis

(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-10"))

(column-number-mode)

(dolist (mode '(prog-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode t))))

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)        ; Initialize package sources
(unless package-archive-contents
  (package-refresh-contents))
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

(setq use-package-always-ensure t)

(use-package avy
  :custom
  ((avy-keys '(?d ?h ?o ?r ?i ?s ?e ?= ?a ?t ?1 ?n ?u))))

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
      org-mode-map
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
    "<f5>"       'org-capture
    "<f6>"       'org-agenda-list
    "<f9>"       'find-file)
  (general-def
    :states      '(normal visual)
    "k"          'evil-paste-after
    "K"          'evil-paste-before)
  (general-def
    :states      '(motion normal)
    "n"          'evil-next-visual-line
    "p"          'evil-previous-visual-line
    "j"          'evil-backward-char
    "h"          'evil-search-next
    "H"          'evil-search-previous
    "/"          'evil-avy-goto-word-1
    "?"          'evil-avy-goto-line)
  (general-def
    :states      '(insert visual emacs)
    "C-,"        'evil-delete-backward-char-and-join
    "C-."        'evil-delete-char
    "C-j"        'evil-complete-previous
    "C-l"        'evil-complete-next
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

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("n" text-scale-increase "in")
  ("p" text-scale-decrease "out")
  ("RET" nil "finished" :exit t))

(use-package haskell-mode
  :custom
  (haskell-mode-hook '(capitalized-words-mode
                       haskell-indent-mode
                       haskell-indentation-mode
                       dante-mode
                       flycheck-mode)))

(use-package dante
  :after haskell-mode
  :commands 'dante-mode
  :init
  ;(add-hook 'haskell-mode-hook 'flycheck-mode)
  ;; OR for flymake support:
  ;; (add-hook 'haskell-mode-hook 'flymake-mode)
  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
  (add-hook 'haskell-mode-hook 'dante-mode))

(use-package elm-mode
  :config
  (setq elm-package-json "elm.json")
  (setq elm-tags-regexps "/home/boring/.guix-profile/share/emacs/site-lisp/elm-tags.el")
  (setq elm-sort-imports-on-save t)
  (setq elm-tags-on-save t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 11)))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
                                        ;(load-theme 'doom-monokai-classic t)
  (load-theme 'doom-old-hope t)
  (doom-themes-visual-bell-config)
                                        ;(doom-themes-neotree-config)
                                        ;(setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
                                        ;(doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package eshell-git-prompt
  :config
  (eshell-git-prompt-use-theme 'powerline))

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

(use-package writeroom-mode
  :diminish)

(use-package counsel
  :init
  (counsel-mode))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

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
  (efs/org-font-setup)
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

  ;; Make sure org-indent face is available
  (require 'org-indent)

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
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((haskell . t)))
  :custom
  (org-ellipsis " ▾")
  (org-agenda-start-with-log-mode t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-agenda-diary-file "~/org/diary.org")
  (org-agenda-files '("~/org/")))

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

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-show-early-on-C-h t)
  ;; make sure which-key doesn't show normally but refreshes quickly after it is
  ;; triggered.
  (setq which-key-idle-secondary-delay 0)
  (setq which-key-idle-delay 100))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/org-roam")
  :config
  (org-roam-setup)
  :bind (("C-c n f"   . org-roam-node-find)
         ("C-c n n"   . org-roam-capture)
         ("C-c n c"   . org-roam-dailies-capture-today)
         ("C-c n C r" . org-roam-dailies-capture-tomorrow)
         ("C-c n d"   . org-roam-dailies-goto-date)
         ("C-c n t"   . org-roam-dailies-goto-today)
         ("C-c n y"   . org-roam-dailies-goto-yesterday)
         ("C-c n r"   . org-roam-dailies-goto-tomorrow)
         ("C-c n g"   . org-roam-graph)
         :map org-mode-map
         ("C-c n i"   . org-roam-node-insert)))
