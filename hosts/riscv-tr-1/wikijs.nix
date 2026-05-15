{ lib, config, ... }:
let
  user-and-db-name = "wikijs";
in
{
  services.wiki-js = {
    enable = true;
    settings = {
      db = {
        user = user-and-db-name;
        db = user-and-db-name;
        host = "/run/postgresql";
        type = "postgres";
      };
      port = 3080;
    };
  };

  users.users.${user-and-db-name} = {
    isSystemUser = true;
    group = user-and-db-name;
  };
  users.groups.${user-and-db-name} = { };

  systemd.services.wiki-js = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
    serviceConfig = {
      User = user-and-db-name;
      Group = user-and-db-name;
      DynamicUser = lib.mkForce true;
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ user-and-db-name ];
    ensureUsers = [
      {
        name = user-and-db-name;
        ensureDBOwnership = true;
      }
    ];

  };

  services.nginx.virtualHosts."wiki.riscv.alper-celik.dev" = {
    enableACME = true;
    locations."/".proxyPass = "http://127.0.0.1:${toString config.services.wiki-js.settings.port}";
  };
}
