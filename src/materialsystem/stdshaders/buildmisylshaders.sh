#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_SHADER="$SCRIPT_DIR/buildshaders.sh"

SOURCE_DIR="../../"
GAME_DIR="../../../game/neo"

bash "$BUILD_SHADER" misylshaders_dx9_20b -game "$GAME_DIR" -source "$SOURCE_DIR"
bash "$BUILD_SHADER" misylshaders_dx9_30  -game "$GAME_DIR" -source "$SOURCE_DIR" -force30
