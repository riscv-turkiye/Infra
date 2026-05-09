# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: MIT

{ ... }:
{
  networking.useHostResolvConf = false;
  networking.nameservers = [
    "1.1.1.1"
  ];
}
