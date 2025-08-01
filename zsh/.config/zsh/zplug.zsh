export ZPLUG_HOME="$(brew --prefix zplug)"
source "$ZPLUG_HOME/init.zsh"

zplug "zsh-users/zsh-syntax-highlighting", defer:2      # Should be loaded 2nd last.
zplug "zsh-users/zsh-history-substring-search", defer:3 # Should be loaded last.
zplug "zsh-users/zsh-autosuggestions"
zplug "chrissicool/zsh-256color", from:"github", use:"zsh-256color.plugin.zsh"
zplug "mafredri/zsh-async", defer:0

# Periodically check for zplug stuff to install. If we’ve never run the install, or
# it’s been a while then we need to do an install...
ZPLUG_LAST_RUN_FILE="$HOME/.lastrun/zplug"
ONE_WEEK_IN_SECONDS=604800

if [[ ! -f $ZPLUG_LAST_RUN_FILE || $(($(date +%s) - $(date -r $ZPLUG_LAST_RUN_FILE +%s))) -gt $ONE_WEEK_IN_SECONDS ]]; then
	echo "Updating zplug plugins..."

	if ! zplug check; then
		zplug install
	fi

	# Touch our last run file
	mkdir -p $(dirname $ZPLUG_LAST_RUN_FILE) && touch $ZPLUG_LAST_RUN_FILE
fi

# Load everything!
zplug load
