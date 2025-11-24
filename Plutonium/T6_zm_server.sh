#!/bin/bash
NAME="T6 Zombies 1"

PAT="/full/path/to/T6Gamefiles"

KEY=""

CFG="dedicated_zm.cfg"

PORT=4977

MODE="t6zm"

MOD=""

INSTALLDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$INSTALLDIR/plutonium-updater" -d "$INSTALLDIR"

echo -e "\033]2;Plutonium - $NAME - Server restart\007"
echo "Visit plutonium.pw | Join the Discord (plutonium) for NEWS and Updates!"
echo "Server $NAME will load $CFG and listen on port $PORT UDP!"
echo "To shut down the server close this window first!"
printf -v NOW '%(%F_%H:%M:%S)T' -1
echo "$NOW $NAME server started."

while true; do
    wine "$INSTALLDIR/bin/plutonium-bootstrapper-win32.exe" \
        "$MODE" "$PAT" -dedicated \
        +set key "$KEY" \
        +set fs_game "$MOD" \
        +set net_port "$PORT" \
        +exec "$CFG" \
        +map_rotate

    printf -v NOW '%(%F_%H:%M:%S)T' -1
    echo "$NOW WARNING: $NAME server closed or dropped... server restarting."
    sleep 1
done