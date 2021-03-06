# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ haskellPackages ? (import <nixpkgs> {}).haskellPackages }:
let 
  inherit (haskellPackages) cabal MonadCatchIOTransformers mtl snapCore snapServer
          snapletPostgresqlSimple postgresqlSimple
  ;
in cabal.mkDerivation (self: {
  pname = "projectomatic";
  version = "0.1";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    MonadCatchIOTransformers mtl snapCore snapServer
    snapletPostgresqlSimple postgresqlSimple
  ];
  meta = {
    description = "Project Synopsis Here";
    license = self.stdenv.lib.licenses.unfree;
    platforms = self.ghc.meta.platforms;
  };
})
