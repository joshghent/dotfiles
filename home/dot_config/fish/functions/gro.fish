function gro
    git fetch origin
    git rebase origin/$argv[1] $argv[1]
end
