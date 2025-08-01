export JJ_CONFIG="$HOME/.config/jj/config.toml"

autoload -U compinit
compinit
source <(jj util completion zsh)
