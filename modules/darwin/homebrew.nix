{
  # inputs,
  # pkgs,
  ...
}:
{
  # Work mac comes with brew.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false; # annoying
      # cleanup = "zap"; # `zap` uninstalls all formulae(and related files) not listed here.
    };

    brews = [ ];
    casks = [
      "cleanshot"
      "firefox"
      "ghostty"
      "google-chrome"
      "kaleidoscope@3"
      "keepingyouawake"
      "little-snitch"
      "nightfall"
      "nvidia-geforce-now"
      "obsidian"
      "orbstack"
      "pika"
      "sketch"
      "sketch@beta"
      "sublime-text"
      "vlc"
      "xcodes-app"
      "zed"
    ];
    masApps = {
      "Velja" = 1607635845;
      "Things" = 904280696;
      "Pastebot" = 1179623856;
      "iA Writer" = 775737590;
      "Soulver 3" = 1508732804;
      "Wireguard" = 1451685025;
      "Folder Quick Look" = 6753110395;
      "Reeder" = 1529448980;
    };
  };
}
