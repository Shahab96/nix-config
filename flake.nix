{
  description = "My NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";

    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    ...
  } @ inputs:
  let
    system = "x86_64-linux";
    host = "rihla";
    user = "shahab";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
           disko.nixosModules.disko
          ./nixos/configuration.nix
          ./nixos/disko-config.nix
          ./nixos/hardware-configuration.nix
        ];
        specialArgs = {
          inherit inputs;
          hostname = host;
        };
      };
    };

    homeConfigurations = {
      "${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}
