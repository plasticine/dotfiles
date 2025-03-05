# Configure PATH
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/Applications/Sublime Text.app/Contents/SharedSupport/bin" # Find subl

# Configure brew
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -f /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"

# Configure MANPATH
export MANPATH="/usr/local/man:$MANPATH"
export MANPATH="/usr/local/git/man:$MANPATH"
