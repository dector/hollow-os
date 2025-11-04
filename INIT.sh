#!/usr/bin/env sh

set -Eeuo pipefail
trap '[ $? -eq 0 ] && exit 0 || printf "\n❌ error on line %s (exit code %s)\n" "$LINENO" "$?" >&2' EXIT

A_USER=$USER

new_line() {
  echo ""
}

wait_for_enter() {
  new_line
  [ -t 0 ] && { printf "Press [Enter] to continue"; read -r _; }
}

install_mise() {
  new_line
  echo "------- INSTALLING mise -------"
  new_line

  # Check if mise is already installed
  if command -v mise >/dev/null 2>&1; then
    echo "mise is already installed ($(command -v mise))"
    echo "Skipping installation."
    return
  fi

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

install_rustdesk() {
  new_line
  echo "------- INSTALLING RustDesk -------"
  new_line

  printf "Do you want to install RustDesk? [y/n] (y): "
  read -r install_rd

  # Default to 'y' if empty
  install_rd=${install_rd:-y}

  case "$install_rd" in
    y|Y)
      ;;
    *)
      echo "Skipping RustDesk installation."
      return
      ;;
  esac

  echo "------- INSTALLING RustDesk -------"
  new_line

  echo "|> Installing RustDesk via flatpak..."
  flatpak install flathub com.rustdesk.RustDesk

  new_line
  echo "|> Done!"
}

setup_tailscale() {
  new_line
  echo "------- SETTING UP Tailscale -------"
  new_line

  printf "Do you want to enable Tailscale? [y/n] (y): "
  read -r enable_ts

  # Default to 'y' if empty
  enable_ts=${enable_ts:-y}

  case "$enable_ts" in
    y|Y)
      ;;
    *)
      echo "Skipping Tailscale setup."
      return
      ;;
  esac

  new_line
  echo "|> Adding user as operator..."
  sudo tailscale set --operator=$A_USER

  new_line
  echo "|> Checking Tailscale login status..."
  if [ "$(tailscale status --json | jq -r '.BackendState')" = "NeedsLogin" ]; then
    echo "|> Logging into Tailscale with QR code..."
    tailscale login --qr
  else
    echo "Already logged into Tailscale. Skipping login."
  fi

  new_line
  printf "Do you want to enable SSH? [y/n] (n): "
  read -r enable_ssh

  # Default to 'n' if empty
  enable_ssh=${enable_ssh:-n}

  case "$enable_ssh" in
    y|Y)
      echo "|> Enabling Tailscale SSH..."
      tailscale up --ssh
      ;;
    *)
      echo "Skipping SSH setup."
      ;;
  esac

  new_line
  echo "|> Done!"
}

install_mise_apps() {
  new_line
  echo "------- INSTALLING apps from mise -------"
  new_line

  mise u -g \
    atuin starship \
    bun deno node java uv zig ubi:leoafarias/fvm \
    jj ubi:idursun/jjui lazygit ubi:afnanenayet/diffsitter \
    bat tmux zellij ubi:nushell/nushell \
    claude npm:@github/copilot ubi:block/goose \
    ubi:dector/bang ubi:dector/serv \
    ubi:dector/lampa \
    ubi:tailwindlabs/tailwindcss

  mise i android-sdk java@17
  echo "|> Done!"
}

install_mise
#install_rustdesk
setup_tailscale

install_mise_apps
