function mkopt() {
    mkdir --parents --verbose $@
}
mkopt ~/.local/bin
mkopt ~/.local/share/fonts
mkopt ~/.config/guix
mkopt ~/.config/nushell
mkopt ~/.emacs.d/
mkopt ~/.stack
mkopt ~/projects

cd $HOME/.dotfiles
# stow --verbose=2 --dir=$HOME/.dotfiles --target=$HOME
stow --verbose .
