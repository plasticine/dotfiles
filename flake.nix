{
  description = "@plasticine flavoured dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # dotfiles.url = "github:plasticine/dotfiles";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
    nixpkgs,
  }: let
    configuration = {pkgs, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        vim

        # nix tooling
        nil
        nixd
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Allow stuff with unfree licenses.
      nixpkgs.config.allowUnfree = true;

      # When a conflicting file is in the way move it using this extension.
      home-manager.backupFileExtension = "home-manager-backup";
    };

    defaultSystem = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit inputs;};
      modules = [
        configuration
        ./modules/system.nix
        ./modules/apps.nix
        home-manager.darwinModules.home-manager
        {
          # When enabled, Home Manager will use pkgs from the system configuration
          # rather than creating a separate instance. This saves memory and ensures
          # package versions are consistent between system and home configurations.
          home-manager.useGlobalPkgs = true;

          # When enabled, Home Manager will install user packages to the user's profile
          # at /etc/profiles/per-user/$USER instead of ~/.nix-profile. This is useful
          # for nix-darwin integration as it allows the system to manage user packages.
          home-manager.useUserPackages = true;

          # Hey, that’s me!
          users.users.justin.name = "justin";
          users.users.justin.home = "/Users/justin";
          home-manager.users.justin = import ./home-manager;
        }
      ];
    };
  in {
    # Build darwin flake using:
    #
    #   darwin-rebuild build --flake .#fer-nespresso
    #
    darwinConfigurations = {
      fer-nespresso = defaultSystem;
      fer-cortado = defaultSystem;
    };
  };
}
