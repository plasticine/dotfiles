# if (($+commands[git])); then
#   git="$commands[git]"
# else
#   git="/usr/bin/git"
# fi

# if [[ -n "$SSH_CONNECTION" ]] ; then
#   SSH_NOTICE=" %K{yellow}%F{black}%B SSH %b%f%k "
# else
#   SSH_NOTICE=" "
# fi

# GIT_PROMPT_NO_UPSTREAM="%K{red}%F{black}%B \U0000f655 UPSTREAM %b%f%k"

# git.in_repo() {
#   [[ $($git branch &>> /dev/null) ]]
# }

# k8s.status() {
#   local context namespace user

#   # Set context
#   if ! context="$(kubectl --request-timeout=1s config current-context 2>/dev/null)"; then
#     echo ""
#     return 1
#   fi

#   ZSH_KUBECTL_CONTEXT="${context}"

#   # Set namespace
#   namespace="$(kubectl --request-timeout=1s config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.namespace}")"
#   [[ -z "$namespace" ]] && namespace="default"
#   ZSH_KUBECTL_NAMESPACE="${namespace}"

#   [[ "$ZSH_KUBECTL_CONTEXT" =~ "production" ]] && color=red || color=blue
#   echo "%{$fg[$color]%}${user} ${context}/${namespace}%{$reset_color%}"

#   if [[ $content =~ "PRODUCTION" ]]; then
#     echo -e "\033]6;1;bg;red;brightness;255\a"
#   else
#     echo -e "\033]6;1;bg;*;default\a"
#   fi

#   echo $content
# }

# git.branch() {
#   ($git symbolic-ref -q HEAD || $git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
# }

# git.branch_raw() {
#   echo "${$(git.branch)#(refs/heads/|tags/)}" 2> /dev/null
# }

# git.commit() {
#   ($git rev-parse --short HEAD) 2> /dev/null || echo "NONE"
# }

# git.has_tracking_branch() {
#   $git log --oneline @{u}.. &> /dev/null

#   [[ x$? == x128 ]] && echo " $GIT_PROMPT_NO_UPSTREAM"
# }

# git.num_commits_ahead() {
#   local commits_ahead="$($git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"

#   if [ "$commits_ahead" -gt 0 ]; then
#     echo -ne " \U0000f55c${commits_ahead}"
#   fi

#   unset commits_ahead
# }

# git.num_commits_behind() {
#   local commits_behind="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"

#   if [ "$commits_behind" -gt 0 ]; then
#     echo -ne " \U0000f544${commits_behind}"
#   fi
#   unset commits_behind
# }

# diffstat_to_origin_master() {
#   $git log --oneline @{u}.. &> /dev/null

#   if [[ x$? == x0 ]]; then
#     local diff="$($git diff --cached --shortstat origin/master)"
#     local changed="$(echo "$diff" | awk '{print $1}')"
#     local inserted="$(echo "$diff" | awk '{print $4}')"
#     local deleted="$(echo "$diff" | awk '{print $6}')"

#     echo -ne " %K{blue} ${changed} %k%K{green} ${inserted} %k%K{red} ${deleted} %k"
#     unset diff changed inserted deleted
#   fi
# }

# git.status() {
#   local ref_stats="$(git.branch_raw)@$(git.commit)"
#   local remote_stats="$(git.num_commits_ahead)$(git.num_commits_behind)"
#   local file_stats="$(diffstat_to_origin_master)"
#   local remote_tracking="$(git.has_tracking_branch)"

#   echo -ne "%K{white}%F{black} ${ref_stats}${remote_stats}${remote_tracking} %f%k"
#   unset ref_stats remote_stats file_stats remote_tracking
# }

# via_ssh() {
#   [[ -n "$SSH_CONNECTION" ]]
# }

# in_repo() {
#   [[ $($git branch &>> /dev/null) ]]
# }

# k8s.current_context() {
#   local kube_config; kube_config="${KUBECONFIG:-${HOME}/.kube/config}"
# }


DEFAULT_PROMPT="%f%B%F{yellow}%M%f%b${SSH_NOTICE}%F{white} %3~%f $(echo -ne '\U0000f054') "
DEFAULT_RPROMPT=""

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
  echo "$(git_prompt) $(k8s_prompt)$(vpn_prompt)"
}

prompt() {
  local last_command_exit; last_command_exit="$?"

  PROMPT="$DEFAULT_PROMPT"
  RPROMPT="$DEFAULT_RPROMPT"

  [[ "x$last_command_exit" != "x0" ]] && PROMPT="${PROMPT}%K{red}%B%F{white} ${last_command_exit} %b%f%k "
  unset last_command_exit

  zle && zle reset-prompt
  async_prompt
}

precmd_functions+=(prompt)
