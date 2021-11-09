;; -*- lexical-binding: t -*-

(if init-file-debug
    (setq use-package-verbose t
          use-package-expand-minimally nil
          debug-on-error t)
  (setq use-package-verbose nil
        use-package-expand-minimally nil))

(setq use-package-always-ensure nil
      use-package-minimum-reported-time 0
      use-package-enable-imenu-support t
      use-package-compute-statistics t)

(use-package emacs
  :hook
  ((text-mode . (lambda ()
                  (mixed-pitch-mode)
                  (setq-local line-spacing 0.2)))
   (prog-mode . (lambda ()
                  (display-line-numbers-mode t)
                  (setq-local line-spacing 0.1)))
   (before-save . delete-trailing-whitespace))
  :custom
  (auto-window-vscroll nil)
  (column-number-mode t)                ; Show column number in the modeline
  (confirm-nonexistent-file-or-buffer nil)
  (global-auto-revert-non-file-buffers t) ; Revert Dired and other buffers
  (indent-tabs-mode nil)
  (inhibit-startup-screen t)
  (initial-scratch-message nil)
  (menu-bar-mode nil)                   ; Disable the menu bar
  (require-final-newline t)
  (scroll-bar-adjust-thumb-portion nil)
  (tool-bar-mode nil)                   ; Disable the toolbar
  (tooltip-mode nil)                    ; Disable tooltips
  (read-answer-short t)

  (custom-file "~/.emacs.d/custom-set-variables.el")
  (scroll-conservatively 10000)
  (scroll-step 1)
  (set-fringe-mode 16)                  ; Give some breathing room
  (tab-width 4)
  (completion-cycle-threshold 3)
  (tab-always-indent 'complete)
  (user-full-name "Erik Šabič")
  (user-mail-address "erik.sab@gmail.com")
  :custom-face
  (default ((t (:family "Iosevka Curly" :height 120))))
  (variable-pitch ((t (:family "Source Serif Pro" :height 130))))
  (fixed-pitch ((t (:inherit default))))
  :config
  (load custom-file)
  (show-paren-mode +1)
  (global-auto-revert-mode +1)          ; Revert buffers when the underlying file has changed
  (defvar boring/elephant-p (string-equal (system-name) "elephant"))

  ;; suggested by lsp-mode manual
  ;; (setq gc-cons-threshold 10000000)
  (setq read-process-output-max (* 1024 1024)) ; 1mb

  ;; server-mode
  (server-start)

  ;; TODO put this in the c mode use-package
  (setq-default c-basic-offset 4))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

(use-package gcmh
  :demand t
  :custom
  (gcmh-mode t))

(use-package flyspell
  :bind
  (:map flyspell-mode-map
        ("C-." . nil)
        ("C-," . nil))
  :hook
  (text-mode . flyspell-mode)) ; requires ispell installed

(use-package saveplace
  :defer t
  :custom
  (save-place-mode t))

(use-package savehist
  :defer t
  :custom
  (history-delete-duplicates t)
  (savehist-mode t))

(use-package package
  :disabled
  :defer t
  :config
  (setq package-archives
        '(("gnu" . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")
          ("melpa" . "https://melpa.org/packages/")
          ("orgmode" . "https://orgmode.org/elpa/")))

  (package-initialize)        ; Initialize package sources
  (unless package-archive-contents
    (package-refresh-contents)))

(use-package expand-region
  :bind ("M-," . er/expand-region))

;; previous value:
;; "/\\(\\(\\(COMMIT\\|NOTES\\|PULLREQ\\|MERGEREQ\\|TAG\\)_EDIT\\|MERGE_\\|\\)MSG\\|\\(BRANCH\\|EDIT\\)_DESCRIPTION\\)\\'"
(use-package recentf
  :custom
  (recentf-max-saved-items 256)
  (recentf-exclude '("/tmp/"
                     "/ssh:"
                     "/sudo:"
                     "recentf$"
                     "company-statistics-cache\\.el$"
                     ;; ctags
                     "/TAGS$"
                     ;; global
                     "/GTAGS$"
                     "/GRAGS$"
                     "/GPATH$"
                     ;; binary
                     "\\.mkv$"
                     "\\.mp[34]$"
                     "\\.avi$"
                     "\\.pdf$"
                     "\\.docx?$"
                     "\\.xlsx?$"
                     ;; sub-titles
                     "\\.sub$"
                     "\\.srt$"
                     "\\.ass$"
                     "personal/.*\\.org$"
                     ".emacs.d/elpa/.*\\.el$"
                     ".emacs.d/bookmarks$"
                     )))

