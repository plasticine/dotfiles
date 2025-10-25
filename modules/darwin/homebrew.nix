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
      "obsidian"
      "orbstack"
      "pika"
      "sketch"
      "sublime-text"
      "vlc"
      "xcodes"
      "zed"
    ];
    masApps = {
      "Folder Quick Look" = 6753110395;
      "Pastebot" = 1179623856;
      "Soulver 3" = 1508732804;
      "Velja" = 1607635845;
      "Wireguard" = 1451685025;
      "iA Writer" = 775737590;
    };
  };
}
