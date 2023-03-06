__dotfiles::load() {
	for file in "$@"; do
		source $file;
	done
}

__dotfiles::main() {
	export ZSH_CONFIG_ROOT="$HOME/.config/zsh"

	# Export the ZSH config bin dir, we have helper scripts for prompts and things there...
	export PATH="$ZSH_CONFIG_ROOT/bin:$PATH"

	# All of our *.zsh files
	typeset -U config_files
	config_files=($(find -L "$ZSH_CONFIG_ROOT" -name "*.zsh" -maxdepth 3))

	# This all looks a bit wild but makes sense...
	#
	# Basically out of all the config files we found we want to source them
	# in roughly the following order;
	#
	# 1. Files named `path.zsh` that mess with PATH, do this early to prevent missing binaries.
	# 2. Everything that is not an include or completion
	# 3. Includes but not completions
	# 4. All completions (after initializing autocomplete)
	#
	# We do this in a pretty janky way just by filtering the paths using param expansion,
	# more details on that here;
	#
	# - https://zsh.sourceforge.io/Doc/Release/Expansion.html#Parameter-Expansion

	# Load any path stuff first...
	__dotfiles::load ${(M)config_files:#*/path.zsh}

	# Load everything else...
	__dotfiles::load ${${${config_files:#*/path.zsh}:#*/include/*}:#*/completion.zsh}

	# Load includes that are not completions...
	__dotfiles::load ${${(M)config_files:#*/include/*}:#*/completion.zsh}

	# Initialize autocomplete here, otherwise functions won't be loaded.
	autoload -Uz compinit && compinit
	autoload -U +X bashcompinit && bashcompinit

	# Finally load completion files
	__dotfiles::load ${(M)config_files:#*/completion.zsh}

	unset config_files

	# use .localrc for SUPER SECRET CRAP that you don't
	# want in your public, versioned repo.
	[[ -a ~/.localrc ]] && source ~/.localrc

	times
}

__dotfiles::main
