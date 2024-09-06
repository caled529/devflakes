{
  description = "Development shells for zig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zig.url = "github:mitchellh/zig-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    zig,
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
        devShells.system = with pkgs; {
          default = mkShell {
            packages = [
              zig
              zls
            ];
          };

          dev = mkShell {
            packages = [
              zig.lastModified
              zls
            ];
          };
        };
      });
}
