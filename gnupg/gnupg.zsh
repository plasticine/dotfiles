source ~/.gnupg/.gpg-agent-info
export GPG_AGENT_INFO
AGENT_SOCK=`gpgconf --list-dirs | grep agent-socket | cut -d : -f 2`

if [ ! -S ${AGENT_SOCK} ]; then
  gpg-agent --daemon --use-standard-socket >/dev/null 2>&1
fi
export GPG_TTY=$(tty)
