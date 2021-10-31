;; NOTE: This file is generated from ~/.dotfiles/System.org.  Please see commentary there.

(define-module (sugar-glider)
  #:use-module (base-system)
  #:use-module (gnu)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(operating-system
 (inherit base-operating-system)
 (host-name "sugar-glider")

 ;; Use non-free Linux and firmware
 (kernel linux)
 (firmware (list linux-firmware))
 (initrd microcode-initrd)

 (mapped-devices
  (list (mapped-device
         (source (uuid "1a8cd693-c190-46b9-82a8-cfd1cc357cb0"))
         (target "crypthome")
         (type luks-device-mapping))))

 (file-systems (append
                (list (file-system
                       (device (file-system-label "GuixSD"))
                       (mount-point "/")
                       (flags '(no-atime))
                       (type "ext4"))
                      (file-system
                       (device (file-system-label "crypthome"))
                       (mount-point "/home")
                       (type "ext4")
                       (dependencies mapped-devices))
                      (file-system
                       (device (uuid "BC7D-5BD2" 'fat))
                       (mount-point "/boot/efi")
                       (type "vfat")))
                %base-file-systems)))
