# # https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
# DEFAULT_PROMPT="%f%B%F{yellow}%M%f%b${SSH_NOTICE}%F{white} %3~%f "
# DEFAULT_RPROMPT=""

# set_terminal_title() {
# 	if [[ $LC_TERMINAL = iTerm2 ]]; then
# 		print -P "\033]0; %3~ \007"
# 	fi
# }

# async_prompt() {
# 	prompt_complete() {
# 		RPROMPT="${RPROMPT}${3}"
# 		zle reset-prompt
# 		async_stop_worker prompt -n
# 	}

# 	async_init
# 	async_start_worker prompt -n
# 	async_register_callback prompt prompt_complete
# 	async_job prompt async_prompt_job
# }

# async_prompt_job() {
# 	echo "$(git_prompt) $(k8s_prompt)$(vpn_prompt)"
# }

# prompt() {
# 	local last_command_exit="$?"

# 	PROMPT="$DEFAULT_PROMPT"
# 	RPROMPT="$DEFAULT_RPROMPT"

# 	[[ "x${last_command_exit:-}" != "x0" ]] && PROMPT="${PROMPT}%K{red}%B%F{white} ${last_command_exit} %b%f%k "
# 	unset last_command_exit

# 	PROMPT="$PROMPT❯❯ "

# 	set_terminal_title

# 	zle && zle reset-prompt
# 	async_prompt
# }

# precmd_functions+=(prompt)

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
	eval "$(oh-my-posh --config "~/.config/oh-my-posh/config.yaml" init zsh)"
fi
