if [ $commands[kubectl] ]; then
  # Will only be executed on the first call to 'kubectl'
  kubectl() {
    unfunction "$0"  # Remove this function, subsequent calls will execute 'kubectl' directly
    source <(kubectl completion zsh)  # Load auto-completion
    $0 "$@"  # Execute 'kubectl' binary
  }
fi
