export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2  # Should be loaded 2nd last.
zplug "zsh-users/zsh-history-substring-search", defer:3  # Should be loaded last.
zplug "zsh-users/zsh-autosuggestions"
zplug "chrissicool/zsh-256color", from:"github", use:"zsh-256color.plugin.zsh"
zplug "mafredri/zsh-async", defer:0
zplug load