(use-package keyfreq
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(use-package dashboard
  :config
  (setq dashboard-center-content t)
  (dashboard-setup-startup-hook))

(use-package yasnippet
  :init
  (yas-global-mode))

(use-package helpful
  :bind
  ([f1] . helpful-at-point)
  ([remap describe-function] . helpful-function)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key]      . helpful-key))

(use-package which-key
  :diminish which-key-mode
  :config
  ;; (setq which-key-show-early-on-C-h t)
  ;; (setq which-key-idle-delay 100)
  ;; (setq which-key-idle-secondary-delay 0.8)
  ;; does not work with evil operators :(
  ;; (setq which-key-show-operator-state-maps t)
  (setq which-key-sort-order 'which-key-local-then-key-order)
  (which-key-mode))

(use-package selectrum
  :init
  (use-package prescient
    :defer t)
  :config
  (selectrum-prescient-mode +1)
  (prescient-persist-mode +1)
  (setq selectrum-highlight-candidates-function #'orderless-highlight-matches)
  (selectrum-mode +1))

(use-package marginalia
  :config
  (marginalia-mode))

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c b" . consult-bookmark)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ([remap switch-to-buffer] . consult-buffer)
         ([remap switch-to-buffer-other-window] . consult-buffer-other-window)
         ([remap switch-to-buffer-other-frame] . consult-buffer-other-frame)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ([remap yank-pop] . consult-yank-pop)                ;; orig. yank-pop
         ([remap apropos-command] . consult-apropos)
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s F" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch)
         :map isearch-mode-map
         ("M-e" . consult-isearch)                 ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch)               ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi))           ;; needed by consult-line to detect isearch

  :init
  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Optionally replace `completing-read-multiple' with an enhanced version.
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-file consult--source-project-file consult--source-bookmark
   :preview-key (kbd "M-."))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; Optionally configure a function which returns the project root directory.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (project-roots)
  (setq consult-project-root-function
        (lambda ()
          (when-let (project (project-current))
            (car (project-roots project)))))
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-root-function #'projectile-project-root)
)

(use-package embark
  :bind
  (("C-," . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package orderless
  :after selectrum
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  ;; Optional performance optimization
  ;; by highlighting only the visible candidates.
  (orderless-skip-highlighting (lambda () selectrum-is-active)))

(use-package corfu
  ;; Optional customizations
  ;; :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-commit-predicate nil)   ;; Do not commit selected candidates on next input
  ;; (corfu-quit-at-boundary t)     ;; Automatically quit at word boundary
  ;; (corfu-quit-no-match t)        ;; Automatically quit if there is no match
  ;; (corfu-echo-documentation nil) ;; Do not show documentation in the echo area

  ;; Optionally use TAB for cycling, default is `corfu-complete'.
  ;; :bind (:map corfu-map
  ;;        ("TAB" . corfu-next)
  ;;        ([tab] . corfu-next)
  ;;        ("S-TAB" . corfu-previous)
  ;;        ([backtab] . corfu-previous))

  ;; You may want to enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since dabbrev can be used globally (M-/).
  :init
  (corfu-global-mode))

