#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_SHADER="$SCRIPT_DIR/buildshaders.sh"

SOURCE_DIR="../../"
# Change me to your mod's name!
GAME_DIR="../../../game/mod_tf"

bash "$BUILD_SHADER" sdkshaders_dx9_20b -game "$GAME_DIR" -source "$SOURCE_DIR"
bash "$BUILD_SHADER" sdkshaders_dx9_30  -game "$GAME_DIR" -source "$SOURCE_DIR" -force30
