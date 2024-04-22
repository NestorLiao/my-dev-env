{
  description = "A Nix-flake-based Python development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            cudaSupport = true;
          };
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        name = "impurePythonEnv";
        venvDir = "./.venv";

        buildInputs = with pkgs; [
          libsForQt5.qt5.qtwayland

          (with python3Packages; [
            python
            venvShellHook
            numpy
            request
          ])

          taglib
          openssl
          git
          libxml2
          libxslt
          libzip
          zlib
        ];

        # Run this command, only after creating the virtual environment
        postVenvCreation = ''
          unset SOURCE_DATE_EPOCH
          pip install -r requirements.txt
        '';

        # Now we can execute any commands within the virtual environment.
        # This is optional and can be left out to run pip manually.
        postShellHook = ''
          # allow pip to install wheels
          export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins/platforms";
          export PYTHON_CONFIGURE_OPTS="--enable-shared"
          unset SOURCE_DATE_EPOCH
        '';
      };
    });
  };
}
