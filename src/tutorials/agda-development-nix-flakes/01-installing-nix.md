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

```admonish note
It might take some time as Nix will have to download Agda and its dependencies.
Though it's definitely faster than compiling Agda yourself.
```
