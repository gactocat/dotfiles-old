vim.g.mapleader = ' '

local opt = vim.opt
opt.number = true
opt.title = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.visualbell = true
opt.swapfile = false
opt.backup = false
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.clipboard:append { 'unnamedplus' }

require 'plugins'
require 'color'
