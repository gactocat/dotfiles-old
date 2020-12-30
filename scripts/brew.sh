#!/usr/bin/env bash

set -eu

if [ "$(uname)" != "Darwin" ]; then
    echo "Not in darwin. Nothing to do."
    exit 0
fi

# Install homebrew: https://brew.sh/
if ! command -v brew > /dev/null 2>&1; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo
fi

brew bundle
