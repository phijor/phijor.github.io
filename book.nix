{
  stdenvNoCC,
  mdbook,
  lib,
  name ? "phijor.me-book",
  ...
}:
stdenvNoCC.mkDerivation {
  inherit name;
  src = lib.sources.cleanSource ./.;
  nativeBuildInputs = [mdbook];
  installPhase = ''
    mkdir -p $out
    mdbook build --dest-dir $out
  '';
}
