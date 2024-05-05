{
  description = "A Nix-flake-based STM32 development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default =
        pkgs.mkShell.override {
          # Override stdenv in order to change compiler:
          # stdenv = pkgs.clangStdenv;
        }
        {
          packages = with pkgs; [
            clang-tools
            cmake
            codespell
            conan
            cppcheck
            doxygen
            gdb
            gtest
            lcov
            vcpkg
            vcpkg-tool

            #embedded
            pkgsi686Linux.glibc
            gcc-arm-embedded
            bear
            #make clean; bear -- make;
            # stm32flash
            # stm32loader
            stlink
            openocd
          ];
        };
    });
  };
}
