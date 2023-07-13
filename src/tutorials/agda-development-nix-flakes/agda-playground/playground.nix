# 1.
{ agdaPackages
, lib
, ...
}:
# 2.
agdaPackages.mkDerivation {
  # 3.
  pname = "playground";
  version = "0.1.0";

  # 4.
  src = builtins.path {
    path = lib.sources.cleanSource ./.;
    name = "agda-playground";
  };

  # 5.
  buildInputs = [ agdaPackages.standard-library ];

  # 6.
  everythingFile = "./Everything.agda";

  # 7.
  meta = {
    description = "An Agda playground 🛝";
    longDescription = ''
      A longer description of the package.

      Potentially spanning multiple lines.
    '';
    platforms = lib.platforms.all;
  };
}
