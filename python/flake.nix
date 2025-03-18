{
  description = "A Nix-flake-based Python development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  nixConfig = {
    builders-use-substitutes = true;
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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
            # config.allowUnfree = true;
            # cudaSupport = true;
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
            # numpy
            # pandas
            # matplotlib
            # scipy
            # requests
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
          # pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
          # pip install -r requirements.txt
        '';
        env = {
          # QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins/platforms";
          # PYTHON_CONFIGURE_OPTS = "--enable-shared";

        };

        # Now we can execute any commands within the virtual environment.
        # This is optional and can be left out to run pip manually.
        postShellHook = ''
          # allow pip to install wheels
          unset SOURCE_DATE_EPOCH
        '';
      };
    });
  };
}
