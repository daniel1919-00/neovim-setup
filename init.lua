-- The kickstart script is awesome!
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

-- Neovide configuration (https://neovide.dev/configuration.html)
if vim.g.neovide then
    if vim.fn.has('macunix') then
        vim.o.guifont = "JetBrains Mono:h14"
    else
        vim.o.guifont = "JetBrains Mono:h11"
    end
    vim.opt.linespace = 0
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_refresh_rate_idle = 5
    vim.g.neovide_remember_window_size = true
end

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Global Keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<leader>H', '<cmd> lua vim.diagnostic.open_float() <CR>', {desc = 'Diagnostics window'});
vim.keymap.set('n', '<leader>tw', '<cmd> :set wrap! <CR>', {desc = 'Diagnostics window'});
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>fm', function(_) vim.lsp.buf.format() end, { desc = 'Format current buffer with LSP' })

-- Editor Options
vim.opt.guicursor = { 'a:blinkon1' }
vim.opt.nu = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.updatetime = 250

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Install Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        "catppuccin/nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin-mocha")
        end
    },

    {
        'tpope/vim-sleuth'
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    {
        'nvim-tree/nvim-web-devicons',
        opts = {}
    },

    {   -- Telescope
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local telescope = require('telescope');
            telescope.setup {
                defaults = {
                    mappings = {
                        i = {
                            ['<C-u>'] = false,
                            ['<C-d>'] = false,
                        },
                    },
                    path_display = {"truncate"},
                },
                extensions = {
                    file_browser = {
                        hijack_netrw = false
                    }
                }
            }

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Find Files' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.live_grep, { desc = '[S]earch [S]tring' })
            vim.keymap.set('n', '<leader>sb', function()
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = 'Fuzzily [S]earch in current [B]uffer' })

            vim.keymap.set('n', '<leader>rf', builtin.oldfiles, { desc = '[R]ecent [F]iles' })
            vim.keymap.set('n', '<leader>e', builtin.oldfiles, { desc = 'R[E]cent Files' })

            vim.keymap.set('n', '<leader>gr', builtin.lsp_references, { desc = '[G]oto [R]eferences' })
            vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'See [B]uffers' })

        end
    },

    {
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.

        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end,
        config = function()
            local telescope = require('telescope')
            pcall(telescope.load_extension, 'fzf')
        end
    },

    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup {
                -- A list of parser names, or "all"
                ensure_installed = { "lua", "rust" },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = false,

                highlight = {
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true, disable = { 'python' } },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<c-space>',
                        node_incremental = '<c-space>',
                        node_decremental = '<S-space>',
                    },
                }
            }
        end
    },

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
            show_current_context = true,
            show_current_context_start = true,
        },
    },

    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end
    },

    {
        -- Git Wrapper
        'tpope/vim-fugitive',
        config = function()
            vim.keymap.set("n", "<leader>vc", vim.cmd.Git)
        end
    },

    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
        config = function()
            require('neodev').setup()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            -- Ensure the servers above are installed
            local mason_lspconfig = require 'mason-lspconfig'
            mason_lspconfig.setup()

            mason_lspconfig.setup_handlers {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = '[R]e[n]ame' })
                            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[C]ode [A]ction' })
                            vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = '[G]oto [I]mplementation' })
                            vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, { buffer = bufnr, desc = '[H]over Documentation' })
                            vim.keymap.set('n', 'sd', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature [D]ocumentation' })
                        end,
                    }
                end,
            }
        end
    },

    {   -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
        config = function()
            local luasnip = require 'luasnip'
            luasnip.config.setup {}

            local cmp = require 'cmp'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete {},
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            }
        end
    },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim', opts = {} },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()
            vim.keymap.set('n', '<leader>fb', ':Neotree<CR>', {noremap = true, silent = true, desc = 'Toggle [F]ile [B]rowser'})
            vim.keymap.set('n', '<leader>ft', ':Neotree<CR>', {noremap = true, silent = true, desc = 'Toggle [F]ile [T]ree'})
            require("neo-tree").setup({
                auto_clean_after_session_restore = true,
                close_if_last_window = true,
                sources = { "filesystem", "buffers", "git_status" },
                source_selector = {
                    winbar = true,
                    content_layout = "center",
                    sources = {
                        { source = "filesystem", display_name = "File" },
                        { source = "buffers", display_name = "Bufs" },
                        { source = "git_status", display_name = "Git" },
                        { source = "diagnostics", display_name = "Diagnostic" },
                    },
                },
                default_component_configs = {
                    indent = { padding = 0 },
                },
                commands = {
                    parent_or_close = function(state)
                        local node = state.tree:get_node()
                        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
                            state.commands.toggle_node(state)
                        else
                            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                        end
                    end,
                    child_or_open = function(state)
                        local node = state.tree:get_node()
                        if node.type == "directory" or node:has_children() then
                            if not node:is_expanded() then -- if unexpanded, expand
                                state.commands.toggle_node(state)
                            else -- if expanded and has children, seleect the next child
                                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                            end
                        else -- if not a directory just open it
                            state.commands.open(state)
                        end
                    end,
                    copy_selector = function(state)
                        local node = state.tree:get_node()
                        local filepath = node:get_id()
                        local filename = node.name
                        local modify = vim.fn.fnamemodify

                        local results = {
                            e = { val = modify(filename, ":e"), msg = "Extension only" },
                            f = { val = filename, msg = "Filename" },
                            F = { val = modify(filename, ":r"), msg = "Filename w/o extension" },
                            h = { val = modify(filepath, ":~"), msg = "Path relative to Home" },
                            p = { val = modify(filepath, ":."), msg = "Path relative to CWD" },
                            P = { val = filepath, msg = "Absolute path" },
                        }

                        local messages = {
                            { "\nChoose to copy to clipboard:\n", "Normal" },
                        }
                        for i, result in pairs(results) do
                            if result.val and result.val ~= "" then
                                vim.list_extend(messages, {
                                    { ("%s."):format(i), "Identifier" },
                                    { (" %s: "):format(result.msg) },
                                    { result.val, "String" },
                                    { "\n" },
                                })
                            end
                        end
                        vim.api.nvim_echo(messages, false, {})
                        local result = results[vim.fn.getcharstr()]
                        if result and result.val and result.val ~= "" then
                            vim.fn.setreg("+", result.val)
                        end
                    end,
                    find_in_dir = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        require("telescope.builtin").find_files {
                            cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h"),
                        }
                    end,
                },
                window = {
                    width = 30,
                    mappings = {
                        ["<space>"] = false, -- disable space until we figure out which-key disabling
                        ["[b"] = "prev_source",
                        ["]b"] = "next_source",
                        O = "system_open",
                        Y = "copy_selector",
                        h = "parent_or_close",
                        l = "child_or_open",
                        o = "open",
                    },
                },
                filesystem = {
                    follow_current_file = { enabled = true },
                    hijack_netrw_behavior = "open_current",
                    use_libuv_file_watcher = true,
                },
                event_handlers = {
                    {
                        event = "neo_tree_buffer_enter",
                        handler = function(_) vim.opt_local.signcolumn = "auto" end,
                    },
                },
            })
        end
    },

    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },

    {
        "windwp/nvim-autopairs",
        opts = {}
    }
})
