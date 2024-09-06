{
  description = "Basic flake template";

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
    # Allows the flake to work on all systems
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
                # Put any of the packages you need for your environment in here.
                # This includes compilers, LSPs, formatters, and anything else
                # specific to working in this environment.
              ];
              # Any commands you want to run when you start your environment go here.
              shellHook = '''';
            };
        };
      });
}
