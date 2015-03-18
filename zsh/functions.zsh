cd() {
  builtin cd "$@" && ll
}

setup_ssh_key() {
  SSH_PUB_FILE="~/.ssh/id_rsa.pub"
  scp $SSH_PUB_FILE $1:.ssh/authorized_keys 'chown -R `whoami`:`whoami` ~/.ssh; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys;'
}

git_stats() {
  git log --shortstat --author "Justin Morris" --since "52 weeks ago" | grep "files changed" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "files changed", files, "lines inserted:", inserted, "lines deleted:", deleted}'
}
