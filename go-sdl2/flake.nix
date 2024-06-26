{
  description = "Go dev environment for sdl2";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    flake_name = "go-sdl2";
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
          PS1='[\t] \[\e[94m\]\u@devflakes.${flake_name}\[\e[0m\] \[\e[95m\]\W\[\e[0m\] \$ '
          go mod tidy
        '';
      };
  };
}
