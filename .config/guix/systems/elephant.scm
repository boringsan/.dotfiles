;; NOTE: This file is generated from ~/.dotfiles/System.org.  Please
  ;; see commentary there.

(define-module (elephant)
  #:use-module (base-system)
  #:use-module (guix transformations)
  #:use-module (gnu)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages gnome)
  #:use-module (gnu services desktop)
  #:use-module (gnu services linux)
  #:use-module (gnu services ssh)
  #:use-module (gnu services sddm)
  #:use-module (gnu services xorg)
  #:use-module (gnu services nix)
  #:use-module (nongnu system linux-initrd)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages nvidia))

(define transform
  (options->transformation
   '((with-graft . "mesa=nvda"))))

(operating-system
 (inherit base-operating-system)
 (host-name "elephant")

 ;; (kernel linux-lts)
 ;; (kernel-arguments (append
 ;;                    '("modprobe.blacklist=nouveau nvidia-drm.modeset=1")
 ;;                    %default-kernel-arguments))
 ;; (kernel-loadable-modules (list nvidia-driver))
 (initrd microcode-initrd)

 (keyboard-layout %desktop-keyboard)

 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets (list "/dev/sdd"))
   (theme (grub-theme
           (inherit (grub-theme))
           (gfxmode '("1920x1080" "1280x720" "auto"))))
   (keyboard-layout %desktop-keyboard)))

 (users
  (cons* (user-account
          (name "git")
          (group "users")
          (comment "Account for git acces")
          (home-directory "/mnt/ServerStore/git")
          (shell (file-append git "/bin/git-shell"))
          (system? #t))
         %boring-user
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
