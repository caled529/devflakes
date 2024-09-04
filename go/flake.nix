{
  description = "Development shells for golang";

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
    devShells.${system} = with pkgs; {
      default = mkShell {
        packages = [
          go
          gopls
        ];
        shellHook = ''
          go mod tidy
        '';
      };

      sdl2 = mkShell {
        packages = [
          go
          gopls
          pkg-config
          SDL2
          SDL2_gfx
          SDL2_image
          SDL2_mixer
          SDL2_net
          SDL2_sound
          SDL2_ttf
        ];
        shellHook = ''
          go mod tidy
        '';
      };

      db = mkShell {
        packages = [
          delve
          go
          gopls
        ];
        shellHook = ''
          go mod tidy
          # Want to allow for the debugger to attach to running go programs
          # Currently these commands are not permitted due to rofs limitations
          sudo setcap cap_sys_ptrace=ep ${pkgs.go}/share/go/bin/go
          sudo setcap cap_sys_ptrace=ep ${pkgs.delve}/bin/.dlv-wrapped
        '';
      };
    };
  };
}
