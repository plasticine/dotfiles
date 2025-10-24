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
      "firefox"
      "google-chrome"
      "ghostty"
      "nightfall"
      "keepingyouawake"
      "pika"
      "little-snitch"
      "cleanshot"
      "sublime-text"
      "zed"
      "kaleidoscope@3"
      "obsidian"
      "orbstack"
      "xcodes"
    ];
    masApps = {
      "Wireguard" = 1451685025;
      "Velja" = 1607635845;
      "Pastebot" = 1179623856;
      "Soulver 3" = 1508732804;
      "Folder Quick Look" = 6753110395;
    };
  };
}
