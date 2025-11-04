#!/usr/bin/env sh

set -eu

new_line() {
  echo ""
}

wait_for_enter() {
  new_line
  [ -t 0 ] && { printf "Press [Enter] to continue"; read -r _; }
}

install_mise() {
  echo "------- INSTALLING mise -------"
  new_line

  echo "|> Creating temporary directory..."
  cd $(mktemp -d)

  # using ephemeral keyring
  export GNUPGHOME=$(pwd)

  echo "|> Fetching GPG public key..."
  gpg \
    --keyserver hkps://keys.openpgp.org \
    --recv-keys 24853EC9F655CE80B48E6C3A8B81C9D17413A06D
  new_line

  echo "|> Verifying key fingerprint..."
  gpg --fingerprint 24853EC9F655CE80B48E6C3A8B81C9D17413A06D

  wait_for_enter

  echo "|> Downloading mise installer signature..."
  curl -fsSLo install.sh.sig https://mise.jdx.dev/install.sh.sig

  # decrypt / verify and write the resulting install.sh into the original cwd
  echo "|> Verifying and extracting installer..."
  gpg --decrypt install.sh.sig > install-mise.sh

  echo "|> Installing mise..."
  wait_for_enter
  sh install-mise.sh

  new_line
  echo "|> Done!"
}

# Check if mise is already installed
if command -v mise >/dev/null 2>&1; then
  echo "mise is already installed ($(command -v mise))"
  echo "Skipping installation."
else
  install_mise
fi

