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
    overlay = final: prev: {
      python3 = prev.python3.override {
        packageOverrides = py-final: py-prev: {
          mdformat-footnote = py-prev.mdformat-footnote.overrideAttrs (old: {
            propagatedBuildInputs = old.buildInputs;
          });
        };
      };
      mdbook-external-links = final.callPackage ./nix/mdbook-external-links.nix { };
      ${name} = final.callPackages ./book.nix {};
    };
  in
    simpleFlake {
      inherit self nixpkgs name overlay;
      systems = defaultSystems;
    };
}
