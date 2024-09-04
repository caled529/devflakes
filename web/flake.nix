{
  description = "Basic webdev flake";

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
            eslint_d
            nodejs_22
            nodePackages.eslint
            nodePackages.live-server
            prettierd
          ];
          shellHook = ''
            eslint_d start
            trap 'eslint_d stop' EXIT
            prettierd start
            trap 'prettierd stop' EXIT
          '';
        };
    };
  };
}
