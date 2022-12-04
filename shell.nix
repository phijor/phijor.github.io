{ pkgs ? import <nixpkgs> }:
pkgs.mkShell {
  buildInputs = [
    pkgs.mdbook
    pkgs.python3Packages.mdformat
  ];
}
