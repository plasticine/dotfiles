alias ls="ll"
alias l="eza -lAh"
alias ll="eza -l --git"
alias la='eza -A'

alias s='git status -sb $argv; return 0'
alias d='gd $argv'

alias be='bundle exec $argv'

alias jest='nocorrect jest'
alias flow='nocorrect flow'

alias unknow='ssh-keygen -R $argv'

# Jujutsu aliases
alias j='jj'
alias js='jj status'
alias jt='jj tug'
alias jc='jj commit'
alias jci='jj commit --interactive'
alias jf='jj fetch'
alias jp='jj push'
alias jsq='jj squash'
alias jsqi='jj squash --interactive'
