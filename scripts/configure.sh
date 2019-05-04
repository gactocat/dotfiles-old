#!/usr/bin/env bash

set -e

if ! command -v defaults > /dev/null 2>&1; then
    echo "\`defaults\` not found. Nothing to do."
    exit 0
fi

defaults write -g AppleLanguages '( "en-JP", "ja-JP")'
defaults write com.apple.finder AppleShowAllFiles -boolean true # 隠しファイルを表示する
