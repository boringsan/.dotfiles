;; NOTE: This file is generated from ~/.dotfiles/System.org.  Please see commentary there.

(define-module (golden-retriever)
  #:use-module (base-system)
  #:use-module (gnu))

(operating-system
 (inherit base-operating-system)
 (host-name "golden-retriever")

 (keyboard-layout (keyboard-layout "us" "colemak"
                                   #:options '("ctrl:swapcaps")
                                   #:model "thinkpad"))
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets (list "/dev/sda"))
   (keyboard-layout keyboard-layout)))
 (swap-devices (list (swap-space
                      (target (uuid "c3da67eb-4e2c-4b5e-ac61-7f0f2f27f28b")))))
                      ;; (target (file-system-label "SlowSwap")))))
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
          (flags '(no-atime))
          (type "ext4"))
         %base-file-systems)))
