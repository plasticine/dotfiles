{
  pkgs,
  config,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # System stuff
    coreutils

    # Shells
    nushell
    fish
    zsh
    zplug
    bash

    # HTTP and networking
    curl
    wget
    httpie

    # Utilities
    jq
    fzf
    just
    eza
    ssh-copy-id
    atuin
    mise
    direnv

    # VCS stuff
    gh
    jujutsu
    git
    pinentry_mac

    # Monitoring
    htop
    btop

    # Tools
    google-cloud-sdk
    k9s

    # Fonts
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  # Manage XDG config files.
  xdg.configFile = {
    atuin = {
      source = config.lib.file.mkOutOfStoreSymlink ../.config/atuin;
      recursive = true;
    };
    ghostty = {
      source = config.lib.file.mkOutOfStoreSymlink ../.config/ghostty;
      recursive = true;
    };
    jj = {
      source = config.lib.file.mkOutOfStoreSymlink ../.config/jj;
      recursive = true;
    };
    k9s = {
      source = config.lib.file.mkOutOfStoreSymlink ../.config/k9s;
      recursive = true;
    };
    nushell = {
      source = config.lib.file.mkOutOfStoreSymlink ../.config/nushell;
      recursive = true;
    };
    zed = {
      source = config.lib.file.mkOutOfStoreSymlink ../.config/zed;
      recursive = true;
    };
    # zsh = {
    #   source = config.lib.file.mkOutOfStoreSymlink ../.config/zsh;
    #   recursive = true;
    # };
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
    ".bin" = {
      source = ../.bin;
      recursive = true;
    };

    # ".bin/git_prompt" = ../../zsh/bin/git_prompt;

    # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # Ghostty
    # ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/zsh/.zshenv";

    # ".config/ghostty/config/themes/Catppuccin-Latte".text = /ghostty/.config/ghostty/config/themes/Catppuccin-Latte;
    # ".config/ghostty/config/themes/Catppuccin-Macchiato".text = /ghostty/.config/ghostty/config/themes/Catppuccin-Macchiato;
  };

  # Manage our session PATH.
  home.sessionPath = [
    "${config.home.homeDirectory}/.bin"
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
    EDITOR = "subl";
    PAGER = "less -FXR"; # nix-darwin defaults this to `less -R` which sucks.
  };

  # https://github.com/nix-community/home-manager/tree/master/modules/programs
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable
    zsh = {
      enable = true;
      dotDir = "${config.xdg.dataHome}/zsh";

      # Useful for debugging startup performance.
      # zprof.enable = true;

      # Environment variables that will be set for zsh session.
      sessionVariables = {};

      # Plugins to load in.
      plugins = [
        {
          name = "prompt";
          file = "prompt.zsh";
          src = ../zsh/.config/zsh;
        }
      ];

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
            tags = ["defer:2"];
          }
          {
            name = "zsh-users/zsh-history-substring-search";
            tags = ["defer:3"];
          }
          {
            name = "zsh-users/zsh-autosuggestions";
            tags = [];
          }
          {
            name = "zsh-users/zsh-completions";
            tags = [];
          }
          {
            name = "mafredri/zsh-async";
            tags = ["defer:0"];
          }
        ];
      };
    };
  };
}
