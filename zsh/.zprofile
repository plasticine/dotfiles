# Configure hombrew
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -f /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"

# Configure mise for non-weirdos...
command -v mise && eval "$(mise activate zsh --shims)"

# Work does a dumb thing where they manage mise in a weird opinionated way.
[[ -f $HOME/.local/bin/mise ]] && eval "$($HOME/.local/bin/mise activate zsh)"
