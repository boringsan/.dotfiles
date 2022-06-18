(use-modules
 (gnu home services shells)
 (gnu home services shepherd)
 (gnu home services)
 (gnu home)
 (gnu packages)
 (gnu services)
 ;; (gnu packages admin)
 ;; (gnu packages shells)
 ;; (gnu packages emacs)
 ;; (gnu home-services emacs)
 ;; (guix packages)
 ;; (srfi srfi-1)
 ;; (srfi srfi-26)
 ;; (ice-9 match)
 (guix gexp))

(define %font-packages
  (map (lambda (font-name)
         (specification->package (string-append "font-" font-name)))
       (list "abattis-cantarell"
             "adobe-source-code-pro"
             "adobe-source-sans-pro"
             "adobe-source-serif-pro"
             "fira-code"
             "fira-mono"
             "fira-sans"
             "google-roboto"
             "iosevka"
             "iosevka-curly"
             "iosevka-curly-slab")))

(define %shell-packages
  (map specification->package
       (list "shepherd"
             "nushell")))

(define %start-shepherd
  (string-join
   '("shepherd")
   "\n" 'suffix))

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
     "# Use nushell instead of bash, unless $SHELL is already nushell."
     ;; "echo $SHELL $SSH_CLIENT"
     ;; "if [ -n \"$SSH_CLIENT\" ] || [ -n \"$SSH_TTY\" ]; then"
     "if [[ $INSIDE_EMACS != \"tramp\" && $- == *i* && $SHELL != *nu ]]; then"
     ;; "  SHELL=$(which nu)"
     ;; "  [[ -x $SHELL ]] && exec nu || echo 'nu not found.'"
     "fi")
   "\n" 'suffix))

(home-environment
 (packages
  (append %shell-packages
          %font-packages))
 (services
  (list
   ;; (service home-shepherd-service-type)
   (service home-bash-service-type
            (home-bash-configuration
             (bashrc
              (list
               (plain-file "init-bashrc" %init-bashrc)))))
   (simple-service
    'additional-profiles
    home-shell-profile-service-type
    (list
     (plain-file "activate-extra-profiles" %activate-profiles)
     (plain-file "init-nix-environment" %init-nix-environment)))
   (simple-service
    'additional-env-vars-service
    home-environment-variables-service-type
    `(("CC" . "gcc")
      ("GUIX_PACKAGE_PATH" . "$HOME/.config/guix/include")
      ("GUIX_EXTRA_PROFILES" . "$HOME/.guix-extra-profiles")
      ("LESS" . "\"--window=-3 --use-color --hilite-unread --status-column --raw-control-chars\"")
      ("PATH" . "$HOME/.cabal/bin:$HOME/.local/bin:$PATH")
      ("GUILE_EXTENSIONS_PATH" . "$HOME/.guix-profile/lib")
      ("EDITOR" . "emacsclient")
      ("VISUAL" . "emacsclient"))))))
