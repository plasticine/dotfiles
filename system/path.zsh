export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$ZSH/bin:$PATH"

# local cwd bin
export PATH="$PATH:.bin"

# local cwd node_module bin
export PATH="$PATH:./node_modules/.bin"

# iterm2 path
export PATH="$PATH:.iterm2"

# Stupid cask-installed GCP SDK bin path
export PATH="$PATH:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin"

# Android bulllllllllshit.
if [ -x /usr/libexec/java_home ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
  export PATH="$PATH:$JAVA_HOME/bin"
fi
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Go binary path
export PATH="$PATH:$HOME/go/bin"

# Setup nodenv and rbenv
eval "$(rbenv init -)"
eval "$(nodenv init -)"
