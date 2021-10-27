(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu services)
             (gnu packages)
             (gnu packages admin)
             (gnu packages emacs)
             (gnu packages shells)
             (guix packages)
             (srfi srfi-1)
             (srfi srfi-26)
             (ice-9 match)
             (guix gexp))

(define %packages-fonts
  (map specification->package
       (list "font-abattis-cantarell"
             "font-adobe-source-code-pro"
             "font-adobe-source-sans-pro"
             "font-adobe-source-serif-pro"
             "font-iosevka"
             "font-iosevka-curly"
             "font-iosevka-curly-slab")))

(define %packages-emacs
  (map specification->package
       (list "emacs"
             "emacs-general"
             "emacs-counsel"
             "emacs-counsel-projectile"
             "emacs-ivy-rich"
             "emacs-keyfreq"
             ;;"emacs-mini-frame"
             "emacs-all-the-icons"
             "emacs-all-the-icons-dired"
             "emacs-doom-modeline"
             "emacs-doom-themes"
             "emacs-solaire-mode"
             "emacs-projectile"
             "emacs-lsp-mode"
             "emacs-lsp-ui"
             "emacs-lsp-ivy"
             "emacs-lsp-treemacs"
             ;;"emacs-lsp-haskell"
             "emacs-haskell-mode"
             "emacs-org-bullets"
             "emacs-org-appear"
             "emacs-org-roam"
             "emacs-dashboard"
             "emacs-avy"
             "emacs-consult"
             "emacs-ediprolog"
             "emacs-elm-mode"
             "emacs-embark"
             "emacs-ess"
             "emacs-evil"
             "emacs-evil-collection"
             "emacs-flycheck"
             "emacs-gcmh"
             "emacs-guix"
             "emacs-helpful"
             "emacs-hydra"
             "emacs-magit"
             "emacs-map"
             "emacs-marginalia"
             "emacs-mixed-pitch"
             "emacs-orderless"
             "emacs-pdf-tools"
             "emacs-prescient"
             "emacs-selectrum"
             "emacs-use-package"
             "emacs-vterm"
             "emacs-which-key"
             "emacs-writeroom"
             "emacs-yasnippet")))

(define %packages-shell
  (map specification->package
       (list "cowsay"
             "curl"
             "fortune-mod"
             "lm-sensors"
             "myrepos"
             "nushell"
             "openssh"
             "smartmontools"
             "stow"
             "unzip"
             "xdg-utils"
             "zstd")))

(define %packages-desktop
  (map specification->package
       (list "dconf-editor"
             "deluge"
             "gimp"
             "gnome-tweaks"
             "mpv"
             "ungoogled-chromium"
             "vlc")))

(define %packages-programming
  (map specification->package
       (list "gcc-toolchain"
             "ghostscript"
             "graphviz"
             "guile"
             "make"
             "python"
             "r"
             "r-igraph"
             "r-rgl"
             "swi-prolog"
             "texlive"
             "texlive-fonts-latex"
             "texlive-fourier"
             "texlive-latex-base"
             "texlive-mathdesign"
             "texlive-utopia")))

(define %init-nix-environment
  (string-join
   '(""
     "# Load Nix environment"
     "if [ -f /run/current-system/profile/etc/profile.d/nix.sh ]; then"
     "    . /run/current-system/profile/etc/profile.d/nix.sh"
     "fi")
   "\n" 'suffix))

(define %init-bashrc
  (string-join
   '("case \"$-\" in"
     "    *i*)"
     "	# Use nushell in place of bash"
     "	fortune | cowsay -W 54"
     "	uname -a"
     "	SHELL=$(which nu)"
     "	[ -x $SHELL ] && exec nu"
     "esac")
   "\n" 'suffix))

(home-environment

 (packages
  (append %packages-shell
      ;; %packages-desktop
      ;; %packages-programming
      %packages-fonts
      %packages-emacs))

 (services
  (list

   (service home-bash-service-type
        (home-bash-configuration
         (bash-profile
          (list (plain-file "init-nix-environment" %init-nix-environment)))
         (bashrc
          (list (plain-file "init-bashrc" %init-bashrc)))))

   (simple-service 'additional-env-vars-service
           home-environment-variables-service-type
           `(("CC" . "gcc")
             ("GUIX_PACKAGE_PATH" . "$HOME/.config/guix/include")
             ("LESS" . "\"--window=-3 --use-color --hilite-unread --status-column --raw-control-chars\"")
             ("PATH" . "$HOME/.cabal/bin:$HOME/.bin:$PATH")

             ;; This is not always respected :(
             ("EDITOR" . "emacsclient")
             ("VISUAL" . "emacsclient"))))))
