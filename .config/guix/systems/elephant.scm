;; NOTE: This file is generated from ~/.dotfiles/System.org.  Please
;; see commentary there.

(define-module (elephant)
  #:use-module (base-system)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages xorg)
  #:use-module (gnu services certbot)
  #:use-module (gnu services desktop)
  #:use-module (gnu services linux)
  #:use-module (gnu services nix)
  #:use-module (gnu services sddm)
  #:use-module (gnu services ssh)
  #:use-module (gnu services version-control)
  #:use-module (gnu services web)
  #:use-module (gnu services xorg)
  #:use-module (gnu)
  #:use-module (guix transformations))
  ;; #:use-module (nongnu packages linux)
  ;; #:use-module (nongnu packages nvidia)
  ;; #:use-module (nongnu system linux-initrd))

;; (define transform
;;   (options->transformation
;;    '((with-graft . "mesa=nvda"))))

(define %nginx-deploy-hook
  (program-file
   "nginx-deploy-hook"
   #~(let ((pid (call-with-input-file "/var/run/nginx/pid" read)))
       (kill pid SIGHUP))))

(operating-system
 (inherit base-operating-system)
 (host-name "elephant")

 ;; (kernel linux-lts)
 ;; (kernel-arguments (append
 ;;                    '("modprobe.blacklist=nouveau nvidia-drm.modeset=1")
 ;;                    %default-kernel-arguments))
 ;; (kernel-loadable-modules (list nvidia-driver))
 ;; (initrd microcode-initrd)

 (keyboard-layout %desktop-keyboard)

 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets (list "/dev/sdd"))
   (theme (grub-theme
           (inherit (grub-theme))
           (gfxmode '("1280x720" "auto"))))
   (keyboard-layout %desktop-keyboard)))

 (users
  (cons* %boring-user
         %base-user-accounts))

 (swap-devices (list (swap-space
                      (target (file-system-label "SlowSwap")))))

 (file-systems (append
                (list (file-system
                       (device (file-system-label "GuixSD"))
                       (mount-point "/")
                       (flags '(no-atime))
                       (type "ext4"))
                      (file-system
                       (device (file-system-label "Home"))
                       (mount-point "/home")
                       (type "ext4"))
                      (file-system
                       (device (file-system-label "MainStorage"))
                       (mount-point "/mnt/MainStorage")
                       (type "ext4"))
                      (file-system
                       (device (file-system-label "ServerStore"))
                       (mount-point "/mnt/ServerStore")
                       (type "ext4")))
                %base-file-systems))

 (services
  (append
   (list (service gnome-desktop-service-type)
         ;; (simple-service
         ;;  'custom-udev-rules udev-service-type
         ;;  (list nvidia-driver))
         ;; (service kernel-module-loader-service-type
         ;;          '("ipmi_devintf"
         ;;            "nvidia"
         ;;            "nvidia_modeset"
         ;;            "nvidia_uvm"))
         (service nix-service-type)
         (service sddm-service-type
                  (sddm-configuration
                   (display-server "wayland")
                   (theme "guix-simplyblack-sddm")
                   (xorg-configuration
                    (xorg-configuration
                     ;; (modules (cons* nvidia-driver %default-xorg-modules))
                     ;; (server (transform xorg-server))
                     ;; (drivers '("nvidia"))
                     (keyboard-layout %desktop-keyboard)))))
         (service gitolite-service-type
                  (gitolite-configuration
                   (admin-pubkey (plain-file
                                  "elephant.pub"
                                  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDObV2ZTrbMO5nk1UOPXV4IZ7j/ghfvNGPOx37yGP125/QayHxejMMmhbpB+X/une82I0HJX0cdVfMhSa+q0Cm+V+stSY82+Nc9NSNerUXEBaS/V/hdb4ADcs65iEIAWfgR87qcAKp6OxZWpNaylCq6ydEjmljcTS5rmTDcIB0GtEAU9EkzQHnFhVHcDqm68KD4UAOeU/fDelb8sL0Eg78ARQ0s5s99Ma3Z3RW/9E30wBA61aTAhbXrKtpEPU3HXI4ZoVhF9zELYUr/MHCm2icCXg4qYxjkeuR9m49lhJt+do/UPtK+eC2HJMvoUj5T16qnTwYgdpwWKRm1OrEehG3Y4dtv4hLxUB6gbLmRj4ktXnavhaZSIZOOHrtLBL4hOIwBoqm5pt95HFThZV+nDJ0FGo4PXz+gKt4YG5m2/QwcIm8m71rsgE91b+wbLXoTuRVBcyXaXqO7D8jkAXGZNVB+1jUVWD2o4YnRgXEP9I0JzZV8n2sTqYYwvtcG+5ohg2s= boring@elephant"))
                   (home-directory "/mnt/ServerStore/git")))
         (service certbot-service-type
                  (certbot-configuration
                   (email "erik.sab@gmail.com")
                   (certificates
                    (list
                     (certificate-configuration
                      (domains '("boring.si"
                                 "t.boring.si"
                                 "s.boring.si"
                                 "cpp.boring.si"))
                      (deploy-hook %nginx-deploy-hook))))))
         (service nginx-service-type
                  (nginx-configuration
                   (extra-content "ssl_session_cache shared:SSL:10m; ssl_session_timeout 10m;")
                   (server-blocks
                    (list (nginx-server-configuration
                           (server-name '("boring.si"))
                           (listen '("443 ssl"))
                           (root "/srv/http/boring.si")
                           (raw-content '("keepalive_timeout 70;"))
                           (ssl-certificate
                            "/etc/letsencrypt/live/boring.si/fullchain.pem")
                           (ssl-certificate-key
                            "/etc/letsencrypt/live/boring.si/privkey.pem"))
                          (nginx-server-configuration
                           (server-name '("cpp.boring.si"))
                           (listen '("443 ssl"))
                           (root "/srv/http/cpp.boring.si")
                           (raw-content '("keepalive_timeout 70;"))
                           (ssl-certificate
                            "/etc/letsencrypt/live/boring.si/fullchain.pem")
                           (ssl-certificate-key
                            "/etc/letsencrypt/live/boring.si/privkey.pem"))))))
         (service openssh-service-type
                  (openssh-configuration
                   (password-authentication? #f)
                   (subsystems
                    `(("sftp" ,(file-append openssh "/libexec/sftp-server")))))))
   (modify-services
    %desktop-services
    (delete gdm-service-type)
    (guix-service-type
     config => (guix-configuration
                (inherit config)
                (substitute-urls
                 (append (list "https://substitutes.nonguix.org")
                         %default-substitute-urls))
                (authorized-keys
                 (append (list (local-file "./nonguix.pub"))
                         %default-authorized-guix-keys))))))))
