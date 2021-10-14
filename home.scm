(use-modules (gnu home)
             (gnu home-services)
             (gnu home-services shells)
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
      '("# Load Nix environment"
	"if [ -f /run/current-system/profile/etc/profile.d/nix.sh ]; then"
	"    . /run/current-system/profile/etc/profile.d/nix.sh"
	"fi"))
     (bashrc
      '("case \"$-\" in"
	"    *i*)"
	"	# Use nushell in place of bash"
	"	fortune | cowsay -W 54"
	"	uname -a"
	"	SHELL=$(which nu)"
	"	[ -x $SHELL ] && exec nu"
	"esac"))))
   (simple-service 'additional-env-vars-service
		   home-environment-variables-service-type
		   `(("PATH" . "$HOME/.cabal/bin:$HOME/.bin:$PATH")
		     ("GUIX_PACKAGE_PATH" . "$HOME/.config/guix/include")
		     ("LC_COLLATE" . "C")
		     ("CC" . "gcc")
		     ("VISUAL" . ,(file-append emacs "/bin/emacsclient"))
		     ("EDITOR" . "$VISUAL"))))))
