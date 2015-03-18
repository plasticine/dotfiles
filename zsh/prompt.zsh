function welcome() {
  echo "$(tput setaf 2)
`date +"%A, %e %B %Y, %r"`
`uname -srm`

Uptime:        `uptime | sed -e "s/^.* up/up/g" | sed -e 's/,.*//g'`
Load Averages: `uptime | sed -e 's/^.*load averages: //g'`
Processes:     `ps ax | wc -l | tr -d ' '`
$(tput sgr0)
`git-stats`

`kickboxen`
"
}

welcome

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

get_hostname() {
  hostname=$(hostname)
  if [[ "$SSH_CONNECTION" != '' ]]
  then
    echo "%{$fg_bold[magenta]%}[$hostname] %{$reset_color%}"
  else
    echo "doppio"
  fi
}

git_head_id () {
  echo "$($git rev-parse --short HEAD 2>/dev/null)"
}

git_branch () {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}@$(git_head_id)"
}

git_dirty() {
  # check if we're in a git repo
  command git rev-parse --is-inside-work-tree &>/dev/null || return
  # check if it's dirty
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

unpushed() {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%}"
  fi
}

directory_name(){
  echo "%{$fg[cyan]%}%2/%{$reset_color%}"
}

export PROMPT=$'%{$fg_bold[yellow]%}$(get_hostname) ❯%{$reset_color%} $(directory_name) '

set_prompt () {
  export RPROMPT=$'$(git_dirty)$(need_push)'
}

precmd() {
  set_prompt
}
