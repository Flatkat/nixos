{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config = {allowUnfree = true;};
    };
    scanPaths = path:
      builtins.map
      (f: (path + "/${f}"))
      (builtins.attrNames
        (nixpkgs.lib.attrsets.filterAttrs
          (
            path: _type:
              (_type == "directory") # include directories
              || (
                (path != "default.nix") # ignore default.nix
                && (nixpkgs.lib.strings.hasSuffix ".nix" path) # include .nix files
              )
          )
          (builtins.readDir path)));
    specialArgs = {
      unstable = unstable;
      scanPaths = scanPaths;
      self = self;
    };
    zen-browser = inputs.zen-browser.packages."${system}".default;
    custom-pkgs = {inherit zen-browser;};
  in {
    nixosConfigurations = {
      timber-hearth = nixpkgs.lib.nixosSystem {
        modules = [
          ./systems/timber-hearth
          ./options
          inputs.lanzaboote.nixosModules.lanzaboote
        ];
        specialArgs = specialArgs // {inherit custom-pkgs;};
      };
    };
  };
}
