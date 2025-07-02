#!/bin/bash

function install_required_hugo {
    REQUIRED_VER="0.145.0"
    if command -v hugo; then
        VER_STR=$(hugo version | cut -d' ' -f2)
        VER=$VER_STR
        if [[ $VER == "*-*" ]]; then
            VER=$(echo $VER_STR | cut -d'-' -f1)
        fi
        if [[ $VER != "v$REQUIRED_VER" || ! $VER_STR =~ ".*extended" ]]; then
            echo "Unsupported hugo version: $VER_STR, please install hugo $REQUIRED_VER extended" 1>&2
            exit 2
        fi
    else
        curl -sL -O --output-dir /tmp "https://github.com/gohugoio/hugo/releases/download/v$REQUIRED_VER/hugo_extended_${REQUIRED_VER}_darwin-universal.tar.gz"
        tar -xzvf /tmp/hugo_extended_${REQUIRED_VER}_darwin-universal.tar.gz -C ~/.local/bin
    fi
}

function check_python_pkg {
    python -c "import $1" >/dev/null 2>&1
}

# fail fast by exiting on first error
set -e

install_required_hugo

# Install uv and create a project-scoped venv with pre-commit installed
export PATH="$HOME/.local/bin:$PATH"
ret=$(command -v uv)
if [[ $? -ne 0 ]]; then
    # On macOS and Linux.
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if [[ ! -d .venv ]]; then
    uv venv --python=3.11
fi

source .venv/bin/activate
if ! check_python_pkg pre_commit ; then
    uv pip install pre-commit
fi

# Install pre-commit hook
pre-commit install

# Install image resize validate hook
MARKER="########## image resize val hook ##########"
TARGET=".git/hooks/pre-commit"
if grep "$MARKER" $TARGET 1>/dev/null 2>&1; then
    exit 0
fi

TMP_FILE="$TARGET.tmp"
cp $TARGET $TMP_FILE
head -1 $TARGET > $TMP_FILE
ROOT_DIR=$(pwd)
cat<<EOT >> $TMP_FILE

$MARKER
if ! $ROOT_DIR/process-image.sh check; then
    echo "Aborting commit due to non-resized images." 1>&2
    exit 3
fi
$MARKER

EOT

LINES=$(wc -l < $TARGET | tr -d ' ')
REM=$(( LINES - 1 ))
tail -$REM $TARGET >> $TMP_FILE
mv $TMP_FILE $TARGET
