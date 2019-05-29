export GPG_TTY=$(tty)

# When on SSH we want to ensure we get a dialog we can actually interact
# with, not a native GUI one!
if [[ -n "$SSH_CONNECTION" ]] ;then
  export PINENTRY_USER_DATA="USE_CURSES=1"
fi

export GPG_AGENT_INFO
AGENT_SOCK="$(gpgconf --list-dirs | grep agent-socket | cut -d : -f 2)"

if [ ! -S ${AGENT_SOCK} ]; then
  gpg-agent --daemon --enable-ssh-support >/dev/null 2>&1
fi
