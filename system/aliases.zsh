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

# Kubernetes stuff
alias k='kubectl $argv'

alias kccc='k config current-context'

function kcsns() {
    [[ -z "$1" ]] && echo "Error: namespace is a required argument." && return 1
    kubectl config set-context --current --namespace=$1
}

# Get
alias kg='k get'
alias kgpo='kg po'
alias kgde='kg deploy'
alias kgrs='kg rs'
alias kgs='kg service'

# Describe
alias kd='k describe'
