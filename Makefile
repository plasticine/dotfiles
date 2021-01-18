SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

DOTFILES_TARGET := $(addsuffix "/", $(basename $(HOME)))
DOTFILES_ROOT := $(shell git rev-parse --show-toplevel)
DOTFILES_SYMLINKS := $(shell find $(DOTFILES_ROOT) -maxdepth 5 -name \*.symlink)
DOTFILES_ORPHANS := $(shell find $(DOTFILES_ROOT) -type l -maxdepth 1 ! -exec test -e {} \; -print)

define BANNER

╔═════════════════════════════════════════════════╗
║               __      __  _____ __              ║░
║          ____/ /___  / /_/ __(_) /__  _____     ║░
║         / __  / __ \/ __/ /_/ / / _ \/ ___/     ║░
║       _/ /_/ / /_/ / /_/ __/ / /  __(__  )      ║░
║      (_)__,_/\____/\__/_/ /_/_/\___/____/       ║░
║                                                 ║░
╚═════════════════════════════════════════════════╝░
 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

endef

Brewfile:
	brew bundle

$(HOME)/.tool-versions:
	awk '{print $1}' < ~/.tool-versions | xargs -n1 asdf plugin add
	awk '{print $1}' < ~/.tool-versions | xargs -n1 asdf install

.PHONY: $(DOTFILES_SYMLINKS)
$(DOTFILES_SYMLINKS):
	@echo "$@ → $(join $(DOTFILES_TARGET), $(addprefix ".", $(notdir $(basename $@))))"
	@ln -snf "$@" "$(join $(DOTFILES_TARGET), $(addprefix ".", $(notdir $(basename $@))))"

all:
	@$(info $(BANNER))
	@$(MAKE) Brewfile
	@$(MAKE) $(DOTFILES_SYMLINKS)
	@$(MAKE) $(HOME)/.tool-versions
