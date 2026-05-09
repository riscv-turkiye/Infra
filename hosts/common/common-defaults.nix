# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: MIT

{ pkgs, trusted-ssh-keys, ... }:
{

  users.users.root = {
    openssh.authorizedKeys.keys = trusted-ssh-keys;
  };
  environment.enableAllTerminfo = true;
  documentation.man.generateCaches = false; # needed man completions but takes loong time

  environment.systemPackages = with pkgs; [
    vim
  ];

  time.timeZone = "Europe/Istanbul";
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      # X11Forwarding = true;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

}
