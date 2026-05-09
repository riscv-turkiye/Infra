# SPDX-FileCopyrightText: 2026 Alper Çelik <alper@alper-celik.dev>
#
# SPDX-License-Identifier: MIT

{
  buildPythonPackage,
  octodns,
  setuptools,
  requests,

  src,
}:
buildPythonPackage {
  pname = "octodns-cloudflare";
  version = "0.0.0";
  pyproject = true;

  inherit src;

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    octodns
    requests
  ];

}
