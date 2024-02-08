{
  mkShell,
  callPackage,
  python3,
  mdformat,
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
  mdformatWithPlugins = mdformat.withPlugins (p: [p.mdformat-footnote]);
  devShell = mkShell {
    inputsFrom = [book];
    packages = [mdformatWithPlugins];
  };
in {
  inherit publications book mdformatWithPlugins devShell;
  defaultPackage = book;
}
