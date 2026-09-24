{ pkgs, ... }:
{
  nixpkgs.config.permittedInsecurePackages = [
    pkgs.jitsi-meet.name
  ];

  services.jitsi-videobridge = {
    # Maps the container's private IPv4 to the Host's Public IPv4
    # while leaving native Public IPv6 harvesting untouched
    nat = {
      localAddress = "192.168.100.11";
      publicAddress = "168.119.172.112"; # <-- Host's main Public IPv4
    };
  };

  services.jitsi-meet = {
    enable = true;
    excalidraw.enable = true;
    hostName = "jitsi.riscv.alper-celik.dev";

    jicofo.enable = true;
    prosody = {
      enable = true;
      lockdown = true;
    };
    videobridge.enable = true;

    nginx.enable = true;
  };
  services.jitsi-videobridge.openFirewall = true;
}
