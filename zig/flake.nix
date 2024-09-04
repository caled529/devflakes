{
  description = "Development shells for zig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    zig,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    devShells.${system} = with pkgs; {
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
  };
}
