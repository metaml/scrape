.DEFAULT_GOAL = build

export SHELL := /bin/sh
export NIX_REMOTE = daemon

PROJECT ?= ${HOME}/${LOGNAME}/p/scrape
PWD     := $(shell pwd)

BIN ?= scrape

build: ## build (default)
	cabal build --jobs='$$ncpus' $(CABARGS) 2>&1 \
	| source-highlight --src-lang=haskell --out-format=esc

buildc: # clean ## build continuously
	watchexec --exts cabal,hs --  cabal build --jobs '$$ncpus' $(CABARGS) 2>&1 \
	| source-highlight --src-lang=haskell --out-format=esc

install: clobber build # install binary
	cabal install $(CABARGS)  --overwrite-policy=always --install-method=copy --installdir=bin

dev: ## nix develop
	nix develop

test: ## test
	cabal $(OPT) test

lint: ## lint
	hlint app src

clean: ## clean
	-cabal clean
	-find . -name \*~ | xargs rm -f

clobber: clean ## clobber
	rm -rf dist-newstyle/*

run: ## run BIN, e.g. make run BIN=<binary>
	cabal run $(BIN) -- $(ARG)

#repl: export GOOGLE_APPLICATION_CREDENTIALS ?= /Users/milee/.zulu/lpgprj-gss-p-ctrlog-gl-01-c0096aaa9469.json
repl: ## repl
	cabal repl

help: ## help
	-@grep --extended-regexp '^[0-9A-Za-z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | sed 's/^Makefile://1' \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
	-@ghc --version
	-@cabal --version
	-@hlint --version

update: ## update nix and cabal project dependencies
update: flake-update cabal-update

cabal-update: ## update cabal project depedencies
	nix develop \
	&& cabal update \
	&& exit

flake-update: ## update nix and project dependencies
	nix flake update

