## Setting up a Project Skeleton

In a first iteration, we will set up a basic project that contains some Agda code,
and add a Flake that...

1. Describes how to install Agda and the Agda [standard library][agda-stdlib].
1. Has instructions for type-checking our code.

We'll call our project _Playground_.
First, create a new directory that will contain the project, and enter it:

```shellsession
$ mkdir agda-playground
$ cd agda-playground
```

In the following, we call this directory the _(project) root directory_.
If not stated otherwise, files are created and edited in the project root directory.

Next, we create the module structure for our project:

```shellsession
$ mkdir Playground
$ touch Playground/Hello.agda
```

Open the Agda module `Playground/Hello.agda` in your preferred editor,
and enter the following code:

```agda
-- In Playground/Hello.Agda:
{{#include ./agda-playground/Playground/Hello.agda}}
```

You can re-use the shell from before and check whether Agda accepts the file:

```shellsession
$ nix-shell --packages 'agda' --run "agda --no-libraries Playground/Hello.agda"
Checking Playground.Hello (/tmp/agda-playground/Playground/Hello.agda).
```

We pass `--no-libraries` to temporarily ensure that Agda treats `Hello.agda` as a stand-alone module,
without any library dependencies.
In order to later specify dependencies we set up a proper Agda library,
defined in a [library file][agda-lib].
Create `playground.agda-lib` and enter the following:

```
-- In playground.agda-lib:

{{#include ./agda-playground/playground.agda-lib}}
```

Now, create and open the file `flake.nix`, and insert the following code
(explanation follows below):

```nix
# In flake.nix:
{{#include ./agda-playground/flake.nix:all}}
```

Every `flake.nix` consists of three attributes:
a description, some inputs and some outputs.
Let's go over them in detail:

1. `description` is a short human-readable string (duh).

1. `inputs` to the Flake are Nix expressions that are fetched from elsewhere.
   In our case, we fetch two inputs:

   - The `nixpkgs` package index from
     [GitHub](https://github.com/NixOS/nixpkgs/tree/nixpkgs-unstable),
     checking out the branch `nixpkgs-unstable`.
   - [flake-utils](https://github.com/numtide/flake-utils#readme),
     a self-contained library to help us write less boilerplate code.

1. `outputs` is a function from the inputs (as downloaded and stored in your system)
   to any number of build artifacts.
   We take `nixpkgs` and `flake-utils` as inputs (ignore `self` for now),
   and produce a package that contains our type-checked library and some other goodies.

1. We use a `let ... in ...`-expression to give names to values that we'll use later.
   First, we bring `simpleFlake` and `defaultSystems` into scope, ...

1. ...assign a name for later use...

1. ...and then create an [Overlay][nix-overlay] that contains one attribute `${name}`
   (i.e. `"playground"`).  Overlays are `nixpkgs`'s way of extending the package index
   with new packages or patching existing ones.

1. We assign an attribute set to the key `${name}` which contains one package
   built from a Nix expression in the file `./playground.nix`.
   This file contains the actual definition of our package, and we'll go over it [later](./04-type-checking.md).

1. To return the package in a format that `nix` expects,
   we use the library function `simpleFlake` that puts our package together:
   We specify which snapshot of `nixpkgs` to use,
   what the name of our package is,
   which overlay to use (this contains our package),
   and which systems the package can be built for.
   In turn, `simpleFlake` returns an output in the correct format.

1. We set up a custom interactive shell that has access to all build dependencies of our package.
   We will discuss how to use it in a [later chapter](./05-dev-shell.md).

Now, we can run `nix build` and attempt the first build of our project.
Of course that will fail, but we can learn some things from the error message:

```shellsession
$ nix build
warning: creating lock file '/[...]/agda-playground/flake.lock'
error: getting status of '/nix/store/[...]-source/agda-playground/playground.nix': No such file or directory
(use '--show-trace' to show detailed location information)
```

1. `nix` created the `flake.lock` containing snapshots of the inputs for us.
   It's a JSON file, so we can inspect it using [`jq`](https://stedolan.github.io/jq/):
   ```shellsession
   $ nix-shell -p 'jq' --run "jq '.nodes.nixpkgs.locked.rev' < flake.lock"
   "813836d64fa57285d108f0dbf2356457ccd304e3"
   ```
1. `nix` cannot find `playground.nix`.
   This is where our package description goes.

Next, let us put together a Nix package for our Agda project in `playground.nix`.

[agda-lib]: https://agda.readthedocs.io/en/latest/tools/package-system.html#library-files
[agda-stdlib]: https://github.com/agda/agda-stdlib#readme
[nix-overlay]: https://nixos.wiki/wiki/Overlays
