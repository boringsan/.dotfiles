;; NOTE: This file is generated from ~/.dotfiles/System.org.  Please
;; see commentary there.

(define-module (elephant)
  #:use-module (base-system)
  #:use-module (gnu)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages ssh)
  #:use-module (gnu services desktop)
  #:use-module (gnu services ssh)
  #:use-module (gnu services xorg)
  #:use-module (gnu services nix))

;;(use-modules (base-system))
(operating-system
 (inherit base-operating-system)
 (host-name "elephant")

 (keyboard-layout %desktop-keyboard)

 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (target "/dev/sdd")
   (keyboard-layout keyboard-layout)))

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

 (swap-devices (list "/dev/sda2"))

 (file-systems (append
                (list (file-system
                       (device (file-system-label "GuixSD"))
                       (mount-point "/")
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
         (service nix-service-type)
         (set-xorg-configuration
          (xorg-configuration
           (keyboard-layout %desktop-keyboard)))
         (service openssh-service-type
                  (openssh-configuration
                   (password-authentication? #f)
                   (subsystems
                    `(("sftp" ,(file-append openssh "/libexec/sftp-server")))))))
   %desktop-services)))
