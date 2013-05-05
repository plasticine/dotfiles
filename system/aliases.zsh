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

alias dotfiles='subl ~/.dotfiles;'

alias reboot='reboot_safely'

alias TOPGUN="open 'http://www.youtube.com/watch?v=NEOem7U2LPE'"
alias IGNITION="open 'http://pixelbloom.com/ride-of-the-valkyries'"
