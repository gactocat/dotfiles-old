local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.api.nvim_command 'packadd packer.nvim'
end

require 'packer'.startup {
    function(use)
        -- packer can manage itself
        use {
            'wbthomason/packer.nvim'
        }

        -- color schema
        use {
            'ellisonleao/gruvbox.nvim',
            -- 'overcache/NeoSolarized',
        }

        -- LSP
        use {
            'neovim/nvim-lspconfig',
            'williamboman/nvim-lsp-installer',
            'tami5/lspsaga.nvim',
            'onsails/lspkind-nvim',
            'ray-x/lsp_signature.nvim',
        }

        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
        }

        -- completion
        use {
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
        }

        -- snipet
        use {
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
        }

        use {
            'kyazdani42/nvim-tree.lua',
            requires = {
                'kyazdani42/nvim-web-devicons',
                opt = true,
            },
        }

        -- fuzzy finder
        use {
            'nvim-telescope/telescope.nvim',
            requires = { { 'nvim-lua/plenary.nvim' } }
        }

        -- status line
        use {
            'nvim-lualine/lualine.nvim',
            requires = {
                'kyazdani42/nvim-web-devicons',
                opt = true
            }
        }

        -- terminal integration
        use {
            'akinsho/toggleterm.nvim',
            tag = 'v1.*',
            config = function()
                require 'toggleterm'.setup()
            end }

        -- git
        use {
            'lewis6991/gitsigns.nvim',
        }

        -- test
        use {
            'klen/nvim-test',
            config = function()
                require('nvim-test').setup()
            end
        }

        -- teraform
        use {
            'hashivim/vim-terraform',
        }
    end,
}
local opts = { noremap = true, silent = true }

