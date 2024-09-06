{
  description = "Basic webdev flake";

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
        devShells = {
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
      });
}
