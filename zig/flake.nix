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
    devShells.${system}.default = with pkgs; let
      name = "zig";
    in
      mkShell {
        packages = [
          zig
          zls
        ];
        shellHook = ''
          PS1='[\t] \[\e[94m\]\u@devflakes.${name}\[\e[0m\] \[\e[95m\]\W\[\e[0m\] \$ '
        '';
      };

    devShells.${system}.dev = with pkgs; let
      name = "zig-dev";
    in
      mkShell {
        packages = [
          zig.overlays
          zls
        ];
        shellHook = ''
          PS1='[\t] \[\e[94m\]\u@devflakes.${name}\[\e[0m\] \[\e[95m\]\W\[\e[0m\] \$ '
        '';
      };
  };
}