---------
-- LSP --
---------
local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local map = vim.api.nvim_buf_set_keymap
    map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    map(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    map(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    map(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    map(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    map(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    map(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    map(0, 'n', '<leader>rn', '<cmd>Lspsaga rename<cr>', opts)
    map(0, 'n', '<leader>ca', '<cmd>Lspsaga code_action<cr>', opts)
    map(0, 'x', '<leader>ca', ':<c-u>Lspsaga range_code_action<cr>', opts)
    map(0, 'n', 'K', '<cmd>Lspsaga hover_doc<cr>', opts)
    map(0, 'n', '<leader>e', '<cmd>Lspsaga show_line_diagnostics<cr>', opts)
    map(0, 'n', '[e', '<cmd>Lspsaga diagnostic_jump_next<cr>', opts)
    map(0, 'n', ']e', '<cmd>Lspsaga diagnostic_jump_prev<cr>', opts)
    map(0, 'n', '<C-u>', '<cmd>lua require "lspsaga.action".smart_scroll_with_saga(-1, "<c-u>")<cr>', {})
    map(0, 'n', '<C-d>', '<cmd>lua require "lspsaga.action".smart_scroll_with_saga(1, "<c-d>")<cr>', {})
end

local lsp_installer = require 'nvim-lsp-installer'
local lspconfig = require 'lspconfig'
lsp_installer.setup()
for _, server in ipairs(lsp_installer.get_installed_servers()) do
    lspconfig[server.name].setup {
        on_attach = on_attach,
        capabilities = require 'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
end

----------------
-- treesitter --
----------------
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or 'all'
    ensure_installed = { 'c', 'lua', 'rust' },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing (for 'all')
    ignore_install = { 'javascript' },

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = { 'c', 'rust' },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

----------------
-- completion --
----------------
vim.opt.completeopt = 'menu,menuone,noselect'

local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

local lspkind = require 'lspkind'
cmp.setup {
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
                return vim_item
            end
        })
    }
}

----------------
-- toggleterm --
----------------
require 'toggleterm'.setup()
function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-w>j', [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-w>k', [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-w>l', [[<C-\><C-n><C-W>l]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-w>t', '<cmd>exe v:count1 . "ToggleTerm"<CR>', opts)
end

vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

vim.api.nvim_set_keymap('n', '<C-w>t', '<cmd>exe v:count1 . "ToggleTerm"<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-w>T', '<cmd>:ToggleTermToggleAll<CR>', opts)

local Terminal = require 'toggleterm.terminal'.Terminal
local gitui    = Terminal:new({
    cmd = 'gitui',
    dir = 'git_dir',
    direction = 'float',
    float_opts = {
        border = 'double',
    },
    -- function to run on opening the terminal
    on_open = function(term)
        vim.cmd('startinsert!')
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
    end,
    -- function to run on closing the terminal
    on_close = function(term)
        vim.cmd('Closing terminal')
    end,
})

function _gitui_toggle()
    gitui:toggle()
end

vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>lua _gitui_toggle()<CR>', { noremap = true, silent = true })


---------------
-- nvim-tree --
---------------
require 'nvim-tree'.setup {
    open_on_setup = true,
}
vim.api.nvim_set_keymap('n', 'fe', '<cmd>:NvimTreeToggle<CR>', opts)
vim.api.nvim_set_keymap('n', 'fr', '<cmd>:NvimTreeRefresh<CR>', opts)
vim.api.nvim_set_keymap('n', 'fd', '<cmd>:NvimTreeFindFile<CR>', opts)

-------------
-- lualine --
-------------
require 'lualine'.setup {
    options = {
        theme = 'gruvbox',
        disabled_filetypes = { 'NvimTree' } -- disable statusline in file tree
    }
}

--------------
-- gitsigns --
--------------
require 'gitsigns'.setup()

---------------
-- telescope --
---------------
vim.api.nvim_set_keymap('n', 'fs', '<cmd>lua require "telescope.builtin".find_files()<CR>', opts)
vim.api.nvim_set_keymap('n', 'fg', '<cmd>lua require "telescope.builtin".live_grep()<CR>', opts)
vim.api.nvim_set_keymap('n', 'fb', '<cmd>lua require "telescope.builtin".buffers()<CR>', opts)
vim.api.nvim_set_keymap('n', 'fh', '<cmd>lua require "telescope.builtin".help_tags()<CR>', opts)

----------
-- test --
----------

require 'nvim-test'.setup {
    run = true, -- run tests (using for debug)
    commands_create = true, -- create commands (TestFile, TestLast, ...)
    filename_modifier = ':.', -- modify filenames before tests run(:h filename-modifiers)
    silent = false, -- less notifications
    term = 'terminal', -- a terminal to run ('terminal'|'toggleterm')
    termOpts = {
        direction = 'vertical', -- terminal's direction ('horizontal'|'vertical'|'float')
        width = 96, -- terminal's width (for vertical|float)
        height = 24, -- terminal's height (for horizontal|float)
        go_back = false, -- return focus to original window after executing
        stopinsert = 'auto', -- exit from insert mode (true|false|'auto')
        keep_one = true, -- keep only one terminal for testing
    },
    runners = { -- setup tests runners
        cs = 'nvim-test.runners.dotnet',
        go = 'nvim-test.runners.go-test',
        haskell = 'nvim-test.runners.hspec',
        javacriptreact = 'nvim-test.runners.jest',
        javascript = 'nvim-test.runners.jest',
        lua = 'nvim-test.runners.busted',
        python = 'nvim-test.runners.pytest',
        ruby = 'nvim-test.runners.rspec',
        rust = 'nvim-test.runners.cargo-test',
        typescript = 'nvim-test.runners.jest',
        typescriptreact = 'nvim-test.runners.jest',
    }
}

vim.api.nvim_set_keymap('n', '<leader>tn', '<cmd>TestNearest<CR>', { noremap = true, silent = true }) -- Test nearest test
vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd>TestFile<CR>', { noremap = true, silent = true }) -- Test file
vim.api.nvim_set_keymap('n', '<leader>ts', '<cmd>TestSuite<CR>', { noremap = true, silent = true }) -- Test suite
vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>TestLast<CR>', { noremap = true, silent = true }) -- Test last test run
vim.api.nvim_set_keymap('n', '<leader>tv', '<cmd>TestVisit<CR>', { noremap = true, silent = true }) -- Test visit