(use-package evil
  :custom
  (evil-want-keybinding nil)
  (evil-want-C-w-delete nil)
  (evil-wnat-fine-undo t)
  (evil-echo-state nil)
  :config
  (evil-mode 1)
  (evil-set-initial-state 'bufler-list-mode 'emacs)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :after evil
  :config
  (require 'which-key)
  (require 'outline)
  (general-translate-key nil
    '(evil-normal-state-map
      evil-motion-state-map
      evil-window-map
      outline-mode-map
      which-key-C-h-map)
    "n" "j"
    "j" "h"
    "h" "n"
    "H" "N"
    "p" "k"
    "P" "K"
    "k" "p"
    "C-k" "C-p"
    "C-p" "C-k")
  (general-def global-map
    "C-g"        'evil-normal-state
    "C-<tab>"    'other-frame
    "<escape>"   'keyboard-escape-quit
    "<f5>"       'org-capture
    "<f6>"       'org-agenda-list
    "<f9>"       'find-file)
  (general-def
    :states      'normal
    "C-;"        'save-buffer
    "k"          'evil-paste-after
    "K"          'evil-paste-before
    "C-k"        'evil-paste-pop
    "C-S-k"      'evil-paste-pop-next)
  (general-def
    :states      'motion
    "n"          'evil-next-visual-line
    "p"          'evil-previous-visual-line
    "j"          'evil-backward-char
    "N"          'evil-search-next
    "g b"        'bookmark-jump
    "P"          'evil-search-previous)
  (general-def
    :states      '(insert emacs)
    "C-n"        'evil-next-visual-line
    "C-p"        'evil-previous-visual-line)
  (general-def
    :states      '(insert visual emacs)
    "C-j"        'evil-complete-previous
    "C-l"        'evil-complete-next
    "C-<return>" 'open-line)
  (general-create-definer boring/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (boring/leader-keys
    "SPC" '(evil-visual-line :which-key "visual line")
    "t"  '(:ignore t :which-key "tabs/toggles")
    "s"  '(:ignore t :which-key "sorting")
    "ss" '(sort-lines :which-key "sort lines")
    "sp" '(sort-paragraphs :which-key "sort paragraphs")
    "se" '(evil-ex-sort :which-key "evil ex sort")))

(use-package consult
    :general
    (boring/leader-keys
      "tl" '(consult-theme :which-key "choose theme")))

(use-package avy
  :custom
  ((avy-keys '(?d ?h ?o ?r ?i ?s ?e ?k ?a ?t ?l ?n ?u)))
  :config
  (general-def
    :states 'motion
    "/"          'evil-avy-goto-word-1
    "?"          'evil-avy-goto-line))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("n" text-scale-increase "in")
  ("p" text-scale-decrease "out")
  ("RET" nil "finished" :exit t))

(boring/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package all-the-icons
  :if (display-graphic-p)
  :commands (all-the-icons-install-fonts)
  :custom
  (all-the-icons-scale-factor 1.0)
  :init
  (unless (find-font (font-spec :name "all-the-icons"))
    (all-the-icons-install-fonts t)))

(use-package all-the-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 24)
  (doom-modeline-hud t))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  ;; doom-Iosvkem doom-monokai-classic
  (if boring/elephant-p
      (load-theme 'doom-peacock)
    (load-theme 'doom-old-hope t))
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package writeroom-mode
  :diminish
  :defer t
  :commands (writeroom-mode)
  :general
  (boring/leader-keys
    "w"  '(writeroom-mode :which-key "toggle writeroom mode")))

(use-package magit
  :defer t
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

(use-package projectile
  :diminish projectile-mode
  :custom
  (projectile-project-search-path '("~/projects"))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :general
  (boring/leader-keys
    "p" '(projectile-command-map :which-key "Projectile"))
  :config
  (projectile-mode +1))

(use-package eglot
  :defer t)

(use-package eldoc
  :defer t
  :custom
  (eldoc-echo-area-use-multiline-p nil))

(use-package haskell-mode
  :defer t
  :custom
  (haskell-mode-hook '(capitalized-words-mode
                       ;; haskell-indent-mode
                       haskell-indentation-mode
                       interactive-haskell-mode))
  (haskell-process-type 'stack-ghci))

(use-package elm-mode
  :defer t
  :custom
  (elm-package-json "elm.json")
  (elm-sort-imports-on-save t)
  (elm-tags-on-save t)
  :config
  (setq elm-tags-regexps "/home/boring/.guix-profile/share/emacs/site-lisp/elm-tags.el"))

(use-package prolog-mode
  :defer t
  :init
  (setq prolog-system 'swi)  ; optional, the system you are using;
  (setq auto-mode-alist (append '(("\\.pl\\'" . prolog-mode)
                                  ("\\.m\\'" . mercury-mode))
                                auto-mode-alist)))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (visual-line-mode 1))

(defun boring/org-font-setup ()
  ;; Fontify the list hyphen and replace it with bullet
  (font-lock-add-keywords
   'org-mode
   '(("^ *\\([-]\\) "
      (0 (prog1 nil (compose-region (match-beginning 1)
                                    (match-end 1)
                                    "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((outline-1 . 1.3)
                  (outline-2 . 1.2)
                  (outline-3 . 1.13)
                  (outline-4 . 1.1)
                  (outline-5 . 1.1)
                  (outline-6 . 1.1)
                  (outline-7 . 1.1)
                  (outline-8 . 1.1)))
    (set-face-attribute (car face) nil
                        :weight 'bold
                        :height (cdr face)))

  ;; Make sure org-indent face is available
  (require 'org-indent))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :bind (:map org-mode-map
              ([tab] . org-cycle) ; to distinguish from C-i
              ("C-'" . nil) ; orig. org-cycle-agenda-files
              ("C-," . nil) ; orig. org-cycle-agenda-files
              )
  ;; http://ergoemacs.org/emacs/emacs_tabs_space_indentation_setup.html
  ;; (define-key org-mode-map (kbd "<tab>") #'org-cycle)
  :config
  (boring/org-font-setup)
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (general-translate-key 'normal 'outline-mode-map
    "C-n" "C-j"
    "C-p" "C-k"
    "M-j" "M-h"
    "M-n" "M-j"
    "M-p" "M-k")
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((haskell . t)))
  :custom
  (org-hide-emphasis-markers t)
  (org-ellipsis " ▾")
  (org-agenda-start-with-log-mode t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-agenda-diary-file "~/personal/diary.org")
  (org-agenda-files '("~/personal/")))

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

;; Show hidden emphasis markers
(use-package org-appear
  :hook (org-mode . org-appear-mode))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/org-roam")
  :config
  (org-roam-setup)
  ;; (org-roam-db-autosync-mode)
  :bind (:map org-mode-map
         ("C-c n i"   . org-roam-node-insert)))

(boring/leader-keys
  "n"     '(:ignore t :which-key "org-roam")
  "n f"   '(org-roam-node-find :which-key "find node")
  "n n"   '(org-roam-capture :which-key "capture node")
  "n c"   '(org-roam-dailies-capture-today :which-key "daily: capture today")
  "n C r" '(org-roam-dailies-capture-tomorrow :which-key "daily: capture tomorrow")
  "n d"   '(org-roam-dailies-goto-date :which-key "daily: goto data")
  "n t"   '(org-roam-dailies-goto-today :which-key "daily: goto today")
  "n y"   '(org-roam-dailies-goto-yesterday :which-key "daily: goto yesterday")
  "n r"   '(org-roam-dailies-goto-tomorrow :which-key "daily: goto tomorrow")
  "n g"   '(org-roam-graph :which-key "graph"))

(use-package dired
  :ensure nil
  ;; :straight nil
  :defer t
  :commands (dired dired-jump)
  :config
  (setq dired-listing-switches "-agho --group-directories-first"
        dired-omit-files "\\`[.]?#\\|\\`[.].*\\'"
        dired-omit-verbose nil
        dired-hide-details-hide-symlink-targets nil
        delete-by-moving-to-trash t)

  (autoload 'dired-omit-mode "dired-x")

  (add-hook 'dired-load-hook
            (lambda ()
              (interactive)
              (dired-collapse)))

  (add-hook 'dired-mode-hook
            (lambda ()
              (interactive)
              (dired-omit-mode 1)
              (dired-hide-details-mode 1)
              (s-equals? "/gnu/store/" (expand-file-name default-directory))
              (all-the-icons-dired-mode 1)
              (hl-line-mode 1)))

  (use-package dired-rainbow
    :defer 2
    :config
    (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
    (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
    (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
    (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
    (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    (dired-rainbow-define media "#de751f" ("mp3" "mp4" "mkv" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
    (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
    (dired-rainbow-define log "#c17d11" ("log"))
    (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
    (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
    (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
    (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
    (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
    (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
    (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
    (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
    (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))

  (use-package dired-ranger
    :defer t)

  (use-package dired-collapse
    :defer t)

  (use-package dired-hacks-utils
    :defer t)

  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-omit-mode
    "l" 'dired-single-buffer
    "y" 'dired-ranger-copy
    "X" 'dired-ranger-move
    "k" 'dired-ranger-paste))
