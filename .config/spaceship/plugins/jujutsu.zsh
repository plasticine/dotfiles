SPACESHIP_JUJUTSU_SHOW="${SPACESHIP_JUJUTSU_SHOW=true}"
SPACESHIP_JUJUTSU_ASYNC="${SPACESHIP_JUJUTSU_ASYNC=true}"
SPACESHIP_JUJUTSU_PREFIX="${SPACESHIP_JUJUTSU_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_JUJUTSU_SUFFIX="${SPACESHIP_JUJUTSU_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_JUJUTSU_SYMBOL="${SPACESHIP_JUJUTSU_SYMBOL=""}"
SPACESHIP_JUJUTSU_COLOR="${SPACESHIP_JUJUTSU_COLOR=""}"

spaceship_jujutsu() {
	[[ $SPACESHIP_JUJUTSU_SHOW == false ]] && return
	spaceship::exists jj || return

	local workspace
	workspace=$(jj workspace root 2> /dev/null) || return

	# Force jj to refresh status, without this stats can be out of whack...
	jj status --repository "$workspace" 2> /dev/null

	local content revision closest_bookmark closest_bookmark_distance
	closest_bookmark=$(jj log --repository "$workspace" --ignore-working-copy --no-graph --limit 1 --color always -r "closest_bookmark(@)" -T 'bookmarks.join(" ")' 2> /dev/null)
	closest_bookmark_distance=$(jj log --repository "$workspace" --ignore-working-copy --no-graph --color never -r "closest_bookmark(@)..@-" -T 'change_id ++ "\n"' 2> /dev/null | wc -l | tr -d ' ')
	file_status=$(jj log --repository "$workspace" --ignore-working-copy --no-graph --color never --revisions @ -T 'self.diff().files().map(|f| f.status()).join("\n")' 2> /dev/null |
		sort | uniq -c | awk '
		    /modified/ { parts[++i] = "%F{cyan}" $1 "M%f" }
		    /added/ { parts[++i] = "%F{green}" $1 "A%f" }
		    /removed/ { parts[++i] = "%F{red}" $1 "D%f" }
		    /copied/ { parts[++i] = "%F{yellow}" $1 "C%f" }
		    /renamed/ { parts[++i] = "%F{magenta}" $1 "R%f" }
		    END { for (j=1; j<=i; j++) printf "%s%s", parts[j], (j<i ? " " : "") }
	')
	revision=$(jj log --repository "$workspace" --ignore-working-copy --no-graph --limit 1 --color always --revisions @ -T "
		separate(
		    ' ',
		    if(git_head, label('git_head', hex('#8bd5ca', 'git head'))),
		    if(empty, label('empty', '(empty)'), ''),
		    if(immutable, label('conflict', '(immutable)'), ''),
		    if(divergent, label('conflict', '(divergent)'), ''),
		    if(conflict, label('conflict', '(conflict)'), ''),
		    if(description == '', label('description placeholder', '(no description set)'), ''),
		    dim(truncate_end(46, description.first_line(), '…')),

		    hex('#c6a0f6', bold(change_id.shortest(4).prefix())) ++ hex('#5b6078', change_id.shortest(4).rest()),
		    hex('#7dc4e4', bold(commit_id.shortest(8).prefix())) ++ hex('#5b6078', commit_id.shortest(6).rest()),

		    if(self.diff().stat().total_added() > 0, hex('#a6da95', '+') ++ hex('#a6da95', self.diff().stat().total_added())),
		    if(self.diff().stat().total_removed() > 0, hex('#ed8796', '-') ++ hex('#ed8796', self.diff().stat().total_removed())),
		) ++ ' '
	")

	# Build section output.
	content="${revision}${file_status}${closest_bookmark}+${closest_bookmark_distance}"

	# Sanitize output...
	content="$(sed 's/\x1b\[[0-9;]*m/%{&%}/g' <<< $content)"

	spaceship::section::v4 \
		--color "$SPACESHIP_JUJUTSU_COLOR" \
		--prefix "$SPACESHIP_JUJUTSU_PREFIX" \
		--suffix "$SPACESHIP_JUJUTSU_SUFFIX" \
		--symbol "$SPACESHIP_JUJUTSU_SYMBOL" \
		"$content"
}
