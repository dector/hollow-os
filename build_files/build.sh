#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Install docker
dnf install -y docker docker-compose

# Install mise from COPR
dnf -y copr enable jdxcode/mise \
  && dnf -y install mise
  #&& dnf5 -y copr disable jdxcode/mise # Disable COPRs so they don't end up enabled on the final image:

### Enabling a System Unit File

systemctl enable podman.socket

### Cleanup

dnf clean all

