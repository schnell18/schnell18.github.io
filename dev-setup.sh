#!/bin/bash

function check_python_pkg {
    python -c "import $1" >/dev/null 2>&1
}

# fail fast by exiting on first error
set -e

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
