(setq inhibit-startup-message t)
(setq custom-file "~/.emacs.d/custom-set-variables.el")
(load custom-file)

;;(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 16)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar
(show-paren-mode t)         ; Highlight matching parenthesis
(column-number-mode)        ; Show column number in the modeline

(defvar boring/elephant-p (string-equal (system-name) "elephant"))

(if boring/elephant-p
    (add-to-list 'default-frame-alist
                 '(font .  "CaskaydiaCove NF-12"))
  (add-to-list 'default-frame-alist
               '(font .  "DejaVu Sans Mono-10")))

(dolist (mode '(prog-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode t))))

;; suggested by lsp-mode manual
(setq gc-cons-threshold 10000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; server-mode
(server-start)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(setq tab-width 4)
(setq-default c-basic-offset 4)

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
          debug-on-error t)
  (setq use-package-verbose nil
        use-package-expand-minimally t))

(setq use-package-always-ensure t
      use-package-compute-statistics t)

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
                     ;; ~/.emacs.d/**/*.el included
                     ;; "/home/[a-z]\+/\\.[a-df-z]" ; configuration file should not be excluded
                     (expand-file-name "~/personal/*")
                     (expand-file-name "~/.emacs.d/elpa/*.el")
                     )))

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-center-content t)
  (dashboard-setup-startup-hook))

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
  (general-translate-key nil
    '(evil-normal-state-map
      evil-motion-state-map
      evil-window-map
      which-key-C-h-map)
    "n" "j"
    "j" "h"
    "h" "n"
    "H" "N"
    "p" "k"
    "P" "K"
    "k" "p")
  (general-def global-map
    "C-;"        'save-buffer
    "C-g"        'evil-normal-state
    "C-<tab>"    'other-frame
    "<escape>"   'keyboard-escape-quit
    "<f5>"       'org-capture
    "<f6>"       'org-agenda-list
    "<f9>"       'find-file)
  (general-def
    :states      'normal
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
    "p"  '(projectile-command-map :which-key "projectile")
    "g"  '(magit-status :which-key "magit status")
    "b"  '(projectile-switch-to-buffer :which-key "projectile buffers")
    "s"  '(:ignore t :which-key "sorting")
    "ss" '(sort-lines :which-key "sort lines")
    "sp" '(sort-paragraphs :which-key "sort paragraphs")
    "se" '(evil-ex-sort :which-key "evil ex sort")
    "t"  '(:ignore t :which-key "tabs/toggles")
    "tl" '(counsel-load-theme :which-key "choose theme")))

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

(use-package counsel
  :init
  (counsel-mode))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         :map ivy-switch-buffer-map
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

(use-package yasnippet
  :config
  (yas-global-mode))

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command]  . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
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

(use-package all-the-icons
  :if (display-graphic-p)
  :commands (all-the-icons-install-fonts)
  :init
  (unless (find-font (font-spec :name "all-the-icons"))
    (all-the-icons-install-fonts t)))

(use-package all-the-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 11)))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  ;;(load-theme 'doom-monokai-classic t)
  (if boring/elephant-p
      (load-theme 'doom-Iosvkem)
    (load-theme 'doom-old-hope t))
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

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

(boring/leader-keys
  "w"  '(writeroom-mode :which-key "toggle writeroom mode"))

(use-package writeroom-mode
  :diminish
  :commands (writeroom-mode))

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

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  (use-package company)
  :hook ((haskell-mode . lsp-deffered)
         (interactive-haskell-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration)))
  ;; :config
  ;; (lsp-enable-which-key-integration t))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package lsp-haskell)

(use-package haskell-mode
  ;; :hook ((haskell-mode . lsp-deferred)
  ;;        (interactive-haskell-mode . lsp-deferred))
  :custom
  ((haskell-mode-hook '(capitalized-words-mode
                        ;; haskell-indent-mode
                        haskell-indentation-mode
                        interactive-haskell-mode
                        flycheck-mode))
   (haskell-process-type 'stack-ghci)))

(use-package elm-mode
  :config
  (setq elm-package-json "elm.json")
  (setq elm-tags-regexps "/home/boring/.guix-profile/share/emacs/site-lisp/elm-tags.el")
  (setq elm-sort-imports-on-save t)
  (setq elm-tags-on-save t))

(defun efs/org-mode-setup ()
  (efs/org-font-setup)
  (org-indent-mode)
  ;; (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords
   'org-mode
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
    (set-face-attribute (car face) nil
                        :font "Cantarell"
                        :weight 'regular
                        :height (cdr face)))

  ;; Make sure org-indent face is available
  (require 'org-indent)

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'fixed-pitch nil
                      :font "CaskaydiaCove NF-12")
  (set-face-attribute 'org-block nil
                      :foreground nil
                      :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil
                      :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil
                      :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil
                      :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil
                      :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil
                      :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil
                      :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
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

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/org-roam")
  :config
  (org-roam-setup)
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
  :defer 1
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

  (use-package dired-single
    :defer t)

  (use-package dired-ranger
    :defer t)

  (use-package dired-collapse
    :defer t)

  (use-package dired-hacks-utils
    :defer t)

  (evil-collection-define-key 'normal 'dired-mode-map
    (kbd "DEL") 'dired-single-up-directory
    "h" 'dired-single-up-directory
    "H" 'dired-omit-mode
    "l" 'dired-single-buffer
    "y" 'dired-ranger-copy
    "X" 'dired-ranger-move
    "k" 'dired-ranger-paste))
