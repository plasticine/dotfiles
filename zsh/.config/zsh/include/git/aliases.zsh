export git_concise_log_format='--pretty=format:%Cblue%h%d%Creset %ar %Cgreen%an%Creset %s'

git_current_branch() {
	command git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///'
}

default_branch() {
	git rev-parse --abbrev-ref origin/HEAD
}

alias ga='git add'
alias gap='ga -p'
alias gau='git add -u'
alias gbr='git branch -v'
alias gc='git commit -v'
alias gc!='git commit -v --no-gpg-sign'
alias gca='gc -a'
alias gcam='gca --amend'
alias gcf='git config -l'
alias gch='git cherry-pick'
alias gcm='gc --amend'
alias gcop='gco "HEAD^1"'
alias gcon='checkout_next_commit'
alias gsu='git submodule update --init --recursive'
alias fixup!='git commit -m "fixup!"'

checkout_next_commit() {
	git log --reverse --pretty=%H "$(default_branch)" | awk "/$(git rev-parse HEAD)/{getline;print}" | xargs git checkout
}

gcob() {
	local format; format="%(committerdate:relative)\\%(color:green)%(refname:short)%(color:reset)\\%(HEAD)\\%(color:yellow)%(objectname:short)%(color:reset) %(upstream:trackshort)\\%(contents:subject)"
	local branches; branches="$(git for-each-ref --format="$format" --sort=-committerdate refs/heads/ | column -t -s "\\")"
	local branch; branch="$(fzf --ansi --height=15 --border <<< "$branches")"
	git checkout $(echo "$branch" | awk '{print $4}')
}

gco() {
	if [ $# -eq 0 ]; then
		gcob
	else
		git checkout "$@"
	fi
}

alias gd='git difftool'
alias gd.='git diff -M --color-words="."'
alias gdw='git diff $color_ruby_words'
alias gdc='git diff --cached -M'
alias gdc.='git diff --cached -M --color-words="."'
alias gdcw='git diff --cached $color_ruby_words'
alias gds='gitd --stat'
alias gf='git fetch'
alias glog='git log $git_concise_log_format'
alias gl='glog --graph'
alias gla='gl --all'
alias gl_absolute='git log --graph --pretty=format:"%Cblue%h%d%Creset %ad %Cgreen%an%Creset %s"'
alias gm='git merge --no-ff'
alias gp='git push'
alias gp!='gp --set-upstream origin $(git_current_branch)'
alias gpf='gp --force-with-lease'
alias gpthis='git push origin HEAD:$(git_current_branch)'
alias gpb='git push banana'
alias gpd='gp deploy deploy'
alias gpt='gp --tags'
alias gr='git reset'
alias grb='git rebase -p'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grh='git reset --hard'
alias grp='gr --patch'
alias grs='git reset --soft'
alias grsh='git reset --soft HEAD~'
alias grv='git remote -v'
alias gs='git show'
alias gss='gs --stat'
alias gst='git stash'
alias gstp='git stash pop'
alias gstwc='gst save --keep-index'
alias gup='git smart-pull'
alias gab='gm $argv && gbr -d $argv'
alias gmd='gm $argv && gbr -d $argv $argv && glcg'
alias graf='git remote add $argv[1] $argv[2] && gf $argv[1]'
alias gpr='git pull-request'
