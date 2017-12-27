alias kctl='kubectl $argv'

function kctx() {
  local output contexts context;
  output="$(kubectl config get-contexts)"
  contexts="$(echo $output | head -n 1 && echo $output | tail -n +2 | sort -r)"
  context=$(echo "$contexts" | fzf --ansi --header-lines=1 | awk '{print $1}')
  if [[ $context ]] && [[ "$context" != "*" ]]; then
    kubectl config use-context $context
  fi
}
