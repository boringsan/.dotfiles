# Set environment variables
export PATH="$HOME/.bin:$PATH"
export GUIX_PACKAGE_PATH="$HOME/.config/guix/include"

# Load the default Guix profile
GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE"/etc/profile

# Load Nix environment
if [ -f /run/current-system/profile/etc/profile.d/nix.sh ]; then
  . /run/current-system/profile/etc/profile.d/nix.sh
fi

# Export the path to IcedTea so that tools pick it up correctly
# export JAVA_HOME=$(dirname $(dirname $(readlink $(which java))))

# Make sure we can reach the GPG agent for SSH auth
# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Make sure `ls` collates dotfiles first (for dired)
export LC_COLLATE="C"

# Many build scripts expect CC to contain the compiler command
export CC="gcc"

# We're in Emacs, yo
export VISUAL=emacsclient
export EDITOR="$VISUAL"

