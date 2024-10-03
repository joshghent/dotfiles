alias ..="cd .."

alias g="git"
alias gs="git status"
alias ga="git add -A"
alias gc="git commit"
alias gpo="git push origin"
alias gp="git push"
alias gpx="git add -A && git commit -m \"x\" && git push origin"
alias gco="git checkout"
alias gfo="git fetch origin"
alias grbc="git rebase --continue"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# IP addresses
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Flush Directory Service cache
alias flushdns="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Reload the shell (i.e. invoke as a login shell)
# shellcheck disable=SC2139
alias reload="exec $SHELL -l"

alias scan="nmap -sP 192.168.1.1/24"

# Finds a local raspberry pi
alias findpi="nmap -sP 192.168.0.0/24 | awk '/^Nmap/{print}/B8:27:EB/{print}'"

alias c="codium ."
alias cat="bat"
alias gensecret="ruby -rsecurerandom -e 'puts SecureRandom.hex(20)'"
alias python=python3
alias dc="docker compose"
