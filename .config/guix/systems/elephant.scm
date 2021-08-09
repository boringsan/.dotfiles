;; NOTE: This file is generated from ~/.dotfiles/System.org.  Please
;; see commentary there.

(define-module (elephant)
  #:use-module (base-system)
  #:use-module (gnu))

;;(use-modules (base-system))
(operating-system
 (inherit base-operating-system)
 (host-name "elephant")

 (keyboard-layout (keyboard-layout "us" "colemak"
                                   #:options '("ctrl:swapcaps")))

 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (target "/dev/sdd")
   (keyboard-layout keyboard-layout)))

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
                       (type "ext4")))
                %base-file-systems)))
