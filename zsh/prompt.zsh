setopt prompt_subst

function welcome() {
  echo "
$(tput setaf 2)`date +"%A, %e %B %Y, %r"`
`uname -srm`

Uptime:        `uptime | sed -e "s/^.* up/up/g" | sed -e 's/,.*//g'`
Load Averages: `uptime | sed -e 's/^.*load averages: //g'`
Processes:     `ps ax | wc -l | tr -d ' '`
$(tput sgr0)"
}

welcome

if (($+commands[git])); then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

GIT_PROMPT_AHEAD="%{$fg_bold[green]%}️A:NUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg_bold[red]%}B:NUM%{$reset_color%}"
GIT_PROMPT_NO_UPSTREAM="%{$fg_bold[red]%}no upstream%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}★%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}◉%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}◉%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}◉%{$reset_color%}"
GIT_PROMPT_NULL_STATE="%{$fg[white]%}◎%{$reset_color%}"

function git_branch() {
  ($git symbolic-ref -q HEAD || $git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

function git_commit() {
  ($git rev-parse --short HEAD) 2> /dev/null
}

function git_has_tracking_branch() {
  $git log --oneline @{u}.. &> /dev/null
  if [[ x$? == x128 ]]; then
    echo $GIT_PROMPT_NO_UPSTREAM
  fi
}

function git_num_commits_ahead() {
  local commits_ahead="$($git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$commits_ahead" -gt 0 ]; then
    echo ${GIT_PROMPT_AHEAD//NUM/$commits_ahead}
  fi
}

function git_num_commits_behind() {
  local commits_behind="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$commits_behind" -gt 0 ]; then
    echo ${GIT_PROMPT_BEHIND//NUM/$commits_behind}
  fi
}

function git_requires_merge() {
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    echo $GIT_PROMPT_MERGING
  fi
}

function git_untracked_files() {
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    echo "$GIT_PROMPT_UNTRACKED"
  else
    echo $GIT_PROMPT_NULL_STATE
  fi
}

function git_modified_files() {
  if ! git diff --quiet 2> /dev/null; then
    echo "$GIT_PROMPT_MODIFIED"
  else
    echo "$GIT_PROMPT_NULL_STATE"
  fi
}

function git_staged_files() {
  if ! git diff --cached --quiet 2> /dev/null; then
    echo "$GIT_PROMPT_STAGED"
  else
    echo "$GIT_PROMPT_NULL_STATE"
  fi
}

function git_traffic_light() {
  echo "$(git_untracked_files) $(git_modified_files) $(git_staged_files) "
}

function git_prompt_status() {
  local branch="$(git_branch)"
  [ -n "$branch" ] && echo "$(git_traffic_light) %{$fg_bold[blue]%}${branch#(refs/heads/|tags/)}@$(git_commit)%{$reset_color%} $(git_has_tracking_branch)$(git_num_commits_ahead)$(git_num_commits_behind)"
}

DEFAULT_PROMPT="%{$fg_bold[magenta]%}%n%{$reset_color%}@%{$fg_bold[yellow]%}%m%{$reset_color%} %{$fg[white]%}%2/%{$reset_color%} %{$fg_bold[red]%}❯%{$reset_color%}%{$fg_bold[yellow]%}❯%{$reset_color%}%{$fg_bold[green]%}❯ %{$reset_color%}"
DEFAULT_RPROMPT=""

export PROMPT="$DEFAULT_PROMPT"
export RPROMPT="$DEFAULT_RPROMPT"

# The pid of the async prompt process and the communication file
ASYNC_PROMPT=0
ASYNC_PROMPT_FILE="/tmp/.zsh_tmp_prompt_$$"
ASYNC_RPROMPT_FILE="/tmp/.zsh_tmp_rprompt_$$"

# This here implements the async handling of the prompt.  It
# runs the expensive git parts in a subprocess and passes the
# information back via tempfile.
function prompt_precmd() {
  command_exit="$?"

  function async_prompt() {
    echo -n "$DEFAULT_PROMPT" > $ASYNC_PROMPT_FILE
    echo -n $DEFAULT_RPROMPT$' '$(git_prompt_status) > $ASYNC_RPROMPT_FILE
    if [[ x$command_exit != x0 ]]; then
      echo -n ' [\$?:'"%{$fg_bold[red]%}$command_exit%{$reset_color%}]" >> $ASYNC_RPROMPT_FILE
    fi

    # signal parent
    kill -s USR1 $$
  }

  # If we still have a prompt async process we kill it to make sure
  # we do not backlog with useless prompt things.  This also makes
  # sure that we do not have prompts interleave in the tempfile.
  if [[ "${ASYNC_PROMPT}" != 0 ]]; then
    kill -s HUP $ASYNC_PROMPT >/dev/null 2>&1 || :
  fi

  # start background computation
  async_prompt &!
  ASYNC_PROMPT="$!"
}

# This is the trap for the signal that updates our prompt and
# redraws it.  We intentionally do not delete the tempfile here
# so that we can reuse the last prompt for successive commands
function prompt_trapusr1() {
  RPROMPT="$(cat $ASYNC_RPROMPT_FILE)"
  PROMPT="$(cat $ASYNC_PROMPT_FILE)"
  ASYNC_PROMPT=0
  zle && zle reset-prompt
}

# Make sure we clean up our tempfile on exit
function prompt_zshexit() {
  rm -f "$ASYNC_RPROMPT_FILE"
}

# Hook our precmd and zshexit functions and USR1 trap
precmd_functions+=(prompt_precmd)
zshexit_functions+=(prompt_zshexit)
trap prompt_trapusr1 USR1
