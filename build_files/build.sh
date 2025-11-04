#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y \
  docker docker-compose

# Install mise from COPR
dnf5 -y copr enable jdxcode/mise \
  && dnf5 install -y mise \
  && mise i \
    bun deno node java java@17 uv zig ubi:leoafarias/fvm \
    jj ubi:idursun/jjui lazygit ubi:afnanenayet/diffsitter \
    bat tmux zellij starship ubi:nushell/nushell \
    claude npm:@github/copilot ubi:block/goose \
    ubi:dector/bang ubi:dector/serv \
    ubi:dector/lampa \
    ubi:tailwindlabs/tailwindcss \
  && dnf5 -y corp disable jdxcode/mise # Disable COPRs so they don't end up enabled on the final image:

### Enabling a System Unit File

systemctl enable podman.socket

### Cleanup

dnf5 clean all

