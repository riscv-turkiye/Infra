# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: MIT

{ ... }:
{
  boot.isNspawnContainer = true; # currently on a nspawn container on my vps
  nixpkgs.hostPlatform = "aarch64-linux";
  systemd.enableEmergencyMode = false; # recommendation from https://schreibt.jetzt/@linus/111962725769108997
  system.stateVersion = "25.11";
  time.timeZone = "Europe/Istanbul";
}
