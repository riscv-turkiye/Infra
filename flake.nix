# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: MIT

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    octodns-cloudflare-src = {
      url = "github:octodns/octodns-cloudflare";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      deploy-rs,
      ...
    }:
    let

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            self-pkgs = self.packages.${system};
            inherit (self) system;
            pkgs = import nixpkgs {
              inherit # overlays
                system
                ;
            };
          }
        );

      personal-ssh-public-keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhCFPTP1/JLMCCJttaw88EgBQzPt5fF7EcjXIgDdeuM alper@alper-celik.dev"
      ];
      github-ssh-public-key = "";
      trusted-ssh-keys = [ github-ssh-public-key ] ++ personal-ssh-public-keys;

      all-file =
        dir:
        builtins.map (file: (builtins.toString dir) + "/" + file) (
          builtins.attrNames (builtins.readDir dir)
        );
    in
    {
      nixosConfigurations =
        let
          pkgs-stable = import nixpkgs {
            system = "aarch64-linux";
          };
          pkgs-unstable = import nixpkgs-unstable {
            system = "aarch64-linux";
          };

          all-configs = {
            inherit riscv-tr-1;
          };

          riscv-tr-1 = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs = {
              inherit
                inputs
                trusted-ssh-keys
                pkgs-unstable
                all-configs
                ;
            };
            modules = all-file ./hosts/riscv-tr-1 ++ all-file ./hosts/common;
          };
        in
        all-configs;

      deploy.nodes = {
        riscv-tr-1 = {
          hostname = "";
          sshUser = "root";
          activationTimeout = 1000;
          confirmTimeout = 60;
          remoteBuild = true;

          profiles = {
            system = {
              user = "root";
              path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.riscv-tr-1;
            };
          };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      packages = forEachSupportedSystem (
        { pkgs, self-pkgs, ... }:
        {
          octodns =
            with pkgs;
            (octodns.withProviders (ps: [
              self-pkgs.octodns-cloudflare
              octodns-providers.bind
            ]));

          octodns-cloudflare = pkgs.python3Packages.callPackage ./pkgs/octodns-cloudflare.nix {
            src = inputs.octodns-cloudflare-src;
          };
          deploy-rs = pkgs.deploy-rs;
        }
      );

      devShells = forEachSupportedSystem (
        {
          pkgs,
          self-pkgs,
          ...
        }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              yq
              self-pkgs.octodns
              self-pkgs.deploy-rs
              nix
            ];
          };
        }
      );

    };
}
