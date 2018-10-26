if [ $commands[nodenv] ]; then
  version="$(command nodenv --version | awk '{print $2}')"
  source "/usr/local/Cellar/nodenv/${version}/completions/nodenv.zsh"
fi