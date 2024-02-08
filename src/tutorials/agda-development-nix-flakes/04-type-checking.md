## Type checking Agda Code with Nix

Let us now build our Agda package with Nix by creating a _derivation_.
Create `playground.nix` in the project root with the following contents,
explained below:

```nix
# In playground.nix:

{{#include ./agda-playground/playground.nix}}
```

The file contains a single Nix expression, namely a _function_
that takes one argument and returns a derivation.
This way of writing packages is called the `callPackage` [design pattern][callpackage-design-pattern],
and is used extensively throughout the `nixpkgs` package index.

The file contains the following:

1. The argument to the function; passed in from our main `flake.nix`.
   It is a single _attribute set_, and expected to contain keys `lib` and `agdaPackages`.
   The former contains some necessary helper functions;
   the latter is the collection of all Agda packages present in `nixpkgs`,
   together with some packaging utilities.

1. The final derivation containing our package, created by `agdaPackages.mkDerivation`.
   This function is a wrapper around the `nixpkgs`'s [`stdenv.mkDerivation`][stdenv].
   It takes an attribute set describing the package to be built.
   Some keys of this set are specific to Agda packages, others are passed on to `stdenv.mkDerivation`.

1. Some general information about the package: its name (`pname`) and version (`version`).
   These have no semantic meaning, they are here for human consumption.

1. The `src` key tells `mkDerivation` where to find the source files of our package.
   In its simplest form this would be `src = ./.;`, indicating that the source is the current directory (`.`).
   We opt to "clean" the source from files related to VCS etc.
   to avoid rebuilding when unrelated files change.
   Advanced filtering can be done via other `nixpkgs` [filtering functions][lib-sources],
   or even by [respecting your `.gitignore`][pkgs-gitignore].

1. `buildInputs` contains a list of dependencies necessary to build our library.
   For now we will depend on the [Agda standard library](https://github.com/agda/agda-stdlib),
   packaged in `nixpkgs` at `agdaPackages.standard-library`.
   Later we will see how to use libraries that require special Agda options
   (such as [Cubical Agda](./06-advanced-usage.md#cubical-agda-specifying-agda-options)),
   and how to use [custom revisions](./06-advanced-usage.md#overriding-libraries) of libraries.

1. The `everythingFile` contains the path to an Agda module that transitively
   `import`s all other modules that are meant to be part of our library,
   the _module index_.
   `mkDerivation` will run `agda` on this file, type checking all library modules in the process.
   Many Agda libraries take this approach, as Agda defines no manifest format for this purpose.

   See [below](#everythingagda-the-module-index) for a detailed explanation.

1. Some metadata.
   This is optional, but having a description is nice.
   Since our package is platform independent (or at least as independent as `agda` is),
   it is common courtesy to set `meta.platforms = lib.platforms.all`.

### `Everything.agda`: The module index

As mentioned before, `agdaPackages.mkDerivation` requires a single Agda module
importing all other modules that are meant to be part of a library.
We call this file the _module index_.

So far our "library" consists of a single module, `Playground/Hello.agda`.
Let's first add another module that uses the Agda standard library,
and then reference both of them in the module index.

Create a new module that uses the type of natural numbers from
the standard library:

```agda
-- In Playground/WithStdlib.agda:

{{#include ./agda-playground/Playground/WithStdlib.agda}}
```

Now, create module index at `Everything.agda` and `import` the modules:

```agda
-- In Everything.agda:

{{#include ./agda-playground/Everything.agda}}
```

### Building the derivation

Finally, we can build the derivation for the first time.
By default, `nix` will not print any output unless it encounters an error.
We pass `--print-build-logs` (_short_: `-L`) to instruct it to _please_ 🥺 tell us what it is doing:

```shellsession
$ nix build --print-build-logs
[...]
playground> building
playground> Checking Everything (/build/agda-playground/Everything.agda).
playground>  Checking Playground.Hello (/build/agda-playground/Playground/Hello.agda).
playground>  Checking Playground.WithStdlib (/build/agda-playground/Playground/WithStdlib.agda).
playground> installing
[...]
```

If we did everything correctly,
a symbolic link called `result` should appear in our working directory.
It points to the finished derivation, in the Nix store...

```shellsession
$ readlink result
/nix/store/[...]-playground-0.1.0
```

...and contains our library modules, including their corresponding
[interface files](https://agda.readthedocs.io/en/latest/tools/interface-files.html)
created by the type checking process:

```shellsession
$ nix-shell -p exa --run 'exa -T result/*'
result/Playground
├── Hello.agda
├── Hello.agdai
├── WithStdlib.agda
└── WithStdlib.agdai
result/playground.agda-lib
```

~~~admonish warning title="Warning: potential footgun"
Notice that in the file listing above, `result/Everything.agda` is missing.
By default, `agdaPackages.mkDerivation` will not include the module pointed to by
`everythingFile` (nor its interface file) in the final derivation.
This is by design, as oftentimes the `everythingFile` file is generated automatically
at build-time and not meant to be part of the distributed library.
Its only purpose is to serve as a module index.
~~~

Now, whenever we make a change to the Agda code, we'll have to re-run `nix build` to type check it.
This is cumbersome, and definitely not _interactive_ theorem proving.
In the next section we will learn how to create a shell with all of our library's
dependency available, so that we can use `agda` interactively as usual.

[callpackage-design-pattern]: https://nixos.org/guides/nix-pills/callpackage-design-pattern.html
[lib-sources]: https://nixos.org/manual/nixpkgs/stable/#sec-functions-library-sources
[pkgs-gitignore]: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-nix-gitignore
[stdenv]: https://nixos.org/manual/nixpkgs/stable/#chap-stdenv
