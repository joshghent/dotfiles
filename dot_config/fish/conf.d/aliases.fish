alias .. 'cd ..'

# Git aliases
alias g 'git'
alias gs 'git status'
alias ga 'git add -A'
alias gc 'git commit'
alias gpo 'git push origin'
alias gp 'git push'
alias gpx 'git add -A && git commit -m "x" && git push origin'
alias gco 'git checkout'
alias gfo 'git fetch origin'
alias grbc 'git rebase --continue'
alias gcmsg 'git commit --message'
alias gcb 'git checkout -b'

# System commands
alias sudo 'sudo '
alias myip 'dig +short myip.opendns.com @resolver1.opendns.com'
alias localip 'ipconfig getifaddr en0'
alias flushdns 'dscacheutil -flushcache && killall -HUP mDNSResponder'
alias reload 'exec $SHELL -l'
alias scan 'nmap -sP 192.168.1.1/24'
alias findpi 'nmap -sP 192.168.0.0/24 | awk \'/^Nmap/{print}/B8:27:EB/{print}\''

# Applications
alias c 'codium .'
alias gensecret 'python -c "import secrets; print(secrets.token_hex(20))"'
alias python 'python3'
alias dc 'docker compose'
