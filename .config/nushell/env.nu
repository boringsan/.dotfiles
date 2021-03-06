# Nushell Environment Config File
let-env STARSHIP_SHELL = "nu"
let-env PROMPT_MULTILINE_INDICATOR = (^starship prompt --continuation)

def vterm_printf [s: string] { printf "\e]%s\e\\" $s }

def clear [] {
  vterm_printf "51;Evterm-clear-scrollback"
}
def vterm_prompt_end [] {
  vterm_printf $'51;A(whoami)@(hostname):(pwd)'
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = {
  starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
  # vterm_prompt_end
}
let-env PROMPT_COMMAND_RIGHT = {
  ^echo -ne $'\033]0;(pwd)\007'
}

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { vterm_prompt_end | str replace "\n" "" -a }
let-env PROMPT_INDICATOR_VI_INSERT = { ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = { "〉" }
let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | prepend '/some/path')

alias ll = ls --long
alias la = ls -a
def df [] {sys | get disks | select mount total free}
def "guix package -I" [] {^guix package -I | from tsv -n | rename name version output path}
def mkcd [dir: string] {mkdir $dir; cd $dir}
def ed [file: path] { emacsclient -n $file }
def lessgz [file: path] { gunzip -c $file | less }
