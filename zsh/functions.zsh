cd() {
  builtin cd "$@" && ll
}

project_notes() {
  git ls-files | xargs notes | awk -F: '{ print $1,$2; print $3,$4; print $5}' | grcat ~/.dotfiles/grc/conf.notes
}

setup_ssh_key() {
  SSH_PUB_FILE="~/.ssh/id_rsa.pub"
  scp $SSH_PUB_FILE $1:.ssh/authorized_keys 'chown -R `whoami`:`whoami` ~/.ssh; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys;'
}

reboot_safely() {
  if [[ $(hostname) != "Doppio.local" ]]
  then
    fdesetup authrestart
  else
    /sbin/reboot
  fi
}

boxen_unlocked() {
  if [[ $(hostname) != "Doppio.local" ]]
  then
    security unlock-keychain
  fi
}

git_stats() {
  git log --shortstat --author "Justin Morris" --since "52 weeks ago" | grep "files changed" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "files changed", files, "lines inserted:", inserted, "lines deleted:", deleted}'
}

# https://gist.github.com/SlexAxton/4989674
gifify() {
  if [[ -n "$1" ]]; then
    if [[ $2 == '--good' ]]; then
      ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
      time convert -verbose +dither -layers Optimize -resize 600x600\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $GIF
      rm out-static*.png
    else
      ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $GIF
    fi
  else
    echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}
