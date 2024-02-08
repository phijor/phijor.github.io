{
  mkShell,
  callPackage,
  python3,
  lib,
  name ? "phijor.me-book",
  ...
}: let
  publications = callPackage ./publications.nix {
    name = "${name}-publications";
  };
  book = callPackage ./book.nix {
    inherit name publications;
  };
  mdformat = python3.withPackages (p: [
    (p.mdformat.withPlugins [p.mdformat-footnote])
  ]);
  devShell = mkShell {
    inputsFrom = [book];
    packages = [mdformat];
  };
in {
  inherit publications book mdformat devShell;
  defaultPackage = book;
}
