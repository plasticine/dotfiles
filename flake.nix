{
  description = "@plasticine flavoured dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
        alejandra

        dnsmasq
      ];

      # Turn off nix-darwin’s management of the Nix installation. This is required for determinate nix.
      nix.enable = false;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # Allow stuff with unfree licenses.
      nixpkgs.config.allowUnfree = true;

      # TODO: This is only required for x86, should make it opt in
      nixpkgs.config.allowBroken = true;

      # When a conflicting file is in the way move it using this extension.
      home-manager.backupFileExtension = "home-manager-backup";

      # More data!
      home-manager.verbose = true;
    };

    mkDarwinSystem = system: nix-darwin.lib.darwinSystem {
      inherit system;

      specialArgs = { inherit inputs; };

      modules = [
        configuration
        ./modules/darwin
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
          home-manager.users.justin = import ./modules/home-manager;
        }
      ];
    };
  in
  {
    # Build darwin flake using:
    #
    #   darwin-rebuild build --flake .#fer-nespresso
    #
    darwinConfigurations = {
      Bean = mkDarwinSystem "x86_64-darwin";
      ristretto = mkDarwinSystem "aarch64-darwin";
    };
  };
}
