#!/usr/bin/env bash
set -euo pipefail
#set -o xtrace

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "==================== buildshaders $* =================="
tt_start=$SECONDS

SrcDirBase="../.."
targetdir="shaders"
shaderDir="shaders"
IS30=

if [ $# -eq 0 ]; then
    echo ""
    echo "usage: buildshaders <shaderProjectName> [-game gameDir] [-source sourceDir]"
    echo "       gameDir is where gameinfo.txt is (where it will store the compiled shaders)."
    echo "       sourceDir is where the source code is (where it will find scripts and compilers)."
    echo "ex   : buildshaders myshaders"
    echo "ex   : buildshaders myshaders -game /path/to/mod -source /path/to/src"
    exit 1
fi

inputbase="$1"

# Scan args for -force30
for arg in "$@"; do
    if [[ "${arg,,}" == "-force30" ]]; then
        IS30=1
    fi
done

if [[ "${2:-}" == "-game" ]] || [[ "${2:-,,}" == "-game" ]]; then
    gameArg="${2}"
    if [[ "${gameArg,,}" == "-game" ]]; then
        if [ ! -f "$SCRIPT_DIR/../../devtools/bin/ShaderCompile2/ShaderCompile" ]; then
            echo "- ERROR: ShaderCompile2/ShaderCompile doesn't exist in devtools/bin"
            exit 1
        fi

        if [[ "${4:-,,}" != "-source" ]] && [[ "${4:-}" != "-source" ]]; then
            echo "ERROR: If you specify -game on the command line, you must specify -source."
            echo ""
            echo "usage: buildshaders <shaderProjectName> [-game gameDir] [-source sourceDir]"
            exit 1
        fi

        SrcDirBase="${5}"
        targetdir="${3}/shaders"

        if [ ! -f "${3}/gameinfo.txt" ]; then
            echo "Error: \"${3}\" is not a valid game directory."
            echo "(The -game directory must have a gameinfo.txt file)"
            exit 1
        fi

        if [ ! -f "${inputbase}.txt" ]; then
            echo "Error: \"${inputbase}.txt\" is not a valid file."
            exit 1
        fi
    fi
fi

# Create output dirs
mkdir -p include
mkdir -p "$shaderDir"
mkdir -p "$shaderDir/fxc"

SHVER="20b"
if [ -n "$IS30" ]; then
    SHVER="30"
fi

echo "Building inc files and worklist for ${inputbase}..."
echo "Building for ${SHVER}..."

DYNAMIC_ARG=
if [ "${dynamic_shaders:-}" == "1" ]; then
    DYNAMIC_ARG="-dynamic"
fi

bash "$SrcDirBase/devtools/bin/process_shaders.sh" $DYNAMIC_ARG -version "$SHVER" "${inputbase}.txt"

# Copy shaders to target
if [ "${dynamic_shaders:-}" != "1" ]; then
    mkdir -p "$targetdir"
    if [ "$targetdir" != "$shaderDir" ]; then
        cp -r "$shaderDir/." "$targetdir/"
    fi
fi

echo ""
echo "Elapsed: $((SECONDS - tt_start))s"
echo ""
