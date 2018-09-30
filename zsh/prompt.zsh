function welcome() {
  print -P "%F{white}
%B%D{%A %f %B %Y, %H:%M:%S %p}%b

      \\\/       
      l'>     uptime %B$(uptime | sed -e "s/^.* up/up/g" | sed -e 's/,.*//g')%b    
      ll        load %B$(uptime | sed -e 's/^.*load averages: //g')%b
  ~llama       procs %B$(ps ax | wc -l | tr -d ' ')%b
   || ||    
   '' ''    
%f"
}
    
welcome

# -----------------------------------------------------------------------------

if (($+commands[git])); then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

GIT_PROMPT_NO_UPSTREAM="%K{red}%F{black}%B \U0000f655 UPSTREAM %b%f%k"

function in_repo() {
  if $git branch 2>/dev/null; then
    return 0
  fi
  return 1
}

function git_branch() {
  ($git symbolic-ref -q HEAD || $git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

function git_branch_raw() {
  echo "${$(git_branch)#(refs/heads/|tags/)}" 2> /dev/null
}

function git_commit() {
  ($git rev-parse --short HEAD) 2> /dev/null || echo "NONE"
}

function git_has_tracking_branch() {
  $git log --oneline @{u}.. &> /dev/null
  [[ x$? == x128 ]] && echo " $GIT_PROMPT_NO_UPSTREAM"
}

function git_num_commits_ahead() {
  local commits_ahead="$($git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$commits_ahead" -gt 0 ]; then
    echo -ne " \U0000f55c${commits_ahead}"
  fi
  unset commits_ahead
}

function git_num_commits_behind() {
  local commits_behind="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$commits_behind" -gt 0 ]; then
    echo -ne " \U0000f544${commits_behind}"
  fi
  unset commits_behind
}

function diffstat_to_origin_master() {
  $git log --oneline @{u}.. &> /dev/null
  if [[ x$? == x0 ]]; then
    local diff="$($git diff --cached --shortstat origin/master)"
    local changed="$(echo "$diff" | awk '{print $1}')"
    local inserted="$(echo "$diff" | awk '{print $4}')"
    local deleted="$(echo "$diff" | awk '{print $6}')"

    echo -ne " %K{blue} ${changed} %k%K{green} ${inserted} %k%K{red} ${deleted} %k"
    unset diff changed inserted deleted
  fi
}


function git_status() {
  local ref_stats="$(git_branch_raw)@$(git_commit)"
  local remote_stats="$(git_num_commits_ahead)$(git_num_commits_behind)"
  local file_stats="$(diffstat_to_origin_master)"
  local remote_tracking="$(git_has_tracking_branch)"

  echo -ne "%K{white}%F{black} \U0000e727 ${ref_stats}${remote_stats}${file_stats}${remote_tracking}%f%k"
  unset ref_stats remote_stats file_stats remote_tracking
}

DEFAULT_PROMPT="%F{magenta}%n%f%F{white}@%f%B%F{yellow}%M%f%b %F{white}%3~%f $(echo -ne '\U0000f054') "
DEFAULT_RPROMPT=""
NEXT_PROMPT=""
NEXT_RPROMPT=""

function async_prompt() {
  function prompt_complete() {

    PROMPT="$DEFAULT_PROMPT"
    RPROMPT="$DEFAULT_RPROMPT$3"
    zle reset-prompt
    async_stop_worker prompt -n
  }

  async_init
  async_start_worker prompt -n
  async_register_callback prompt prompt_complete
  async_job prompt prompt_job
}

function prompt_job() {
  [[ $(in_repo) ]] && echo -ne "$(git_status)"
}

function prompt_precmd() {
  local last_command_exit="$?"

  NEXT_PROMPT=$DEFAULT_PROMPT
  NEXT_RPROMPT=$DEFAULT_RPROMPT

  [[ "x$last_command_exit" != "x0" ]] && NEXT_PROMPT="${NEXT_PROMPT}%K{red}%B%F{white} ${last_command_exit} %b%f%k "
  unset last_command_exit

  PROMPT=$NEXT_PROMPT
  RPROMPT=$NEXT_RPROMPT

  async_prompt
}

TMOUT=1
TRAPALRM() {
  zle reset-prompt
}

precmd_functions+=(prompt_precmd)