export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$ZSH/bin:$PATH"

# local cwd bin
export PATH="$PATH:.bin"

# local cwd node_module bin
export PATH="$PATH:./node_modules/.bin"

# iterm2 path
export PATH="$PATH:.iterm2"

# Go binary path
export PATH="$PATH:$HOME/go/bin"

# Setup nodenv and rbenv
eval "$(rbenv init -)"
eval "$(nodenv init -)"
