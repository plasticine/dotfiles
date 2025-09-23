# config.nu
#
# Installed by:
# version = "0.107.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R


source ./themes/catppuccin_latte.nu

$env.config.buffer_editor = "zed"
$env.config.table.mode = "rounded"


# Prompt configuration
#
# https://www.nushell.sh/book/configuration.html#prompt-configuration

# The prompt itself
$env.PROMPT_COMMAND = {||}

# A prompt which can appear on the right side of the terminal
$env.PROMPT_COMMAND_RIGHT = {||}

# Emacs mode indicator
$env.PROMPT_INDICATOR = {||}

# Vi-normal mode indicator
$env.PROMPT_INDICATOR_VI_NORMAL = {||}

# Vi-insert mode indicator
$env.PROMPT_INDICATOR_VI_INSERT = {||}

# The multi-line indicator
$env.PROMPT_MULTILINE_INDICATOR = {||}
