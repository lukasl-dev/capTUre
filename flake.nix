{
  description = "onyx";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    zig-overlay.url = "github:mitchellh/zig-overlay";
    zls = {
      url = "github:zigtools/zls";
      inputs.zig-overlay.follows = "zig-overlay";
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      zig-overlay,
      zls,
      gitignore,
    }:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      devShells = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              zig-overlay.packages.${system}.master
              zls.packages.${system}.zls
              pkgs.ffmpeg
              pkgs.mpv
            ];
          };
        }
      );

      packages = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        rec {
          default = capTUre;
          capTUre = pkgs.callPackage ./nix/packages/capTUre.nix {
            inherit gitignore zig-overlay;
          };
        }
      );

      nixosModules = rec {
        default = capTUre;
        capTUre = import ./nix/nixosModules/default.nix self;
      };
    };
}
