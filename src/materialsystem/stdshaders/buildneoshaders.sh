#!/usr/bin/env bash
set -euo pipefail
#set -o xtrace

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_SHADER="$SCRIPT_DIR/buildshaders.sh"

SOURCE_DIR="../../"
GAME_DIR="../../../game/neo"

bash "$BUILD_SHADER" neoshader_dx9_20b -game "$GAME_DIR" -source "$SOURCE_DIR"
# bash "$BUILD_SHADER" neoshader_dx9_20b_new -game "$GAME_DIR" -source "$SOURCE_DIR"
bash "$BUILD_SHADER" neoshader_dx9_30  -game "$GAME_DIR" -source "$SOURCE_DIR" -force30
