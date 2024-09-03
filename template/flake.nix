{
  description = "Basic flake template";

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
      name = "template";
    in
      mkShell {
        packages = [
          # Put any of the packages you need for your environment in here.
          # This includes compilers, LSPs, formatters, and anything else
          # specific to working in this environment.
        ];

        # Any commands you want to run when you start your environment go here.
        shellHook = ''
          PS1='[\t] \[\e[94m\]\u@devflakes.${name}\[\e[0m\] \[\e[95m\]\W\[\e[0m\] \$ '
        '';
      };
  };
}
