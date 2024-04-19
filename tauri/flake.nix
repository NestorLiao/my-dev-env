{
  description = "A Nix-flake-based Rust development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
  }: let
    overlays = [
      rust-overlay.overlays.default
      (final: prev: {
        rustToolchain = prev.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      })
    ];
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit overlays system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell rec {
        libraries = with pkgs; [
          webkitgtk_4_1
          gtk3
          cairo
          gdk-pixbuf
          glib
          dbus
          openssl_3
          librsvg
        ];
        shellHook = ''
          export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
          export WEBKIT_DISABLE_COMPOSITING_MODE=1
          export NDK_HOME=/home/nestor/Android/sdk/ndk/27.0.11718014/
          export ANDROID_HOME=/home/nestor/Android/sdk/
        '';
        buildInputs = with pkgs; [
          curl
          wget
          trunk
          pkg-config
          dbus
          openssl_3
          glib
          gtk3
          libsoup_3
          webkitgtk_4_1
          librsvg
          rustToolchain
          cargo-deny
          cargo-edit
          cargo-watch
          cargo-generate
          rust-analyzer
        ];
      };
    });
  };
}
