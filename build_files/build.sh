#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Install packages
dnf install -y \
  `# System monitoring` \
  htop \
  `# Networking` \
  fuse-sshfs \
  `# Containers` \
  docker docker-compose incus \
  `# Image Processing` \
  ImageMagick-heic \
  `#`

  
### Enabling a System Unit File

systemctl enable podman.socket

### Cleanup

dnf clean all

