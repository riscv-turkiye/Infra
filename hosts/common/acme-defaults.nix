# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: MIT

{ ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "alper@alper-celik.dev";
    };
  };

}
