{
  description = "Flake parts pointing to a whole.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";

    # PRE-COMMIT + LINTING
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    with inputs; let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # FORMATTER: enables `nix fmt`
      formatter.${system} = pkgs.alejandra;

      # NIXOS SYSTEM
      nixosConfigurations = {
        aurelius = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./system/configuration.nix
            nvf.nixosModules.default
          ];
        };
      };

      # HOME MANAGER
      homeConfigurations = {
        "n3to@aurelius" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {inherit inputs;};
          modules = [
            ./home-manager/home.nix
          ];
        };
      };
    };
}
