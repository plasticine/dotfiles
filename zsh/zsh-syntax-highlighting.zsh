# Assumes that zsh-syntax-highlighting is being provided via homebrew/boxen
plugin="/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if [ -f $plugin ]; then
  source $plugin
else
  echo "WARNING: zsh-syntax-highlighting not found, skipping."
fi
