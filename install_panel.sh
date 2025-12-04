#!/bin/bash
# Generic non-interactive installer for panel environments (Pterodactyl / Calagopus)
# - No sudo
# - No prompts
# - Only touches files inside the server directory

set -euo pipefail

# Base directory = repo root (PluotoniumServerLinux)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PLUTONIUM_DIR="${BASE_DIR}/Plutonium"
GAMEFILES_DIR="${BASE_DIR}/T6Gamefiles"

echo "Base directory: ${BASE_DIR}"
echo "Plutonium directory: ${PLUTONIUM_DIR}"
echo "T6 gamefiles directory: ${GAMEFILES_DIR}"

# Ensure core directories exist
mkdir -p "${PLUTONIUM_DIR}"
mkdir -p "${GAMEFILES_DIR}"

cd "${PLUTONIUM_DIR}"

# Download plutonium-updater by mxve if missing
if [ ! -f "plutonium-updater" ]; then
  echo "Downloading plutonium-updater..."
  wget -q https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
  tar xfv plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
  rm plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
fi

chmod +x plutonium-updater || true

# Mark server scripts executable when present
[ -f T4_mp_server.sh ] && chmod +x T4_mp_server.sh
[ -f T4_zm_server.sh ] && chmod +x T4_zm_server.sh

[ -f T5_mp_server.sh ] && chmod +x T5_mp_server.sh
[ -f T5_zm_server.sh ] && chmod +x T5_zm_server.sh

[ -f T6_mp_server.sh ] && chmod +x T6_mp_server.sh
[ -f T6_zm_server.sh ] && chmod +x T6_zm_server.sh

[ -f T6_zm_server_panel.sh ] && chmod +x T6_zm_server_panel.sh

echo "Panel installer finished. Upload your BO2 files into: ${GAMEFILES_DIR}"
