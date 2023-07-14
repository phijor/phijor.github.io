# Agda Development Setup with Nix Flakes

Dependency management is hard, and it is especially hard when working with Agda.
I oftentimes need access to mutually incompatible Agda libraries,
which is hard to achieve with how Agda currently handles dependency resolution.
Instead, I've been using the [Nix package manager][nix] to set up _declarative_
and _isolated_ development environments that provide their own (conflict-free)
version of Agda and any necessary Agda libraries.

Nix comes with a package repository – [`nixpkgs`][nixpkgs] –
which already contains packaging instructions for Agda and many libraries
of the ecosystem.
We'll be using a Nix _"Flake"_ to declare our dependencies and pin them to a specific,
working version.

Let's get started by [installing and configuring Nix](./agda-development-nix-flakes/01-installing-nix.md).

[nix]: https://nixos.org/
[nixpkgs]: https://nixos.wiki/wiki/Nixpkgs
