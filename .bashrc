# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Is this shell interactive?
case "$-" in
    *i*)
	# Use fish in place of bash
	fortune | cowsay -W 54
	uname -a
	SHELL=$(which nu)
	[ -x $SHELL ] && exec nu
esac
