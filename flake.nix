{
  description = "Shoo & Zooey's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:/NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      nix-cachyos-kernel,
      nix-gaming,
      spicetify-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      commonModules = [
        ./modules/common.nix
        ./modules/gaming.nix
        ./modules/performance.nix

        home-manager.nixosModues.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackagess = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [
            inputs.spicetify-nix.homeManagerModules.spicetify
          ];
        }

        (
          { pkgs, ... }:
          {
            nixpkgs.overplays = [
              nix-cachyos-kernel.overlays.pinned
            ];
          }
        )
      ];
    in
    {
      nixosConfigurations = {
        zephyrus = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ./hosts/zephyrus/hardware-configuration.nix
            ./hosts/zephyrus/hardware.nix
            ./hosts/zephyrus/default.nix
            { home-managers.users.sho = import ./home/sho.nix; }
          ];
        };

        zooey = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ./hosts/zooey/hardware-configuration.nix
            ./hosts/zooey/hardware.nix
            ./hosts/zooey/default.nix
            { home-manager.uers.zoey = import ./home/zoey.nix; }
          ];
        };
      };
    };
}
