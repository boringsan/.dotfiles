

(define %general-packages
  '("cowsay"
    "fortune-mod"
    "git"
    "git:send-email"
    "gnupg"
    "graphviz"
    "html-xml-utils"
    "htop"
    "lm-sensors"
    "make"
    "myrepos"
    "openssh"
    "pandoc"
    "pkg-config"
    "sicp"
    "smartmontools"
    "stow"
    "universal-ctags"
    "unzip"
    "watchexec"
    "xdg-utils"
    "xdg-utils"
    "zstd"))

(define %c-packages
  '("clang"
    "cmake"
    "gcc-toolchain"))

(define %tex-packages
  '("texlive"
    "texlive-cm"
    "texlive-fonts-ec"
    "texlive-fonts-latex"
    "texlive-fourier"
    "texlive-latex-base"
    "texlive-mathdesign"
    "texlive-utopia"))

(define %language-packages
  '("dune"
    "elm"
    "ghostscript"
    "guile"
    "mercury"
    "mono"
    "node"
    "ocaml"
    "ocaml-utop"
    "opam"
    "python"
    "r"
    "r-igraph"
    "r-rgl"
    "ruby-nokogiri"
    "ruby@2.7"
    "rust"
    ;; "rust-cargo"
    "swi-prolog"))

(specifications->manifest
 (append %c-packages
         %general-packages
         %language-packages
         %tex-packages))
