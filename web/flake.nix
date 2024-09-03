{
  description = "Basic webdev flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    # The name used to distinguish which devflake you're using from the prompt
    flake_name = "webdev";
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
          eslint_d
          nodejs_22
          nodePackages.eslint
          nodePackages.live-server
          prettierd
        ];

        shellHook = ''
          PS1='[\t] \[\e[94m\]\u@devflakes.${flake_name}\[\e[0m\] \[\e[95m\]\W\[\e[0m\] \$ '
          eslint_d start
          trap 'eslint_d stop' EXIT
          prettierd start
          trap 'prettierd stop' EXIT
        '';
      };
  };
}
