# Assumes that zsh-history-substring-search is being provided via homebrew/boxen
plugin="$(brew --prefix)/opt/rbenv/completions/rbenv.zsh"

if [ -f $plugin ]; then
  source $plugin
fi
