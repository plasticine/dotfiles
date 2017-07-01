export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$ZSH/bin:$PATH"

# local bin
export PATH="$PATH:.bin"

# local node_modules
export PATH="$PATH:./node_modules/.bin"

# iterm2 path
export PATH="$PATH:.iterm2"

# Setup nodenv and rbenv
eval "$(rbenv init -)"
eval "$(nodenv init -)"
