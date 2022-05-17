(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu services)
             (gnu packages)
             (gnu packages admin)
             (gnu packages shells)
             (guix packages)
             (srfi srfi-1)
             (srfi srfi-26)
             (ice-9 match)
             (guix gexp))

(define %packages-fonts
  (map (lambda (font-name)
         (specification->package (string-append "font-" font-name)))
       (list "abattis-cantarell"
             "adobe-source-code-pro"
             "adobe-source-sans-pro"
             "adobe-source-serif-pro"
             "iosevka"
             "iosevka-curly"
             "iosevka-curly-slab")))

(define %packages-shell
  (map specification->package
       (list "cowsay"
             "curl"
             "fortune-mod"
             "ispell"
             "lm-sensors"
             "myrepos"
             "nushell"
             "openssh"
             "pandoc"
             "ripgrep"
             "smartmontools"
             "stow"
             "unzip"
             "xdg-utils"
             "zstd")))

(define %packages-programming
  (map specification->package
       (list "alsa-lib"                 ; amethyst
             "cmake"
             "clang"
             "freetype"                 ; amethyst
             "gcc-toolchain"
             "ghostscript"
             "graphviz"
             "guile"
             "libx11"                   ; amethyst
             "libxcb"                   ; amethyst
             "libxcursor"               ; amethyst
             "libxi"                    ; amethyst
             "libxrandr"                ; amethyst
             "make"
             "mercury"
             "mesa"                     ; glium
             "openssl"                  ; amethyst
             "pkg-config"
             "python"
             "r"
             "r-igraph"
             "r-rgl"
             "rust"
             "rust-cargo"
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

(define %activate-profiles
  (string-join
   '(""
     "GUIX_EXTRA_PROFILES=\"$HOME/.guix-extra-profiles\""
     "for i in $GUIX_EXTRA_PROFILES/*; do"
     "     profile=$i/$(basename \"$i\")"
     "    if [ -f \"$profile\"/etc/profile ]; then"
     "        GUIX_PROFILE=\"$profile\""
     "        . \"$GUIX_PROFILE\"/etc/profile"
     "    fi"
     "    unset profile"
     "done")
   "\n" 'suffix))

(define %init-bashrc
  (string-join
   '(""
     "case \"$-\" in"
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
          %packages-programming
          %packages-fonts))
          ;; %packages-emacs))

 (services
  (list

   (simple-service 'home-shell-profile-extension
                   home-shell-profile-service-type
                   (list (plain-file "init-nix-environment" %init-nix-environment)
                         (plain-file "activate-extra-profiles" %activate-profiles)))

   (service home-bash-service-type
        (home-bash-configuration
         (bashrc
          (list (plain-file "init-bashrc" %init-bashrc)))))

   (simple-service 'additional-env-vars-service
           home-environment-variables-service-type
           `(("CC" . "gcc")
             ("GUIX_PACKAGE_PATH" . "$HOME/.config/guix/include")
             ("GUIX_EXTRA_PROFILES" . "$HOME/.guix-extra-profiles")
             ("LESS" . "\"--window=-3 --use-color --hilite-unread --status-column --raw-control-chars\"")
             ("PATH" . "$HOME/.cabal/bin:$HOME/.bin:$PATH")
             ("GUILE_EXTENSIONS_PATH" . "$HOME/.guix-profile/lib")
             ("EDITOR" . "emacsclient")
             ("VISUAL" . "emacsclient"))))))
