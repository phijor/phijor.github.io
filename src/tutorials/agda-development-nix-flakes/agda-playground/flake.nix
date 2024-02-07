# ANCHOR: all
{
  # 1.
  description = "An Agda Library set up with Nix Flakes";

  # 2.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # 3.
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    # 4.
    inherit (flake-utils.lib) simpleFlake defaultSystems;

    # 5.
    name = "playground";

    # 6.
    overlay = final: prev: {
      ${name} = {
        # 7.
        defaultPackage = final.callPackage ./playground.nix {};
      };
    };
  in
    # 8.
    simpleFlake {
      inherit self nixpkgs name overlay;
      systems = defaultSystems;

      # 9.
      # ANCHOR: shell
      shell = {pkgs}:
        pkgs.mkShell {
          inputsFrom = [pkgs.${name}.defaultPackage];
        };
      # ANCHOR_END: shell
    };
}
