{ stdenvNoCC
, mkShell
, mdbook
, mdbook-admonish
, mdbook-linkcheck
, mdformat
, pandoc
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
  };
  mdformat' = mdformat.withPlugins (p: [ p.mdformat-footnote ]);
  devShell = mkShell {
    inputsFrom = [ book ];
    packages = [ mdformat' ];
  };
in
{
  inherit publications book mdformat' devShell;
  defaultPackage = book;
}
