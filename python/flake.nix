{
  description = "Basic flake for Python";

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
            black
            pyright
            python3
          ];
        };
    };
  };
}
