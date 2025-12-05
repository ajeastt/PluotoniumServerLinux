#!/bin/bash

# Plutonium T6 Zombies server start script for panel environments (Pterodactyl / Calagopus)

set -euo pipefail

# Reduce Wine spam
export WINEDEBUG=-all
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:
export XDG_RUNTIME_DIR=/tmp

# Directory where this script lives (Plutonium/)
INSTALLDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ----------------- CONFIG VIA ENVIRONMENT -----------------

# Server name
# Prefer SERVER_NAME, fall back to default
NAME="${SERVER_NAME:-T6 Zombies 1}"

# Path to BO2/T6 game files
# Prefer T6_GAME_PATH, otherwise default to ../T6Gamefiles relative to this script
PAT="${T6_GAME_PATH:-"$INSTALLDIR/../T6Gamefiles"}"

# Plutonium server key
# Prefer PLUTONIUM_KEY (panel), but accept legacy SERVER_KEY if set
KEY="${PLUTONIUM_KEY:-${SERVER_KEY:-}}"

# Server config file
# Prefer SERVER_CONFIG, but accept legacy SERVER_CFG
CFG="${SERVER_CONFIG:-${SERVER_CFG:-dedicated_zm.cfg}}"

# Server port
PORT="${SERVER_PORT:-4977}"

# Game mode (always t6zm for this script)
MODE="${GAME_MODE:-t6zm}"

# Optional fs_game / mod dir
MOD="${SERVER_MOD:-}"

# ----------------- UPDATE FILES -----------------

# Update Plutonium files
"$INSTALLDIR/plutonium-updater" -d "$INSTALLDIR"

# ----------------- LOGGING / BANNER -----------------

echo -e "\033]2;Plutonium - $NAME - Server restart\007"
echo "Visit plutonium.pw | Join the Discord (plutonium) for NEWS and Updates!"
echo "Server '$NAME' will load '$CFG' and listen on port $PORT UDP!"
echo "To shut down the server, stop the process from your panel."
printf -v NOW '%(%F_%H:%M:%S)T' -1
echo "$NOW $NAME server started."

# ----------------- MAIN LOOP -----------------

while true; do
    # Run Plutonium and clean up the output a bit for panel consoles
    wine "$INSTALLDIR/bin/plutonium-bootstrapper-win32.exe" \
        "$MODE" "$PAT" -dedicated \
        +set key "$KEY" \
        +set fs_game "$MOD" \
        +set net_port "$PORT" \
        +exec "$CFG" \
        +map_rotate 2>&1 \
    | awk '
        # Strip title / control lines that start with ]0;
        /^\]0;Plutonium/ { next }

        # Collapse multiple blank-ish lines into a single blank line
        {
            # Remove carriage returns and weird control chars
            gsub(/\r/, "");
            if ($0 ~ /^[[:space:]]*$/) {
                if (!blank) {
                    print "";
                    blank = 1;
                }
            } else {
                print;
                blank = 0;
            }
        }
      '

    printf -v NOW '%(%F_%H:%M:%S)T' -1
    echo "$NOW WARNING: $NAME server closed or dropped... server restarting."
    sleep 1
done

