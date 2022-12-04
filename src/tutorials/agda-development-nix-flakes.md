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

## Installing and Configuring Nix

Install Nix by following the [official installation instructions](https://nixos.org/download.html),
or by consulting your system's own package manager.
I use Arch Linux, so `pacman -Syu nix` is all I needed to do.
Test that your installation is working:

```shellsession
$ nix --version
nix (Nix) 2.11.0
```

...and that you can install packages, e.g. by spawning an ephemeral shell that has access
to the `hello` package:

```shellsession
$ # Spawning a shell with the hello package:
$ nix-shell --packages hello
[nix-shell:~]$ # Running the hello binary from inside a shell:
[nix-shell:~]$ hello
Hello, world!
[nix-shell:~]$ # The binary resides in the Nix Store:
[nix-shell:~]$ which hello
/nix/store/g2m8kfw7kpgpph05v2fxcx4d5an09hl3-hello-2.12.1/bin/hello
[nix-shell:~]$ exit
$ # No more hello binary outside of the shell:
$ which hello
hello not found
```

Nixpkgs provides a lot of packages;
you can either search the package index on the [web](https://search.nixos.org/packages) or locally:

```shellsession
$ nix-env --query --available -P 'agdaWithPackages'
nixpkgs.agda  agdaWithPackages-2.6.2.2
```

The above says that the package `agdaWithPackages` is available under the name `nixpkgs.agda`.
The Nix command line tools operate on `nixpkgs` by default, so running Agda is as simple as that:

```shellsession
$ nix-shell --packages 'agda' --run "agda --version"
Agda version 2.6.2.2
```

> ℹ️ **NOTE:**
>
> This might take some time as Nix will have to download Agda and its dependencies.
> Though it's definitely faster than compiling Agda yourself.

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

## Setting up Project Skeleton

In a first iteration, we will set up a basic project that contains some Agda code,
and add a Flake that describes how to...

1. install Agda and the Agda [standard library][agda-stdlib]
1. has instructions for type-checking our code

We'll call our project _Playground_.
First, create a new directory that will contain the project, and enter it:

```shellsession
$ mkdir agda-playground
$ cd agda-playground
```

In the following, we call this directory the _(project) root directory_.
If not stated otherwise, files are created and edited in the project root directory.

Next, create the module structure for our project:

```shellsession
$ mkdir Playground
$ touch Playground/Hello.agda
```

Open the Agda module `Playground/Hello.agda` in your preferred editor,
and enter the following code:

```agda
-- In Playground/Hello.Agda:
{{#include ./agda-development-nix-flakes/agda-playground/Playground/Hello.agda}}
```

You can re-use the shell from before and check whether Agda accepts the file:

```shellsession
$ nix-shell --packages 'agda' --run "agda Playground/Hello.agda"
Checking Playground.Hello (/tmp/agda-playground/Playground/Hello.agda).
```

To make sure that Agda recognizes our project as a library,
create an [Agda library file][agda-lib] `playground.agda-lib`:

```
-- In playground.agda-lib:
{{#include ./agda-development-nix-flakes/agda-playground/playground.agda-lib}}
```

Now, create and open the file `flake.nix`, and insert the following code
(explanation follows below):

```nix
# In flake.nix:
{{#include ./agda-development-nix-flakes/agda-playground/flake.nix}}
```

Every `flake.nix` consists of three attributes:
a description, some inputs and some outputs.
Let's go over them in detail:

1. `description` is a short human-readable string (duh).

1. `inputs` to the Flake are Nix expressions that are fetched from elsewhere.
   In our case, we fetch two inputs:

   - the `nixpkgs` package index from
     [Github](https://github.com/NixOS/nixpkgs/tree/nixpkgs-unstable),
     checking out the branch `nixpkgs-unstable`.
   - [`flake-utils`](https://github.com/numtide/flake-utils#readme),
     a self-contained library to help us write less boiler-plate code

1. `outputs` is a function from the inputs (as downloaded and stored in your system)
   to any number of build artifacts.
   We take `nixpkgs` and `flake-utils` as inputs (ignore `self` for now),
   and produce a package that contains our type-checked library and some other goodies.

1. We use a `let ... in ...`-expression to give names to values that we'll use later.
   First, we bring `simpleFlake` and `defaultSystems` into scope, ...

1. ...assign a name for later use...

1. ...and then create an [Overlay][nix-overlay] that contains one attribute `${name}`
   (i.e. `"playground"`).  Overlays are Nixpkgs's way of extending the package index
   by new packages or patching existing ones.

1. We assign an attribute set to the key `${name}` which contains one package
   built from a nix expressions in the file `./playground.nix`.
   This file contains the actual definition of our package, and we'll go over it [below](#type-checking-agda-with-nix).

1. To return the package in a format that `nix` expects,
   we use the library function `simpleFlake` to put our package together:
   We specify which snapshot of `nixpkgs` to use,
   what the name of our package is,
   which overlay to use (this contains our package),
   and which systems the package can be built for.

1. We set up a custom interactive shell that has access to all build dependencies of our package.
   See [below](#shell-environment-for-local-development) how to use it.

Now, we can run `nix build` and attempt the first build of our project.
Of course that will fail, but we can learn some things from the error message:

```shellsession
$ nix build
warning: creating lock file '/[...]/agda-playground/flake.lock'
error: getting status of '/nix/store/[...]-source/agda-playground/playground.nix': No such file or directory
(use '--show-trace' to show detailed location information)
```

1. `nix` created the `flake.lock` contaning snapshots of the inputs for us.
   It's a JSON file, so we can inspect it using [`jq`](https://stedolan.github.io/jq/):
   ```shellsession
   $ nix-shell -p 'jq' --run "jq '.nodes.nixpkgs.locked.rev' < flake.lock"
   "813836d64fa57285d108f0dbf2356457ccd304e3"
   ```
1. `nix` cannot find `playground.nix`.
   This is where our package description goes.

## Type-checking Agda with Nix

> 🚧 **TODO**:
>
> - explain how the Nix derivation `playground.nix` works.
> - build the package for the first time

```nix
# In playground.nix:

{{#include ./agda-development-nix-flakes/agda-playground/playground.nix}}
```

## Shell Environment for Local Development

> 🚧 **TODO**:
>
> - explain usage of Nix shells
> - set up auto-loading of Nix shell environments using `direnv`

## Advanced Usage

> 🚧 **TODO**:
>
> - `--cubical` Agda: specifying flags and installing `cubical`
> - overriding libraries: new versions, applying patches
> - more output derivations: HTML documentation?
> - CI setup _for free™_
> - Unicode weirdness: Unicode names in files and locale issues

[agda-lib]: https://agda.readthedocs.io/en/latest/tools/package-system.html#library-files
[agda-stdlib]: https://github.com/agda/agda-stdlib#readme
[cargo]: https://doc.rust-lang.org/stable/cargo/
[flake]: https://nixos.wiki/wiki/Flakes
[flake-enable]: https://nixos.wiki/wiki/Flakes#Enable_flakes
[nix]: https://nixos.org/
[nix-lang]: https://nixos.wiki/wiki/Overview_of_the_Nix_Language
[nix-lang-tut]: https://nixos.org/manual/nix/stable/#chap-writing-nix-expressions
[nix-overlay]: https://nixos.wiki/wiki/Overlays
[nix-pills]: https://nixos.org/guides/nix-pills/
[nixpkgs]: https://nixos.wiki/wiki/Nixpkgs
[stack]: https://docs.haskellstack.org/en/stable/
