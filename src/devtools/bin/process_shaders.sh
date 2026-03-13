#!/usr/bin/env bash
set -euo pipefail
#set -o xtrace

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    echo "usage: process_shaders.sh <file> <version> [-dynamic] [-threads <n>]"
    echo "       version: 20b | 30 | 40 | 41 | 50 | 51 | 60"
    exit 1
}

FILE=""
VERSION=""
DYNAMIC=0
THREADS=0

while [[ $# -gt 0 ]]; do
    case "${1,,}" in
        -dynamic) DYNAMIC=1; shift ;;
        -threads) THREADS="$2"; shift 2 ;;
        -version) VERSION="$2"; shift 2 ;;
        *)
            if [[ -z "$FILE" ]]; then FILE="$1"
            elif [[ -z "$VERSION" ]]; then VERSION="$1"
            else usage
            fi
            shift ;;
    esac
done

if [[ -z "$FILE" || -z "$VERSION" ]]; then
    usage
fi

case "$VERSION" in
    20b|30|40|41|50|51|60) ;;
    *) exit 0 ;;
esac

SHADER_PATH="$(dirname "$(realpath "$FILE")")"

while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*$ ]] && continue
    [[ "$line" =~ ^[[:space:]]*'//' ]] && continue

    if [[ "$DYNAMIC" -eq 1 ]]; then
        "$SCRIPT_DIR/ShaderCompile2/ShaderCompile" -dynamic -ver "$VERSION" -shaderpath "$SHADER_PATH" "$line"
    elif [[ "$THREADS" -ne 0 ]]; then
        "$SCRIPT_DIR/ShaderCompile2/ShaderCompile" -threads "$THREADS" -ver "$VERSION" -shaderpath "$SHADER_PATH" "$line"
    else
        "$SCRIPT_DIR/ShaderCompile2/ShaderCompile" -ver "$VERSION" -shaderpath "$SHADER_PATH" "$line"
    fi
done < "$FILE"
