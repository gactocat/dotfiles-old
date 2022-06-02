require('packer').startup(function()
    -- packer can manage itself
    use {
        'wbthomason/packer.nvim'
    }

    -- color schema
    use {
        -- 'overcache/NeoSolarized',
        'ellisonleao/gruvbox.nvim',
    }

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        'williamboman/nvim-lsp-installer',
        'tami5/lspsaga.nvim',
        'onsails/lspkind-nvim',
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
        "akinsho/toggleterm.nvim",
        tag = 'v1.*',
        config = function()
            require("toggleterm").setup()
        end }

    -- git
    use {
        'lewis6991/gitsigns.nvim',
    }

    -- go
    use {
        'ray-x/go.nvim',
        'ray-x/guihua.lua',
    }

    -- teraform
    use {
        'hashivim/vim-terraform'
    }
end)

---------
-- LSP --
---------
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
-- vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
-- vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local map = vim.api.nvim_buf_set_keymap
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    map(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    map(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    map(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    map(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    map(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- map(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    map(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    map(0, "n", "<leader>rn", "<cmd>Lspsaga rename<cr>", opts)
    map(0, "n", "gx", "<cmd>Lspsaga code_action<cr>", opts)
    map(0, "x", "gx", ":<c-u>Lspsaga range_code_action<cr>", opts)
    map(0, "n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
    map(0, "n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
    map(0, "n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
    map(0, "n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
    map(0, "n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", {})
    map(0, "n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", {})
end

local lsp_installer = require 'nvim-lsp-installer'
local lspconfig = require 'lspconfig'
lsp_installer.setup()
for _, server in ipairs(lsp_installer.get_installed_servers()) do
    lspconfig[server.name].setup {
        on_attach = on_attach,
        capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }
end

----------------
-- treesitter --
----------------
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },

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
vim.opt.completeopt = "menu,menuone,noselect"

local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
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

local lspkind = require('lspkind')
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
require("toggleterm").setup()
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

local Terminal = require('toggleterm.terminal').Terminal
local gitui  = Terminal:new({
    cmd = "gitui",
    dir = "git_dir",
    direction = "float",
    float_opts = {
        border = "double",
    },
    -- function to run on opening the terminal
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
    -- function to run on closing the terminal
    on_close = function(term)
        vim.cmd("Closing terminal")
    end,
})

function _gitui_toggle()
    gitui:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _gitui_toggle()<CR>", { noremap = true, silent = true })


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
require('lualine').setup {
    options = {
        theme = 'gruvbox',
        disabled_filetypes = { 'NvimTree' } -- disable statusline in file tree
    }
}

--------------
-- gitsigns --
--------------
require('gitsigns').setup()

---------------
-- telescope --
---------------
vim.api.nvim_set_keymap('n', 'fs', "<cmd>lua require('telescope.builtin').find_files()<CR>", opts)
vim.api.nvim_set_keymap('n', 'fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", opts)
vim.api.nvim_set_keymap('n', 'fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", opts)
vim.api.nvim_set_keymap('n', 'fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", opts)


--------
-- go --
--------
---- require('go').setup()
---- require("go.format").goimport()  -- goimport + gofmt
---- 
---- -- Run gofmt + goimport on save
---- vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
