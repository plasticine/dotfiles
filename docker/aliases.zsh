alias dc='docker-compose'
alias dcu='dc up'
alias dcb='dc build'
alias dcrm='dc rm'
alias dck='dc kill'

# Stop all containers
dstop() { docker stop $(docker ps -a -q); }

# Remove all containers
drm() { docker rm $(docker ps -a -q); }

# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

# Remove all images
dri() { docker rmi $(docker images -q); }
