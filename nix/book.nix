{
  stdenvNoCC,
  mdbook,
  mdbook-admonish,
  mdbook-linkcheck,
  publications,
  lib,
  name ? "phijor.me-book",
  ...
}: let
  inherit (lib.fileset) toSource unions;
  src = toSource {
    root = ../.;
    fileset = unions [
      ../book.toml
      ../src
      ../theme
    ];
  };
in
  stdenvNoCC.mkDerivation {
    inherit name src;
    nativeBuildInputs = [
      mdbook
      mdbook-admonish
      mdbook-linkcheck
      publications
    ];
    buildPhase = ''
      ln -s ${publications}/publications.md src/
      mkdir -p $out
      mdbook build --dest-dir $out
    '';
  }
