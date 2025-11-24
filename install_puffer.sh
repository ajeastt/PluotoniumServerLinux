#!/bin/bash
set -e

# Non-interactive setup for panel environments
# No sudo, no prompts

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Ensure Plutonium directory exists
mkdir -p Plutonium
cd Plutonium

# Download plutonium-updater by mxve if missing
if [ ! -f "plutonium-updater" ]; then
  echo "Downloading plutonium-updater..."
  wget https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
  tar xfv plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
  rm plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
fi

chmod +x plutonium-updater || true

# Mark server scripts executable when present
[ -f T4_mp_server.sh ] && chmod +x T4_mp_server.sh
[ -f T4_zm_server.sh ] && chmod +x T4_zm_server.sh

[ -f T5_mp_server.sh ] && chmod +x T5_mp_server.sh
[ -f T5_zm_server.sh ] && chmod +x T5_zm_server.sh

[ -f T6_zm_server.sh ] && chmod +x T6_zm_server.sh
[ -f T6_zm_server_puffer.sh ] && chmod +x T6_zm_server_puffer.sh

echo "Panel installer finished."
