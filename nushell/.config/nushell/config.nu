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

# use ($nu.default-config-dir | path join "prompt.nu") *

use /Users/justin/Workspace/plasticine/dotfiles/nushell/.config/nushell/prompt.nu *


$env.config.buffer_editor = "zed"
$env.config.table.mode = "rounded"

# The prompt itself
$env.PROMPT_COMMAND = { render_left }

# A prompt which can appear on the right side of the terminal
$env.PROMPT_COMMAND_RIGHT = {||}

# The prompt itself after the commandline has been executed
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {||}

# A prompt which can appear on the right side of the terminal
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = null

$env.config.hooks = {
    pre_prompt: [
      pre_prompt
    ]
    pre_execution: [
      pre_execution
    ]
}
