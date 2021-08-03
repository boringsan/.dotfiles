# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Use fish in place of bash
uname -a
[ -x /home/boring/.guix-profile/bin/fish ] && SHELL=/home/boring/.guix-profile/bin/fish exec fish
