{
  description = "NixOS configurations for paul and constant (GNOME desktops)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Community packaging of Claude Desktop for Linux (not yet in nixpkgs).
    # Do NOT make this follow our nixpkgs — the package builds against an older
    # snapshot that still exposes `pkgs.nodePackages` (removed in unstable).
    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        paul = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.hostPlatform = system; }
            inputs.disko.nixosModules.disko
            ./modules/disko.nix
            ./hosts/paul/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };

        constant = nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.hostPlatform = system; }
            inputs.disko.nixosModules.disko
            ./modules/disko.nix
            ./hosts/constant/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
