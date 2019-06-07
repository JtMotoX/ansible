#!/bin/bash
cd "$(dirname "$0")"

DATADIR=/root/.local/share/code-server-data
EXTDIR=/root/.local/share/code-server-extensions

./stop-code-server.sh

echo "Synchronizing settings and extensions from local vsc installation . . ."

# COPY SETTINGS
mkdir -p "$DATADIR"
rsync -a --delete /local-vsc/Code/ "$DATADIR"

# COPY 3rd PARY EXTENSIONS
mkdir -p "$EXTDIR"
rsync -a --delete /local-vsc/extensions/ "$EXTDIR"

# COPY VSC built-in extensions
mkdir -p /src/packages/server/build/extensions
rsync -a --delete /local-vsc/com.microsoft.VSCode.ShipIt/update.*/Visual\ Studio\ Code.app/Contents/Resources/app/extensions/ /src/packages/server/build/extensions

# START CODE-SERVER
echo "starting code-server"
./code-server \
    --user-data-dir "$DATADIR" \
    --extensions-dir "$EXTDIR" \
    /host/