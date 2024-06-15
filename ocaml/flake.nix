{
  description = "Basic flake for OCaml";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    flake_name = "ocaml";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    devShells.${system}.default = with pkgs;
      mkShell {
        packages = [
          dune_3
          ocaml
          ocamlPackages.ocaml-lsp
          ocamlPackages.ocamlformat
        ];
        shellHook = ''
          PS1='[\t] \[\e[94m\]\u@devflakes.${flake_name}\[\e[0m\] \[\e[95m\]\W\[\e[0m\] \$ '
          eval "$(${pkgs.zoxide}/bin/zoxide init bash --cmd cd)"
        '';
      };
  };
}
