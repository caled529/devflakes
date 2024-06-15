{
  description = "JavaFX development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    flake_name = "javafx";
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

        # Eventually I would like to make this solely dependent on nix packages,
        # but at the moment I've had no luck with the modular-sdk packages in the
        # main repositories.
        #
        # libXtst needed for glassgtk3 dependency
        shellHook = ''
          PS1='[\t] \[\e[94m\]\u@devflakes.${flake_name}\[\e[0m\] \[\e[95m\]\W\[\e[0m\] \$ '
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
  };
}
