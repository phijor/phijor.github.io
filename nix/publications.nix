{
  lib,
  stdenvNoCC,
  pandoc,
  name ? "publications",
  ...
}: let
  inherit (lib.fileset) toSource unions;
  src = toSource {
    root = ../src;
    fileset = unions [
      ../src/publications
      ../src/publications.md.in
    ];
  };
in
  stdenvNoCC.mkDerivation {
    inherit name src;
    nativeBuildInputs = [pandoc];
    buildPhase = ''
      mkdir -p $out
      pandoc \
        --from=markdown \
        --to=markdown_strict \
        --citeproc \
        publications.md.in \
        -o "$out/publications.md"
    '';
  }
