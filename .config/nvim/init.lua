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

opt.list = true
opt.listchars = { tab = '>-', space = '_', trail = '*', nbsp = '+' }

opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.clipboard:append { 'unnamedplus' }
opt.mouse = 'a'

require 'colors'
require 'plugins'
require 'keymaps'
