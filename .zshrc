source ~/antigen.zsh
export ZSH="~/.oh-my-zsh"

# ANTIGEN  ===========================
antigen use oh-my-zsh

antigen bundle git

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle qoomon/zsh-lazyload
antigen bundle jgogstad/passwordless-history
antigen bundle agkozak/zsh-z

antigen bundle mafredri/zsh-async@main
antigen bundle sindresorhus/pure@main
antigen apply

zstyle :prompt:pure:path color 14
zstyle :prompt:pure:git:branch color 13
# Make it so it shows command execution time if it took over a second
PURE_CMD_MAX_EXEC_TIME=1

source ~/.aliases
source ~/.functions

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.zsh_history

setopt EXTENDED_HISTORY
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Dont write duplicate entries in the history file.

setopt SHARE_HISTORY # share command history data
export PATH="~/.local/bin:/usr/local/sbin:$HOME/.cargo/env:$HOME/.docker/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
