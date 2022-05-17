(use-modules (gnu packages emacs-xyz)
             (guix transformations))

(define transform
  ;; The package transformation procedure.
  (options->transformation
   '((with-latest . "emacs-evil")
     (with-latest . "emacs-annalist")
     (with-latest . "emacs-list-utils")
     (with-latest . "emacs-lispy"))))


(concatenate-manifests
 (list

(specifications->manifest
 '("emacs"
   "emacs-all-the-icons"
   "emacs-all-the-icons-dired"
   "emacs-avy"
   "emacs-company"
   "emacs-consult"
   "emacs-corfu"
   "emacs-counsel"
   "emacs-counsel-projectile"
   "emacs-dash"
   "emacs-dashboard"
   "emacs-dired-hacks"
   "emacs-doom-modeline"
   "emacs-dumb-jump"
   "emacs-ediprolog"
   "emacs-eglot"
   "emacs-eldoc"
   "emacs-embark"
   "emacs-expand-region"
   "emacs-flycheck"
   "emacs-gcmh"
   "emacs-gdscript-mode"
   "emacs-geiser"
   "emacs-geiser-guile"
   "emacs-god-mode"
   "emacs-hydra"
   "emacs-ivy"
   "emacs-ivy-rich"
   "emacs-keyfreq"
   "emacs-lsp-ivy"
   "emacs-guix"
   "emacs-doom-themes"

   ;; "emacs-elm-mode"
   ;; "emacs-ess"
   ;; "emacs-flycheck-haskell"
   ;; "emacs-haskell-mode"
   ;; "emacs-lsp-mode"
   ;; "emacs-lsp-treemacs"
   ;; "emacs-lsp-ui"
   ;; "emacs-magit"
   ;; "emacs-org-roam"

   "emacs-map"
   "emacs-marginalia"
   "emacs-metal-mercury-mode"
   "emacs-mixed-pitch"
   "emacs-modus-themes"
   "emacs-orderless"
   "emacs-org"
   "emacs-org-appear"
   "emacs-org-bullets"
   "emacs-pdf-tools"
   "emacs-prescient"
   "emacs-project"
   "emacs-projectile"
   "emacs-rust-mode"
   "emacs-selectrum"
   "emacs-solaire-mode"
   "emacs-use-package"
   "emacs-vterm"
   "emacs-which-key"
   "emacs-writeroom"
   "emacs-xref"
   "emacs-yasnippet"))

  (packages->manifest
   (list (transform (specification->package "emacs-evil"))
         (transform (specification->package "emacs-evil-surround"))
         ;; (transform (specification->package "emacs-helpful"))
         ;; (transform (specification->package "emacs-evil-collection"))
         (transform (specification->package "emacs-general"))))))
