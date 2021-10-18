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

(home-environment
 (packages
  (map specification->package
       (list "cowsay"
	     "curl"
	     "dconf-editor"
	     "emacs"
	     "emacs-guix"
	     "emacs-pdf-tools"
	     "emacs-use-package"
	     "fortune-mod"
	     "gcc-toolchain"
	     "ghostscript"
	     "gimp"
	     "gnome-tweaks"
	     "graphviz"
	     "guile"
	     "htop"
	     "lm-sensors"
	     "mpv"
	     "myrepos"
	     "nushell"
	     "openssh"
	     "smartmontools"
	     "swi-prolog"
	     "ungoogled-chromium"
	     "unzip"
	     "vlc"
	     "xdg-utils")))

 (services
  (list
   (service
    home-bash-service-type
    (home-bash-configuration
     (bash-profile
      (list (plain-file "bash-profile"
		  (string-concatenate
		   '("\n# Load Nix environment\n"
		     "if [ -f /run/current-system/profile/etc/profile.d/nix.sh ]; then\n"
		     "    . /run/current-system/profile/etc/profile.d/nix.sh\n"
		     "fi\n")))))
     (bashrc
      (list (plain-file "he"
		  (string-concatenate
		   '("case \"$-\" in\n"
		     "    *i*)\n"
		     "	# Use nushell in place of bash\n"
		     "	fortune | cowsay -W 54\n"
		     "	uname -a\n"
		     "	SHELL=$(which nu)\n"
		     "	[ -x $SHELL ] && exec nu\n"
		     "esac\n")))))))
   (simple-service 'additional-env-vars-service
		   home-environment-variables-service-type
		   `(("CC" . "gcc")
		     ("GUIX_PACKAGE_PATH" . "$HOME/.config/guix/include")
		     ("LESS" . "\"--window=-3 --use-color --hilite-unread --status-column\"")
		     ("PATH" . "$HOME/.cabal/bin:$HOME/.bin:$PATH")

		     ;; This is not always respected :(
		     ("EDITOR" . "emacsclient")
		     ("VISUAL" . "emacsclient"))))))
