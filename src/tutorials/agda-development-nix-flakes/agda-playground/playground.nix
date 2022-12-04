{ agdaPackages
, lib
, ...
}:
agdaPackages.mkDerivation {
  pname = "playground";
  version = "0.1.0";
  src = builtins.path {
    path = lib.sources.cleanSource ./.;
    name = "agda-playground";
  };

  everythingFile = "./Playground/Hello.agda";
  buildInputs = [ agdaPackages.standard-library ];

  meta = {
    description = "An Agda playground 🛝";
    longDescription = ''
      A longer description of the package.

      Potentially spanning multiple lines.
    '';
    platforms = lib.platforms.all;
  };
}
