export LANG="en_AU.UTF-8"

if [[ -n "$SSH_CONNECTION" ]] ;then
  export EDITOR="vi"
else
  export EDITOR="subl --wait --new-window"
fi
