source "/usr/local/opt/asdf/asdf.sh"

# Periodically check for zplug stuff to install. If we’ve never run the install, or
# it’s been a while then we need to do an install...
LAST_RUN_FILE="$HOME/.lastrun/asdf"
ONE_WEEK_IN_SECONDS=604800

if [[ ! -f $LAST_RUN_FILE || $(($(date +%s) - $(date -r $LAST_RUN_FILE +%s))) -gt $ONE_WEEK_IN_SECONDS ]]; then
	echo "Updating asdf plugins..."
	asdf plugin add erlang
	asdf plugin add elixir
	asdf plugin add nodejs
	asdf plugin add ruby
	asdf plugin add golang
	asdf plugin add postgres
	asdf plugin add python
	asdf plugin add redis
	asdf plugin update --all

	# Touch our last run file
	mkdir -p $(dirname $LAST_RUN_FILE) && touch $LAST_RUN_FILE
fi
