{
  # inputs,
  # pkgs,
  ...
}: {
  # Work mac comes with brew.
  homebrew = {
    enable = false;

    onActivation = {
      autoUpdate = false; # annoying
      # cleanup = "zap"; # `zap` uninstalls all formulae(and related files) not listed here.
    };

    brews = [];
    casks = [];
    masApps = {};
  };
}
