{
  pkgs,
  config,
  ...
}:
let
  # TODO(juz): is there a nice way to extract this?
  dotfiles = "/Users/justin/Code/plasticine/dotfiles";
in
{
  # https://nix-community.github.io/home-manager/options.xhtml
  home.username = "justin";
  home.homeDirectory = "/Users/justin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # NFI what this does but it sounds good.
  home.preferXdgDirectories = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # System stuff
    coreutils
    python3

    # Shells
    bash
    fish
    nushell
    shellcheck
    shfmt
    zplug
    zsh
    starship
    spaceship-prompt

    # HTTP and networking
    curl
    httpie
    k6
    wget

    # Utilities
    atuin
    bat
    direnv
    doggo
    eza
    ffmpeg
    fzf
    jq
    just
    mise
    ncdu
    ripgrep
    ssh-copy-id
    yt-dlp

    # VCS stuff
    delta
    gh
    git
    gnupg
    jujutsu
    pinentry_mac

    # Monitoring
    htop
    btop

    # Tools
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.alpha
      google-cloud-sdk.components.beta
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
    xcodes
    k9s

    # Fonts
    hack-font
    ia-writer-duospace
    ia-writer-mono
    ia-writer-quattro
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  # Manage XDG config files.
  xdg.configFile = {
    atuin = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/atuin";
      recursive = true;
    };
    gh = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/gh";
      recursive = true;
    };
    git = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/git";
      recursive = true;
    };
    ghostty = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/ghostty";
      recursive = true;
    };
    jj = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/jj";
      recursive = true;
    };
    k9s = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/k9s";
      recursive = true;
    };
    nushell = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nushell";
      recursive = true;
    };
    zed = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/zed";
      recursive = true;
    };
    spaceship = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/spaceship";
      recursive = true;
    };
    sublime = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/sublime";
      recursive = true;
      onChange = ''
        DESTINATION="${config.home.homeDirectory}/Library/Application Support/Sublime Text/Packages/User"
        SOURCE="${config.xdg.configHome}/sublime"

        if ! [ -L "$DESTINATION" ]; then
            ln -sv "$SOURCE" "$DESTINATION" # Link does not exist, so create it...
        else
            echo "Symbolic link already exists at $DESTINATION."
        fi
      '';
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  #
  # For a lot of these I’m not going to lean _alll_ the way in to doing it the “nix way”
  # because of the overhead of doing everything via nix like that. Instead we’ll
  # symlink a bunch of stuff that is easier to edit in their native format.
  #
  # This technique is described in more detail here: https://seroperson.me/2024/01/16/managing-dotfiles-with-nix/
  home.file = {
    # ".bin" = {
    #   source = ../../.bin;
    #   recursive = true;
    # };

    # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
  };

  # Manage our session PATH.
  #
  # https://nix-community.github.io/home-manager/options.xhtml#opt-home.sessionPath
  home.sessionPath = [
    "${config.home.homeDirectory}/.bin"
    "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
  ];

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "subl -w";
    PAGER = "less -FXR"; # nix-darwin defaults this to `less -R` which sucks.
  };

  # https://github.com/nix-community/home-manager/tree/master/modules/programs
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    eza = {
      enable = true;
      git = true;
      icons = "never";
      extraOptions = [ "--group-directories-first" ];
      theme = builtins.fetchurl {
        url = "https://github.com/eza-community/eza-themes/blob/main/themes/catppuccin.yml";
        sha256 = "191mabxxhic6bcbs888wz369xhln5r6dxx32nspczn4q95326jb6";
      };
    };

    firefox = {
      enable = true;
      package = null; # Don’t actually manage the installation, just assume it’s there and configure it.

      # https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721/3
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = {
            "extensions.pocket.enabled" = false;
            "extensions.screenshots.disabled" = true;

            "browser.contentblocking.category" = "strict";
            "browser.aboutConfig.showWarning" = false;
            "browser.urlbar.ctrlCanonizesURLs" = false; # Allow command+enter to open tabs
          };
          search = {
            force = true;
            default = "Kagi";
            engines = {
              "Kagi" = {
                urls = [
                  {
                    template = "https://kagi.com/search?";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
              };
            };
          };
        };
      };
    };

    # https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh/default.nix
    zsh = {
      enable = true;
      dotDir = "${config.xdg.dataHome}/zsh";

      # Useful for debugging startup performance.
      # zprof.enable = true;

      # Environment variables that will be set for zsh session.
      sessionVariables = {
        PATH = "/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH";
      };

      initContent = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # eval "$(starship init zsh)"
      '';

      shellAliases = {
        ls = "ll";
        l = "eza -lAh";
        ll = "eza -l --git";
        la = "eza -A";

        # Git aliases
        s = "git status -sb $argv; return 0";

        # Jujutsu aliases
        j = "jj";
        js = "jj status";
        jt = "jj tug";
        jc = "jj commit";
        jci = "jj commit --interactive";
        jf = "jj fetch";
        jp = "jj push";
        jsq = "jj squash";
        jsqi = "jj squash --interactive";
      };

      history = {
        path = "${config.xdg.dataHome}/zsh/history";
        save = 10000;
        ignoreSpace = true;
      };

      zplug = {
        enable = true;
        zplugHome = "${config.xdg.dataHome}/zplug";

        plugins = [
          {
            name = "zsh-users/zsh-syntax-highlighting";
            tags = [ "defer:2" ];
          }
          {
            name = "zsh-users/zsh-history-substring-search";
            tags = [ "defer:3" ];
          }
          {
            name = "zsh-users/zsh-autosuggestions";
            tags = [ ];
          }
          {
            name = "zsh-users/zsh-completions";
            tags = [ ];
          }
          {
            name = "mafredri/zsh-async";
            tags = [
              "from:github"
              "use:async.zsh"
            ];
          }
          {
            name = "spaceship-prompt/spaceship-prompt";
            tags = [
              "from:github"
              "use:spaceship.zsh"
              "as:theme"
            ];
          }
        ];
      };
    };

    # https://github.com/nix-community/home-manager/blob/master/modules/programs/mise.nix
    mise = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      configPath = ".config/starship/starship.toml";
    };

    # https://github.com/nix-community/home-manager/blob/master/modules/programs/zoxide.nix
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # https://github.com/nix-community/home-manager/blob/master/modules/programs/atuin.nix
    atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      mise.enable = true;
      silent = false;
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      enableZshIntegration = true;
    };
  };
}
