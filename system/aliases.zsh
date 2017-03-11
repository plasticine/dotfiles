# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
alias ls="gls -AF --color"
alias l="gls -lAh --color"
alias ll="gls -l --color"
alias la='gls -A --color'

alias s='git status -sb $argv; return 0'
alias d='gd $argv'

alias be='bundle exec $argv'
