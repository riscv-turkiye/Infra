# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: MIT

{ ... }:
{
  boot.isNspawnContainer = true; # currently on a nspawn container on my vps
  nixpkgs.hostPlatform = "aarch64-linux";
}
