# Prompt configuration
#
# https://www.nushell.sh/book/configuration.html#prompt-configuration

# use ($nu.default-config-dir | path join "rose-pine-dawn.nu")

export def --env pre_prompt [] {
  print "pre prompt hook"
}

export def --env pre_execution [] {
  print "pre prompt hook"
  render_right
}

export def render_left []: nothing -> string {
  [$env.USER, "@", (hostname), (date now | format date '%m/%d/%Y %r'), "\n"] | str join
}

export def --env render_right []: nothing -> any {
  # [(/Users/justin/Workspace/plasticine/dotfiles/zsh/.config/zsh/bin/git_prompt), c] | str join
  let $jobId: int = job spawn --tag "prompt" {
    sleep 200ms
    print (date now | format date '%m/%d/%Y %r')
  }
  $env.PROMPT_COMMAND_RIGHT = $"Loop iteration ($jobId)"
}
