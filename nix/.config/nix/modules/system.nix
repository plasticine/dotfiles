{...}: rec {
  time.timeZone = "Australia/Melbourne";

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
        FXPreferredViewStyle = "Nlsv"; # default to list view
        _FXShowPosixPathInTitle = true; # full path in window title
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
