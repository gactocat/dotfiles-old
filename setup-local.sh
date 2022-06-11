#!/usr/bin/env bash

set -eu

workdir=$(cd $(dirname $0);pwd)

echo '
.config/karabiner/karabiner.json

.config/nvim/init.lua
.config/nvim/lua/colors.lua
.config/nvim/lua/keymaps.lua
.config/nvim/lua/plugins.lua

.config/gitui/key_bindings.ron

.zshrc
.zsh/.zshrc.alias
.zsh/.zshrc.base
.zsh/.zshrc.prompt
.zsh/.zshrc.zplug

.tmux.conf

.hyper.js

.gitconfig
.gitignore

' | while read path
do
  if [ -n "$path" ]; then
    dir=$(dirname $path)
    if [ -n "$dir" ]; then
      mkdir -p $dir
    fi
    ln -fvns $workdir/$path $HOME/$path
  fi
done
