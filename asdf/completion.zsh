if [ $commands[asdf] ]; then
  # Placeholder 'asdf' shell function:
  # Will only be executed on the first call to 'asdf'
  asdf() {

    # Remove this function, subsequent calls will execute 'asdf' directly
    unfunction "$0"

    # Load auto-completion
    source "$HOME/.asdf/completions/asdf.bash"

    # Execute 'asdf' binary
    $0 "$@"
  }
fi
