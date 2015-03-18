# Assumes that zsh-history-substring-search is being provided via homebrew/boxen
source `brew --prefix`/opt/zsh-history-substring-search/zsh-history-substring-search.zsh

# bind UP and DOWN arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
