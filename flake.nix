{
  description = "My NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland cachix flake
    hyprland.url = "github:hyprwm/Hyprland";

    # NixOS community managed hardware specific features/fixes
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Sops
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    lanzaboote,
    nixos-hardware,
    sops-nix,
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
          lanzaboote.nixosModules.lanzaboote
          disko.nixosModules.disko
          nixos-hardware.nixosModules.framework-13-7040-amd
          sops-nix.nixosModules.sops
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

    devShell.x86_64-linux = pkgs.mkShell {
      buildInputs = with pkgs; [
        # Adding node for copilot
        nodejs_20
        nil
      ];
    };
  };
}
