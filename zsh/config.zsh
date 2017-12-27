# makes color constants available
autoload -U colors
colors

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

setopt complete_aliases

setopt prompt_subst
setopt prompt_percent

zle -N newtab

export WORDCHARS='*?[]~=&;!#$%^(){}'

# mappings for Ctrl/Option-left-arrow and Ctrl/Option-right-arrow for word moving
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
