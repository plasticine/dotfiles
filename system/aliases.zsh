# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
alias ls="ll"
alias l="exa -lAh"
alias ll="exa -l --git"
alias la='exa -A'

alias s='git status -sb $argv; return 0'
alias d='gd $argv'

alias be='bundle exec $argv'

alias jest='nocorrect jest'
alias flow='nocorrect flow'

alias kc='kubectl $argv'
alias kcctx='kubectl config current-context'
