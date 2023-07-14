## Pinning Dependencies Using Nix Flakes

To prevent the risk of installing software incompatible with our local code as the Nixpkgs changes over time,
we can use a Nix _Flake_ to pin the package index to a specific version.
This will ensure that we always use the same package index at a particular point in time.

A Nix [Flake] is a file `flake.nix`, containing code written in the [Nix Expression Language][nix-lang],
that declares a set of dependencies and contains build instructions for software using these dependencies.
When _pinning_ these dependencies,
permanent references (e.g. permalinks, Git hashes) are recorded in a file called `flake.lock`.
This is similar to how other language-specific package managers work:
[_Stack_][stack] has `stack.yaml` and pins dependencies in `stack.yaml.lock`,
[_Cargo_][cargo] records dependencies in `Cargo.toml` and
[pins](https://doc.rust-lang.org/stable/cargo/guide/cargo-toml-vs-cargo-lock.html) them in `Cargo.lock`.

> ⚠ **WARNING**:
>
> Nix Flakes are an unstable feature of Nix.
> Things might've changed slightly since this tutorial was written.
>
> In any case: Head over to the Wiki for instructions on how to [enable Nix Flakes][flake-enable].

> ℹ️ **NOTE:**
>
> This is not a tutorial on the Nix Language.
> Feel free to familiarize yourself with the language by either reading the superb
> [Nix Pills][nix-pills] series of tutorials,
> or [Chapter on writing Nix expressions][nix-lang-tut] of the Nix manual.

[cargo]: https://doc.rust-lang.org/stable/cargo/
[flake]: https://nixos.wiki/wiki/Flakes
[flake-enable]: https://nixos.wiki/wiki/Flakes#Enable_flakes
[nix-lang]: https://nixos.wiki/wiki/Overview_of_the_Nix_Language
[nix-lang-tut]: https://nixos.org/manual/nix/stable/#chap-writing-nix-expressions
[nix-pills]: https://nixos.org/guides/nix-pills/
[stack]: https://docs.haskellstack.org/en/stable/