{
  description = "Basic flake for OCaml";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    with flake-utils.lib;
      eachSystem allSystems (system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      in {
        devShells.system = {
          default = with pkgs;
            mkShell {
              packages = [
                dune_3
                ocaml
                ocamlPackages.ocaml-lsp
                ocamlPackages.ocamlformat
              ];
            };
        };
      });
}
