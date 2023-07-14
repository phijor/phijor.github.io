{ pkgs ? import <nixpkgs> }:
pkgs.mkShell {
  packages = [
    pkgs.mdbook
    pkgs.mdbook-linkcheck
    pkgs.python3Packages.mdformat
  ];
}
