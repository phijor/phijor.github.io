{ stdenvNoCC
, mkShell
, mdbook
, mdbook-linkcheck
, pandoc
, python3Packages
, lib
, name ? "phijor.me-book"
, ...
}:
let
  publications-name = "${name}-publications";
  publications = stdenvNoCC.mkDerivation {
    name = publications-name;
    src =
      let
        inherit (lib.fileset) toSource unions;
      in
      toSource {
        root = ./src;
        fileset = unions [
          ./src/publications
          ./src/publications.md.in
        ];
      };
    nativeBuildInputs = [ pandoc ];
    buildPhase = ''
      mkdir -p $out
      pandoc \
        --from=markdown \
        --to=markdown_strict \
        --citeproc \
        publications.md.in \
        -o "$out/publications.md"
    '';
  };
  book = stdenvNoCC.mkDerivation {
    inherit name;
    src = lib.sources.cleanSource ./.;
    nativeBuildInputs = [ mdbook mdbook-linkcheck publications ];
    buildPhase = ''
      ln -s ${publications}/publications.md src/
      mkdir -p $out
      mdbook build --dest-dir $out
    '';
  };
  devShell = mkShell {
    inputsFrom = [ book ];
    packages = [
      python3Packages.mdformat
    ];
  };
in
{
  inherit publications book devShell;
  defaultPackage = book;
}
