
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[[ -s $(brew --prefix)/etc/autojump.sh ]] && . $(brew --prefix)/etc/autojump.sh

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

archey -c

alias ss="/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"

alias cd..="cd .."
# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

alias gh="open -a google\ chrome 'http://github.com/joshghent'"

# be nice
alias fuck='sudo $(history -p !!)'

# git
alias gc="!git add -A && git commit -m"
# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Undo a `git push`
alias undopush="git push -f origin HEAD^:master"

# File size
alias fs="stat -f \"%z bytes\""

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update'

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
	
# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 7'"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

alias header="curl -I"

alias wget="wget -c"

alias myip="curl http://ipecho.net/plain; echo"

alias ls='ls -G'

alias reload="source ~/.bash_profile"

alias grep="grep --color=auto"

md5check() { md5sum "$1" | grep "$2";}

alias c="clear"

alias histg="history | grep"

alias busy="cat /dev/urandom | hexdump -C | grep "ca"" 

alias marid="cd ~/Dropbox/Programming/marid-frontend && git up"

alias vimsync="rsync -a .vimrc ~/Dropbox/Programming/dotfiles/vimrc"

alias bashsync="rsync -a .bash_profile ~/Dropbox/Programming/dotfiles/bash_profile"

alias tmuxsync="rsync -a .tmux.conf ~/Dropbox/Programming/dotfiles/tmux.conf"

alias gpo="git push origin master"

alias serverme="python -m SimpleHTTPServer"
