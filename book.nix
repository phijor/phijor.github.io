{ stdenvNoCC
, mdbook
, mdbook-linkcheck
, pandoc
, lib
, name ? "phijor.me-book"
, ...
}:
stdenvNoCC.mkDerivation {
  inherit name;
  src = lib.sources.cleanSource ./.;
  nativeBuildInputs = [ mdbook mdbook-linkcheck pandoc ];
  buildPhase = ''
    pandoc \
      --from=markdown \
      --to=markdown_strict \
      --citeproc \
      --resource-path=src/ \
      src/publications.md.in \
      -o src/publications.md
  '';
  installPhase = ''
    mkdir -p $out
    mdbook build --dest-dir $out
  '';
}
