autoload colors && colors

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

get_hostname() {
  hostname=$(hostname)
  if [[ $hostname == "Doppio.local" ]]
  then
    echo ""
  else
    echo "%{$fg_bold[magenta]%}[$hostname]%{$reset_color%}"
  fi
}

git_head_id(){
  echo "$($git rev-parse --short HEAD 2>/dev/null)"
}

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}@$(git_head_id)"
}

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo "%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "%{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " (with %{$fg_bold[magenta]%}unpushed%{$reset_color%})"
  fi
}

function notes_count() {
  if [[ -z $1 ]]; then
    local NOTES_PATTERN="TODO|FIXME|HACK";
  else
    local NOTES_PATTERN=$1;
  fi
  grep -ERn "\b($NOTES_PATTERN)\b" {app,config,lib,spec,test} 2>/dev/null | wc -l | sed 's/ //g'
}

function notes_prompt() {
  local COUNT=$(notes_count $1);
  if [ $COUNT != 0 ]; then
    echo "%{$fg[black]%}[$1: $COUNT]%{$reset_color%}";
  else
    echo "";
  fi
}

directory_name(){
  echo "%{$fg[cyan]%}%1/%\/%{$reset_color%}"
}

export PROMPT=$'$(directory_name) \
$(get_hostname) %{$fg_bold[yellow]%}⚡ %{$reset_color%}'

set_prompt () {
  export RPROMPT=$'$(git_dirty)$(need_push)$(notes_prompt TODO)'
}

precmd() {
  set_prompt
}
