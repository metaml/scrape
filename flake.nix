{
  description = "scrape";

  inputs = {
    nixpkgs      = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils  = { url = "github:numtide/flake-utils"; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-compat, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "scrape";
        ghc-version = "ghc963";
        pkgs = nixpkgs.legacyPackages.${system};
        hkgs = pkgs.haskell.packages.${ghc-version}; # "make update" first sometimes helps
        revision = "${self.lastModifiedDate}-${self.shortRev or "dirty"}";
      in rec {
        # nix develop
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            cacert
            git
            gmp
            hkgs.cabal-install
            hkgs.ghc
            hkgs.hlint
            sourceHighlight
            watchexec
            zlib.dev
          ];
          shellHook = ''
            export LANG=en_US.UTF-8
            export PS1="scrape|$PS1"
          '';
        };
      }
    );
}
