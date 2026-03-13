#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export dynamic_shaders=1
bash "$SCRIPT_DIR/buildstdshaders.sh"
unset dynamic_shaders
