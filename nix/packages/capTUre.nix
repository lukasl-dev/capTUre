{
  stdenvNoCC,
  lib,
  gitignore,
  zig-overlay,
  makeWrapper,
  ffmpeg,
  mpv,
  callPackage,
  ...
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  target = builtins.replaceStrings [ "darwin" ] [ "macos" ] system;
  depsPackage = callPackage ../../deps.nix { };
  zigMaster = zig-overlay.packages.${system}.master;
in
stdenvNoCC.mkDerivation {
  name = "capTUre";
  version = "master";
  meta.mainProgram = "capTUre";
  src = gitignore.lib.gitignoreSource ../../.;
  nativeBuildInputs = [
    zigMaster
    makeWrapper
  ];
  propagatedBuildInputs = [
    ffmpeg
    mpv
  ];
  dontInstall = true;
  doCheck = true;
  configurePhase = ''
    export ZIG_GLOBAL_CACHE_DIR=$TEMP/.cache
  '';
  buildPhase = ''
    zig build install --system ${depsPackage} -Dtarget=${target} -Doptimize=ReleaseSafe --color off --prefix $out
  '';
  postInstall = ''
    wrapProgram $out/bin/capTUre \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          mpv
        ]
      }
  '';
  checkPhase = ''
    zig build test --system ${depsPackage} -Dtarget=${target} --color off
  '';
}
