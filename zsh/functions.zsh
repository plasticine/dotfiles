cd() {
  builtin cd "$@" && ll
}

project_notes() {
  git ls-files | xargs notes | awk -F: '{ print $1,$2; print $3,$4; print $5}' | grcat ~/.dotfiles/grc/conf.notes
}
