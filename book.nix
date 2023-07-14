{ stdenvNoCC
, mdbook
, mdbook-linkcheck
, lib
, name ? "phijor.me-book"
, ...
}:
stdenvNoCC.mkDerivation {
  inherit name;
  src = lib.sources.cleanSource ./.;
  nativeBuildInputs = [ mdbook mdbook-linkcheck ];
  installPhase = ''
    mkdir -p $out
    mdbook build --dest-dir $out
  '';
}
