{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    inherit (flake-utils.lib) simpleFlake defaultSystems;
    name = "phijor-me";
    overlay = final: prev: let
      book = final.callPackage ./book.nix {};
      devShell = final.mkShell {
        inputsFrom = [book];
        packages = [
          final.python3Packages.mdformat
        ];
      };
    in {
      ${name} = {
        inherit book devShell;
        defaultPackage = book;
      };
    };
  in
    simpleFlake {
      inherit self nixpkgs name overlay;
      systems = defaultSystems;
    };
}
