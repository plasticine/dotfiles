SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

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

install:
	@$(info $(BANNER))
	@stow --verbose --ignore='.DS_Store' --restow --target $$HOME mise
	@stow --verbose --ignore='.DS_Store' --restow --target $$HOME git
	@stow --verbose --ignore='.DS_Store' --restow --target $$HOME gnupg
	@stow --verbose --ignore='.DS_Store' --restow --target $$HOME k9s
	@stow --verbose --ignore='.DS_Store' --restow --target $$HOME postgres
	@stow --verbose --ignore='.DS_Store' --restow --target $$HOME ruby
	@stow --verbose --ignore='.DS_Store' --restow --target $$HOME zsh
	@stow --verbose --ignore='.DS_Store' --restow --target $$HOME jj
