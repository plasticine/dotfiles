# Assumes that zsh-autosuggestions is being provided via homebrew/boxen
plugin="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [ -f $plugin ]; then
  source $plugin
else
  echo "WARNING: zsh-autosuggestions not found, skipping."
fi
