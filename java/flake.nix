{
  description = "Basic Java development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    flake_name = "java";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    devShells.${system}.default = with pkgs; {
      mkShell = {
        packages = [
          jdk21
          jdt-language-server
        ];
        shellHook = ''
          PS1='[\t] \[\e[94m\]\u@devflakes.${flake_name}\[\e[0m\] \[\e[95m\]\W\[\e[0m\] \$ '
          export JDTLS_STORE_PATH="${pkgs.jdt-language-server}"
          mkdir -p jdtls/data ~/.language-servers/jdtls/config
          export JDTLS_CONFIG_DIR=$(readlink -f ~/.language-servers/jdtls/config)
          export JDTLS_DATA_DIR=$(readlink -f ./jdtls)
          alias javac="javac -sourcepath src -d out"
          alias java="java -cp out"
          alias jrun='function _run(){ javac src/$1.java; java $1; };_run'
        '';
      };
    };
  };
}
