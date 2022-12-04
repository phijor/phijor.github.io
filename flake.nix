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
    in {
      ${name} = {
        inherit book;
        defaultPackage = book;
      };
    };
  in
    simpleFlake {
      inherit self nixpkgs name overlay;
      systems = defaultSystems;
      shell = ./shell.nix;
    };
}
