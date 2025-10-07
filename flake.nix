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
          target = builtins.replaceStrings [ "darwin" ] [ "macos" ] system;
        in
        rec {
          default = capTUre;
          capTUre = pkgs.stdenvNoCC.mkDerivation {
            name = "capTUre";
            version = "master";
            meta.mainProgram = "capTUre";
            src = gitignore.lib.gitignoreSource ./.;
            nativeBuildInputs = [
              zig-overlay.packages.${system}.master
              pkgs.makeWrapper
            ];
            propagatedBuildInputs = [
              pkgs.ffmpeg
              pkgs.mpv
            ];
            dontInstall = true;
            doCheck = true;
            configurePhase = ''
              export ZIG_GLOBAL_CACHE_DIR=$TEMP/.cache
            '';
            buildPhase = ''
              PACKAGE_DIR=${pkgs.callPackage ./deps.nix { }}
              zig build install --system $PACKAGE_DIR -Dtarget=${target} -Doptimize=ReleaseSafe --color off --prefix $out
            '';
            postInstall = ''
              wrapProgram $out/bin/capTUre \
                --prefix PATH : ${
                  pkgs.lib.makeBinPath [
                    pkgs.ffmpeg
                    pkgs.mpv
                  ]
                }
            '';
            checkPhase = ''
              zig build test --system $PACKAGE_DIR -Dtarget=${target} --color off
            '';
          };
        }
      );
    };
}
