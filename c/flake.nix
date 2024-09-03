{
  description = "Shells for C";

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
    devShells.${system}.default = with pkgs; let
      # The name used to distinguish which shell you're using from the prompt
      name = "c";
    in
      mkShell {
        packages = [
          clang-tools
        ];
        shellHook = ''
          PS1='[\t] \[\e[94m\]\u@devflakes.${name}\[\e[0m\] \[\e[95m\]\W\[\e[0m\] \$ '
        '';
      };
  };
}
