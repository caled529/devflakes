{
  description = "Basic Java development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
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
        devShells = with pkgs; {
          default = mkShell {
            packages = [
              jdk
              jdt-language-server
            ];
            shellHook = ''
              # Environment variables needed by my jdtls config for neovim on nixos
              export JDTLS_STORE_PATH="${pkgs.jdt-language-server}"
              mkdir -p jdtls/data ~/.language-servers/jdtls/config
              export JDTLS_CONFIG_DIR=$(readlink -f ~/.language-servers/jdtls/config)
              export JDTLS_DATA_DIR=$(readlink -f ./jdtls)
              # Nice aliases when working without a build system for java
              alias javac="javac -sourcepath src -d out"
              alias java="java -cp out"
              alias jrun='function _run(){ javac src/$1.java; java $1; };_run'
            '';
          };

          "22" = mkShell {
            packages = [
              jdk22
              jdt-language-server
            ];
            shellHook = ''
              # Environment variables needed by my jdtls config for neovim on nixos
              export JDTLS_STORE_PATH="${pkgs.jdt-language-server}"
              mkdir -p jdtls/data ~/.language-servers/jdtls/config
              export JDTLS_CONFIG_DIR=$(readlink -f ~/.language-servers/jdtls/config)
              export JDTLS_DATA_DIR=$(readlink -f ./jdtls)
              # Nice aliases when working without a build system for java
              alias javac="javac -sourcepath src -d out"
              alias java="java -cp out"
              alias jrun='function _run(){ javac src/$1.java; java $1; };_run'
            '';
          };

          fx = mkShell {
            packages = [
              jdk21
              jdt-language-server
            ];
            # Eventually I would like to make this solely dependent on nix packages,
            # but at the moment I've had no luck with the modular-sdk packages in the
            # main repositories.
            #
            # libXtst needed for glassgtk3 dependency
            shellHook = ''
              export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.xorg.libXtst}/lib/"
              export FX_LIB_PATH="~/.javafx/javafx-sdk-21.0.2/lib"
              export JDTLS_STORE_PATH="${pkgs.jdt-language-server}"
              mkdir -p jdtls/data ~/.language-servers/jdtls/config
              export JDTLS_CONFIG_DIR=$(readlink -f ~/.language-servers/jdtls/config)
              export JDTLS_DATA_DIR=$(readlink -f ./jdtls)
              alias javac="javac -sourcepath src -d out --module-path $FX_LIB_PATH --add-modules javafx.controls,javafx.fxml"
              alias java="java -cp out --module-path $FX_LIB_PATH --add-modules javafx.controls,javafx.fxml"
              alias jrun='function _run(){ javac src/$1.java; java $1; };_run'
            '';
          };
        };
      });
}
