{pkgs, ...}: rec {
  time.timeZone = "Australia/Melbourne";

  # Allow sudo via TouchId
  security.pam.services.sudo_local.touchIdAuth = true;

  services = {
    # scutil --dns
    # dns-sd -G v4 scribe.hack
    dnsmasq = {
      enable = true;
      bind = "127.0.0.1";
      port = 53;
      addresses = {
        ".hack" = "127.0.0.1"; # Point the entire `.hack` zone to localhost.
      };
    };
  };

  system = {
    primaryUser = "justin";

    # Flush out setting of defaults for the given user. This will actually make changed system defaults apply.
    activationScripts.postActivation.text = ''
      sudo -u ${system.primaryUser} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    # Fat stack of system defaults!
    #
    # https://github.com/nix-darwin/nix-darwin/tree/master/modules/system/defaults
    defaults = {
      # https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/defaults/trackpad.nix
      trackpad = {
        TrackpadRightClick = true;
        ActuationStrength = 0;
      };

      # https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/defaults/finder.nix
      finder = {
        ShowStatusBar = true;
        ShowPathbar = true;
        AppleShowAllExtensions = true;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        NewWindowTarget = "Home";
        FXPreferredViewStyle = "clmv"; # default to column view
        _FXShowPosixPathInTitle = true; # full path in window title
      };

      dock = {
        orientation = "bottom";
        mineffect = "scale";
        mru-spaces = false; # Whether to automatically rearrange spaces based on most recent use.
        scroll-to-open = true; # Scroll up on a Dock icon to show all Space's opened windows for an app, or open stack.
        show-recents = false;
        persistent-apps = [
          {app = "/System/Applications/Utilities/Activity Monitor.app";}
          {app = "/Applications/Reeder.app";}
          {app = "/Applications/Obsidian.app";}
          {app = "/Applications/Things3.app";}
          {app = "/System/Applications/Mail.app";}
          {app = "/System/Applications/Calendar.app";}
          {app = "/Applications/Ghostty.app";}
          {app = "/Applications/Zed.app";}
          {app = "/Applications/Sublime Text.app";}
          {app = "/Applications/Sketch.app";}
          {app = "/Applications/Firefox.app";}
        ];
        persistent-others = [
          "/Users/justin/Library/Mobile Documents/com~apple~CloudDocs/Documents" # iCloud Documents folder
          "/Users/justin/Downloads"
        ];

        # Disable hot corners.
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };

      # https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/defaults/SoftwareUpdate.nix
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = false;
      };

      # https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/defaults/NSGlobalDomain.nix
      NSGlobalDomain = {
        # keyboard navigation in dialogs
        AppleKeyboardUIMode = 3;

        # disable press-and-hold for keys in favor of key repeat
        ApplePressAndHoldEnabled = false;

        # fast key repeat rate when hold
        KeyRepeat = 1;
        InitialKeyRepeat = 15;

        "com.apple.trackpad.enableSecondaryClick" = true; # Whether to enable trackpad secondary click.
        "com.apple.trackpad.trackpadCornerClickBehavior" = 1; # Enables right click.
        "com.apple.swipescrolldirection" = false; # Turn off “natural” scrolling.

        AppleInterfaceStyleSwitchesAutomatically = true;

        AppleShowScrollBars = "Always";
        AppleScrollerPagingBehavior = true; # Jump to the spot that's clicked on the scroll bar.

        NSAutomaticCapitalizationEnabled = false;
      };

      ActivityMonitor = {
        ShowCategory = 100; # All processes.
      };
    };
  };
}
