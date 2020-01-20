if [ $commands[asdf] ]; then
  # Placeholder 'asdf' shell function:
  asdf() {
    unfunction "$0"  # Remove this function, subsequent calls will execute 'asdf' directly
    source "/usr/local/opt/asdf/etc/bash_completion.d/asdf.bash"  # Load auto-completion
    $0 "$@"  # Execute 'asdf' binary
  }
fi
