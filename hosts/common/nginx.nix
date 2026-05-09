# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: MIT

{ pkgs, lib, ... }:
let
  mkIfStr = cond: as: if cond then as else "";
in
with lib;
{
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, ... }:
        {

          options.x-disable-http3 = mkOption {
            type = types.bool;
            default = false;
            description = ''
              whether to disable http3/quick on this virtualHost
            '';
          };
          config = {
            extraConfig = (
              mkIfStr (!config.x-disable-http3) ''
                add_header Alt-Svc 'h3=":443"; ma=86400';
              ''
            );

            quic = true;
            http3 = true;

          };
        }
      )
    );
  };
  config = {

    #open web server to firewall
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [
        443
      ];
    };

    services.nginx = {
      package = pkgs.nginxMainline;

      enableQuicBPF = true;

      recommendedGzipSettings = true;
      recommendedBrotliSettings = true;

      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;

      appendHttpConfig = ''
        proxy_headers_hash_bucket_size 128;
        proxy_headers_hash_max_size 1024;

      '';
    };
  };

}
