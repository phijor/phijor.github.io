{ lib, rustPlatform, fetchCrate, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-external-links";
  version = "0.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-nZ2GpuEEOHmyxsm5VI4rIvYX1LhpiyQD2P2dWy33+Ts=";
  };

  cargoHash = "sha256-BbgVqsUPLKZnpU0xchFj4nWEZ8o1pDujxuUYJJVIBVE=";

  meta = with lib; {
    description = "Open external links inside your mdBooks in a different tab";
    homepage = "https://github.com/jonahgoldwastaken/${pname}";
    license = [ licenses.mpl20 ];
  };
}
