# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
# https://vincent.bernat.ch/en/blog/2021-zsh-transient-prompt
# https://github.com/romkatv/powerlevel10k/issues/888
# https://robotmoon.com/zsh-prompt-generator/

DEFAULT_PROMPT="%{%F{8}%}%n%{%F{8}%}@%{%B%F{#f5a97f}%}%m%b %{%F{0}%}%~ %{%f%}"
DEFAULT_RPROMPT=""

start_command_timer() {
	cmd_start=$(($(print -P %D{%s%6.}) / 1000))
}

stop_command_timer() {
	if [ $cmd_start ]; then
		local now; now=$(($(print -P %D{%s%6.}) / 1000))
		local d_ms; d_ms=$(($now - $cmd_start))

		# We only really care about slowish commands...
		if [[ $d_ms -gt 200 ]]; then
			local d_s; d_s=$((d_ms / 1000))
			local ms; ms=$((d_ms % 1000))
			local s; s=$((d_s % 60))
			local m; m=$(((d_s / 60) % 60))
			local h; h=$((d_s / 3600))

			if ((h > 0)); then; cmd_time=${h}h${m}m
			elif ((m > 0)); then; cmd_time=${m}m${s}s
			elif ((s > 9)); then; cmd_time=${s}.$(printf %03d $ms | cut -c1-2)s # 12.34s
			elif ((s > 0)); then; cmd_time=${s}.$(printf %03d $ms)s # 1.234s
			else; cmd_time=${ms}ms
			fi
		fi

		unset cmd_start
	else
		# Clear previous result when hitting Return with no command to execute
		unset cmd_time
	fi
}

set_terminal_title() {
	if [[ $LC_TERMINAL = iTerm2 ]]; then
		print -P "\033]0; %3~ \007"
	fi
}

async_prompt() {
	prompt_complete() {
		RPROMPT="${RPROMPT}${3}"
		zle reset-prompt
		async_stop_worker prompt -n
	}

	async_init
	async_start_worker prompt -n
	async_register_callback prompt prompt_complete
	async_job prompt async_prompt_job
}

async_prompt_job() {
	# echo "$(git_prompt) $(k8s_prompt)"
	echo "$(git_prompt)"
}

build_prompt() {
	local last_command_exit="$?"

	NEWLINE=$'\n'
	WHITESPACE=$' '
	PROMPT="$DEFAULT_PROMPT"
	RPROMPT="$DEFAULT_RPROMPT"

	# Add a trailing space to `cmd_time` but only if it’s actually set...
	cmd_time=${cmd_time:+"${cmd_time} "}

	if [[ "x${last_command_exit:-}" != "x0" ]]; then
		ICON=$'%K{#ed8796}%F{#f0c6c6} \ueefe '"${last_command_exit} ${cmd_time}"$'%f%k%F{#ed8796}\ue0b0%f'
	else
		ICON=$'%K{0}%F{7} \ueefe '"${cmd_time}"$'%f%k%F{0}\ue0b0%f'
	fi

	PROMPT="${NEWLINE}${PROMPT}${NEWLINE}${ICON}${WHITESPACE}"

	set_terminal_title

	zle && zle reset-prompt
	async_prompt
}

preexec_functions+=(start_command_timer)
precmd_functions+=(stop_command_timer)
precmd_functions+=(build_prompt)
