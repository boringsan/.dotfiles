
function ll
    ls -lh $argv
end

function lf
    lsblk -f
end

function ip
    command ip --color=auto $argv
end
