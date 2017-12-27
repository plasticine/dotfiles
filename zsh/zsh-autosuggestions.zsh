# Assumes that zsh-autosuggestions is being provided via homebrew/boxen
plugin="/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [ -f $plugin ]; then
  source $plugin

  ZSH_AUTOSUGGEST_USE_ASYNC="true"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=white"
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
else
  echo "WARNING: zsh-autosuggestions not found, skipping."
fi
