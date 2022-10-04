export GPG_TTY="$(tty)"

# When on SSH we want to ensure we get a dialog we can actually interact
# with, not a native GUI one!
[[ -n "$SSH_CONNECTION" ]] && export PINENTRY_USER_DATA="USE_CURSES=1"

export GPG_AGENT_INFO
AGENT_SOCK="$(gpgconf --list-dirs | grep agent-socket | cut -d : -f 2)"

if [[ ! -S "${AGENT_SOCK}" ]]; then
  echo "Starting gpg-agent server..." 1>&2
  if ! gpg-agent --daemon --pinentry-program="$(brew --prefix)/bin/pinentry"; then
    echo "Error starting gpg-agent!" 1>&2
  fi
fi
