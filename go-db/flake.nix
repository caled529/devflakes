{
  description = "Go dev environment for sdl2";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    flake_name = "go-db";
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
          delve
          go
          gopls
        ];
        shellHook = ''
          PS1='[\t] \[\e[94m\]\u@devflakes.${flake_name}\[\e[0m\] \[\e[95m\]\W\[\e[0m\] \$ '
          go mod tidy
          # Want to allow for the debugger to attach to running go programs for stdin
          # Currently these commands are not permitted due to rofs limitations
          sudo setcap cap_sys_ptrace=ep ${pkgs.go}/share/go/bin/go
          sudo setcap cap_sys_ptrace=ep ${pkgs.delve}/bin/.dlv-wrapped
        '';
      };
  };
}
