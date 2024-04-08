{
  inputs = {
    nixpkgs.url = "github:nixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
  in {
    formatter = forAllSystems (system: pkgs.${system}.alejandra);
    devShell = forAllSystems (system:
      pkgs.${system}.mkShellNoCC {
        packages = with pkgs.${system}; [
          nil
          statix
        ];
      });

    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # note this should be replaced with a imported file for readability
        ({pkgs, ...}: {
          boot.isContainer = true;

          # let 'nixos-version --json' know about the git revision
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

          networking = {
            useDHCP = false;
            firewall.allowedTCPPorts = [80];
          };

          # enable web server
          services.httpd = {
            enable = true;
            adminAddr = "test@example.com";
          };
        })
      ];
    };
  };
}
