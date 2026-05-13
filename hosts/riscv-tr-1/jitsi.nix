{ pkgs, ... }:
{
  nixpkgs.config.permittedInsecurePackages = [
    pkgs.jitsi-meet.name
  ];
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
