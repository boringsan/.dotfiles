
function ll
    ls -lh $argv
end

function lf
    lsblk -f
end

function ip
    command ip --color=auto $argv
end

if status --is-login
    set -x PATH $PATH ~/.nix-profile/bin
end
