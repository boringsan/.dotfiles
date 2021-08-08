;; NOTE: This file is generated from ~/.dotfiles/System.org.  Please
;; see commentary there.

(define-module (elephant)
  #:use-module (base-system)
  #:use-module (gnu)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

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

 (mapped-devices
  (list (mapped-device
         (source (uuid "1a8cd693-c190-46b9-82a8-cfd1cc357cb0"))
         (target "crypthome")
         (type luks-device-mapping))))

 (file-systems (append
                (list (file-system
                       (device (file-system-label "GuixSD"))
                       (mount-point "/")
                       (type "ext4"))
                      (file-system
                       (device (file-system-label "crypthome"))
                       (mount-point "/home")
                       (type "ext4")
                       (dependencies mapped-devices)))
                %base-file-systems)))
