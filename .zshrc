export ZSH="~/.oh-my-zsh"

ZSH_THEME="robbyrussell"

source ~/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

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

export PATH=~/.local/bin:$PATH

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY # share command history data
export PATH="/usr/local/sbin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# bun completions
[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export GITHUB_PACKAGES_TOKEN=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
