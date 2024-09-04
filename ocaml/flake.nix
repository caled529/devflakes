{
  description = "Basic flake for OCaml";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    devShells.${system} = {
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
  };
}
