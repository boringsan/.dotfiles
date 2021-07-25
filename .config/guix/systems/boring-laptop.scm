;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-modules (gnu packages shells))
(use-modules (gnu services web))
(use-service-modules desktop networking ssh xorg nix)


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
                   (udev-service-type config =>
                                      (udev-configuration (inherit config)
                                                          (rules (cons %backlight-udev-rule
                                                                       (udev-configuration-rules config)))))))

(operating-system
  (locale "en_US.utf8")
  (timezone "Europe/Ljubljana")
  (keyboard-layout (keyboard-layout "us" "colemak"
                                    #:options '("ctrl:swapcaps")))
  (locale-libcs (list glibc-2.29 (canonical-package glibc)))

  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (target "/dev/sda")
      (keyboard-layout keyboard-layout)))
  (swap-devices (list "/dev/sda1"))
  (file-systems
    (cons* (file-system
             (mount-point "/home")
             (device
               (uuid "85884235-38e7-48cd-a0b7-a64497b695eb"
                     'ext4))
             (type "ext4"))
           (file-system
             (mount-point "/")
             (device
               (uuid "c66206f8-9d45-457c-a3d2-095141bcc109"
                     'ext4))
             (type "ext4"))
           %base-file-systems))
  (host-name "boring-laptop")
  (users (cons* (user-account
                  (name "boring")
                  (comment "Boring")
                  (group "users")
                  (shell (file-append fish "/bin/fish"))
                  (home-directory "/home/boring")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service gnome-desktop-service-type)
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
      %my-desktop-services)))
