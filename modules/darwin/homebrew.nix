{
  # inputs,
  # pkgs,
  ...
}: {
  # Work mac comes with brew.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false; # annoying
      # cleanup = "zap"; # `zap` uninstalls all formulae(and related files) not listed here.
    };

    taps = [
      # This requires the gh CLI to have been authed before it will work...
      {
        name = "ferocia/tfshell";
        clone_target = "https://github.com/ferocia/tfshell";
        force_auto_update = true;
      }
    ];

    brews = [
      {
        name = "ferocia/tfshell/tfshell";
      }
    ];

    casks = [
      "cleanshot"
      # "dash"
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
      "postico"
      "sketch"
      "sketch@beta"
      "sublime-text"
      "vlc"
      "xcodes-app"
      "zed"
    ];

    masApps = {
      "Folder Quick Look" = 6753110395;
      "Meeting Bar App" = 1532419400;
      "Pastebot" = 1179623856;
      "Reeder" = 1529448980;
      "Soulver 3" = 1508732804;
      "Things" = 904280696;
      "Velja" = 1607635845;
      "Wireguard" = 1451685025;
      "iA Writer" = 775737590;
    };
  };
}
