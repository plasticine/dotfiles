# Makes color constants available
autoload -U colors
colors

typeset -F SECONDS

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true
export LC_ALL=en_AU.UTF-8
export LANG="en_AU.UTF-8"

if [[ -n "$SSH_CONNECTION" ]] ;then
  export EDITOR="vi"
else
  export EDITOR="subl --wait --new-window"
fi

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt NO_BG_NICE # Don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # Allow functions to have local options
setopt LOCAL_TRAPS # Allow functions to have local traps
setopt SHARE_HISTORY # Share history between sessions ???
setopt EXTENDED_HISTORY # Add timestamps to history
setopt PROMPT_SUBST
setopt PROMPT_PERCENT
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt APPEND_HISTORY # Adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # Adds history incrementally and share it across sessions
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS  # Don't record dupes in history
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE  # Ignore commands with leading spaces

# Awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob
setopt complete_aliases
setopt prompt_subst
setopt prompt_percent

zle -N newtab

export WORDCHARS='*?[]~=&;!#$%^(){}'

# Mappings for Ctrl/Option-left-arrow and Ctrl/Option-right-arrow for word moving
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
