# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: MIT

{ ... }:
{
  networking.useHostResolvConf = false;
  networking.hostName = "riscv-tr-1";
  networking.nameservers = [
    "1.1.1.1"
  ];
}
