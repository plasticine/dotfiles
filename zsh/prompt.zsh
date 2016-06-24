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

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

get_hostname() {
  hostname=$(hostname -f)
  if [[ "$SSH_CONNECTION" != '' ]]
  then
    echo "%{$fg_bold[magenta]%}[$hostname] %{$reset_color%}"
  else
    echo "@$hostname"
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
  unpushed_count=$($git cherry -v @{upstream} | wc -l)
  echo "${unpushed_count##*( )}"
}

need_push () {
  unpushed_count="$(unpushed)"
  if [[ "$unpushed_count" == "0" ]]
  then
    echo ""
  else
    echo "[ahead %{$fg_bold[green]%}${unpushed_count}%{$reset_color%}] "
  fi
}

directory_name(){
  echo "%{$fg[cyan]%}%2/%{$reset_color%}"
}

export PROMPT=$'%{$fg_bold[yellow]%}$(get_hostname)%{$reset_color%} $(directory_name) %{$fg_bold[red]%}❯%{$reset_color%}%{$fg_bold[yellow]%}❯%{$reset_color%}%{$fg_bold[green]%}❯%{$reset_color%} '

precmd () {
  # check if we're in a git repo
  command git rev-parse --is-inside-work-tree &>/dev/null || return
  export RPROMPT=$'$(need_push)$(git_dirty)'
}
