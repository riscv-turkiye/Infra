# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: MIT

{ ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts."server1.riscv.alper-celik.dev" = {
      enableACME = true;
      default = true;

      locations."/" = {
        return = "200 'Hello from IP: $server_addr\n'";
        extraConfig = ''
          add_header Content-Type text/plain;
        '';
      };
    };
  };
}
