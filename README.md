# projectomatic
Sample application with Haskell Snap, PostgreSQL, and the PostgreSQL Simple Snaplet made by Janrain (http://janrain.com/blog/tutorial-building-a-sample-application-with-haskell-snap-postgresql-and-the-postgresql-simple-snaplet/).
Built process made by Fluffynukeit (http://fluffynukeit.com/setting-up-a-haskell-project-on-nixos/).

## Prerequisites
- ghc
- cabal
- nix
- snap
- postgreSQL

## Steps
```shell
mkdir projectomatic
snap init barebones
projectomatic -p 8000
curl http://0.0.0.0:8000 # Hello World
cabal2nix projectomatic.cabal > default.nix
change default.nix file header
export NIXPKGS_ALLOW_UNFREE=1;
change bla256 by src=./.;
nix-build
result/bin/projectomatic -p 8000
curl http://0.0.0.0:8000
```


## Build
nix-build

## Run
result/bin/projectomatic -p 3000
