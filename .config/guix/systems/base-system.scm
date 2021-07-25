;; NOTE: This file is generated from ~/.dotfiles/System.org.  Please see commentary there.

(define-module (base-system)
  #:use-module (gnu)
  #:use-module (srfi srfi-1)
  #:use-module (gnu system nss)
  #:use-module (gnu services pm)
  #:use-module (gnu services cups)
  #:use-module (gnu services desktop)
  #:use-module (gnu services docker)
  #:use-module (gnu services networking)
  #:use-module (gnu services virtualization)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages file-systems)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages mtools)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages web-browsers)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages package-management)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(use-service-modules nix)
(use-service-modules desktop xorg)
(use-package-modules certs)
(use-package-modules shells)

;; Allow members of the "video" group to change the screen brightness.
(define %backlight-udev-rule
  (udev-rule
   "90-backlight.rules"
   (string-append "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
                  "RUN+=\"/run/current-system/profile/bin/chgrp video /sys/class/backlight/%k/brightness\""
                  "\n"
                  "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
                  "RUN+=\"/run/current-system/profile/bin/chmod g+w /sys/class/backlight/%k/brightness\"")))

(define %my-desktop-services
  (modify-services %desktop-services
                   (elogind-service-type config =>
                                         (elogind-configuration (inherit config)
                                                                (handle-lid-switch-external-power 'suspend)))
                   (udev-service-type config =>
                                      (udev-configuration (inherit config)
                                                          (rules (cons %backlight-udev-rule
                                                                       (udev-configuration-rules config)))))
                   (network-manager-service-type config =>
                                                 (network-manager-configuration (inherit config)
                                                                                (vpn-plugins (list network-manager-openvpn))))))

(define %xorg-libinput-config
  "Section \"InputClass\"
  Identifier \"Touchpads\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsTouchpad \"on\"

  Option \"Tapping\" \"on\"
  Option \"TappingDrag\" \"on\"
  Option \"DisableWhileTyping\" \"on\"
  Option \"MiddleEmulation\" \"on\"
  Option \"ScrollMethod\" \"twofinger\"
EndSection
Section \"InputClass\"
  Identifier \"Keyboards\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsKeyboard \"on\"
EndSection
")

(define-public base-operating-system
  (operating-system
    (host-name "hackstock")
    (timezone "Europe/Ljubljana")
    (locale "en_US.utf8")
    ;;(locale-libcs (list glibc-2.29 (canonical-package glibc)))

    (keyboard-layout (keyboard-layout "us" "colemak"
                     #:options '("ctrl:swapcaps")
                     #:model "thinkpad"))

    ;; Use the UEFI variant of GRUB with the EFI System
    ;; Partition mounted on /boot/efi.
    (bootloader
     (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))

    ;; Guix doesn't like it when there isn't a file-systems
    ;; entry, so add one that is meant to be overridden
    (file-systems
     (cons*
      (file-system
       (mount-point "/tmp")
       (device "none")
       (type "tmpfs")
       (check? #f))
      %base-file-systems))

    (users
     (cons* (user-account
             (name "boring")
             (comment "Boring")
             (group "users")
             (shell (file-append fish "/bin/fish"))
             (home-directory "/home/boring")
             (supplementary-groups
              '("wheel" "netdev" "audio" "video" "input")))
            %base-user-accounts))

    ;; Add the 'realtime' group
    ;; (groups (cons (user-group (system? #t) (name "realtime"))
    ;;              %base-groups))

    ;; Install bare-minimum system packages
    (packages
     (append (list
              git
              ntfs-3g
              exfat-utils
              fuse-exfat
              stow
              vim
              emacs
              xf86-input-libinput
              nss-certs     ;; for HTTPS access
              gvfs)         ;; for user mounts
             %base-packages))

    ;; Use the "desktop" services, which include the X11 log-in service,
    ;; networking with NetworkManager, and more
    (services
     (append
      (list (service gnome-desktop-service-type)
            (bluetooth-service #:auto-enable? #t)
            (service nix-service-type)
            (set-xorg-configuration
             (xorg-configuration
              (keyboard-layout keyboard-layout))))
          ;; (service nginx-service-type
          ;;          (nginx-configuration
          ;;           (server-blocks
          ;;            (list (nginx-server-configuration
          ;;                   (listen '("80"))
          ;;                   (server-name '("laptop.boring.si"))
          ;;                   (root "/srv/http/laptop.boring.si")
          ;; 		      (try-files (list "$uri" "/index.html"))
          ;;                   (locations
          ;;                    (list (nginx-location-configuration
          ;;                           (uri "/")
          ;;                           (body '("try_files $uri /index.html;" "autoindex on;")))))))))))
      %my-desktop-services))
    ;; Allow resolution of '.local' host names with mDNS
    (name-service-switch %mdns-host-lookup-nss)))
