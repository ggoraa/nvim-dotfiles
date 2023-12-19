require("ggoraa.opts")

-- bootstrap lazy.nvim
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

require("lazy").setup {
    "folke/neodev.nvim",
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {

            flavour = "mocha", -- latte, frappe, macchiato, mocha
            transparent_background = true,
            background = { -- :h background
                light = "latte",
                dark = "mocha",
            },
            integrations = {
                cmp = true,
                gitsigns = true
            }
        },
        config = function (_, opts)

            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            require'nvim-treesitter.configs'.setup {
                -- A list of parser names, or "all"
                ensure_installed = { "vimdoc", "javascript", "typescript", "c", "zig", "lua", "rust", "cpp", "python", "qmljs", "qmldir", "gitcommit"},

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
            }

            -- vim.filetype.add {
            --     extension = {
            --         mc = "mc"
            --     }
            -- }

            -- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
            -- parser_config.monkeyc = {
            --     install_info = {
            --         -- url = "~/.config/nvim/plugin/tree-sitter-monkeyc",
            --         url = "~/Documents/GitHub/tree-sitter-monkeyc",
            --         files = {"src/parser.c"},
            --     },
            --     filetype = "mc",
            -- }
        end
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            --- Uncomment these if you want to manage LSP servers from neovim
            {
                'williamboman/mason.nvim',
                config = function (_, _)
                    local mason = require("mason")
                    local lspconfig = require("mason-lspconfig")
                    local lspzero = require("lsp-zero")
                    lspzero.extend_lspconfig()

                    mason.setup {
                    }
                    lspconfig.setup {
                        ensure_installed = {"tsserver", "clangd", "clang-format", "rust_analyzer", "lua_ls", "pyright"},
                        handlers = { lspzero.default_setup }
                    }

                    require("lspconfig").clangd.setup {
                        capabilities = capabilities,
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--clang-tidy",
                            "--header-insertion=iwyu",
                            "--compile-commands-dir=build",
                            "--completion-style=detailed",
                            "--function-arg-placeholders"
                        },
                        init_options = {
                            usePlaceholders = true,
                            completeUnimported = true,
                            clangdFileStatus = true,
                            semanticHighlighting = true
                        },
                        on_attach = on_attach,
                        flags = { debounce_text_changes = 150 }
                    }

                    require("mason-nvim-dap").setup({
                        ensure_installed = {"codelldb"}
                    })
                end
            },
            'williamboman/mason-lspconfig.nvim',

            -- LSP Support
            'neovim/nvim-lspconfig',
            -- Autocompletion
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
        },
        config = function(_, _)

            local lsp = require("lsp-zero")
            local cmp = require("cmp")

            lsp.preset("recommended")

            local cmp_select = {behavior = cmp.SelectBehavior.Select}
            cmp.setup {
                mapping = cmp.mapping.preset.insert {
                    ['<C-[>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-]>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-\\>'] = cmp.mapping.confirm({ select = true }),
                    ["<A-\\>"] = cmp.mapping.abort(),
                }
            }

            lsp.on_attach(function (client, bufnr)
                local opts = {buffer = bufnr, remap = false}

                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "<leader>vn", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "<leader>vp", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts) 
            end)

            lsp.setup()
        end
    },
    {"theprimeagen/harpoon"},
    {"mbbill/undotree"},
    {"tpope/vim-fugitive"},
    {"tpope/vim-rhubarb"},
    {"tpope/vim-commentary"},
    {
        'freddiehaddad/feline.nvim',
        opts = {},
        config = function (_, opts)
            local ctp_feline = require('catppuccin.groups.integrations.feline')

            require("feline").setup({
                components = ctp_feline.get()
            })

            local winbar_components = {
                active = {},
                inactive = {}
            }

            table.insert(winbar_components.active, {})
            table.insert(winbar_components.active[1], {
                provider = {
                    name = 'file_info',
                    opts = {
                        type = 'relative'
                    }
                },
            })

            require('feline').winbar.setup({
                components = winbar_components
            })

            -- later to be set up, if i feel that way
            -- require('feline').statuscolumn.setup()

        end
    },
    {
        'saecki/crates.nvim',
        event = { "BufRead Cargo.toml" },
        tag = 'stable',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    },
    {"nvim-lua/plenary.nvim"},
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {}},
    {"theprimeagen/vim-be-good"},
    -- when nvim 0.10.1 releases, enable this plugin
    -- 	use {
    -- 		'Bekaboo/dropbar.nvim',
    -- 		requires = {
    -- 			'nvim-telescope/telescope-fzf-native.nvim'
    -- 		}
    -- 	}
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true
    },
    {
       "m4xshen/autoclose.nvim",
       config = true
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            -- empty setup using defaults
            require("nvim-tree").setup({
                view = {
                    width = 40,
                }
            })
        end},
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            current_line_blame = true,
        },
        config = true,
    },
    {
        "mfussenegger/nvim-dap",
        config = function(_, _)
            local dap = require("dap")

            dap.adapters.codelldb = {
                type = 'server',
                port = "${port}",
                executable = {
                    command = '/usr/local/bin/codelldb',
                    args = {
                        "--port", "${port}",
                        "--liblldb", "/usr/local/opt/llvm/lib/liblldb.dylib"
                    },
                }
            }

            local codelldbConf = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    lldb = {
                        library = "/usr/local/opt/llvm/lib/liblldb.dylib"
                    }
                }
            }

            dap.configurations.cpp = codelldbConf
            dap.configurations.c = codelldbConf

            require("dapui").setup()
        end
    },
    {"rcarriga/nvim-dap-ui"},
    {"jay-babu/mason-nvim-dap.nvim"},
    {
        "nvim-pack/nvim-spectre",
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    {"yorickpeterse/nvim-window"},
}


local telescope_builtin = require('telescope.builtin')
local trouble = require("trouble")
local dap = require("dap")
local dapui = require("dapui")
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
local nvwindow = require('nvim-window')
local nvimtree_api = require("nvim-tree.api")

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>ef", vim.cmd.Ex)
vim.keymap.set("n", "<leader>vs", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>hs", vim.cmd.split)

-- telescope
vim.keymap.set('n', '<leader>pf', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', telescope_builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- trouble
vim.keymap.set("n", "<leader>xx", function() trouble.toggle() end)
vim.keymap.set("n", "<leader>xw", function() trouble.toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() trouble.toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() trouble.toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() trouble.toggle("loclist") end)
vim.keymap.set("n", "<leader>xR", function() trouble.toggle("lsp_references") end)

-- fugitive
vim.keymap.set("n", "<leader>gds", function() vim.cmd(":Gvdiffsplit") end)
vim.keymap.set("n", "<leader>gl", function() vim.cmd(":G log") end)
vim.keymap.set("n", "<leader>gs", function() vim.cmd(":G") end)
vim.keymap.set("n", "<leader>gp", function () vim.cmd(":Git push") end)

-- todo-comments
vim.keymap.set("n", "tdt", function() vim.cmd(":TodoTrouble") end)

-- harpoon
vim.keymap.set("n", "<leader>h", harpoon_mark.add_file)
vim.keymap.set("n", "<C-a>", harpoon_ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>1", function() harpoon_ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon_ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon_ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon_ui.nav_file(4) end)
vim.keymap.set("n", "<leader>5", function() harpoon_ui.nav_file(5) end)
vim.keymap.set("n", "<leader>6", function() harpoon_ui.nav_file(6) end)
vim.keymap.set("n", "<leader>7", function() harpoon_ui.nav_file(7) end)
vim.keymap.set("n", "<leader>8", function() harpoon_ui.nav_file(8) end)
vim.keymap.set("n", "<leader>9", function() harpoon_ui.nav_file(9) end)

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- nvim-spectre
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})

-- nvim-dap
vim.keymap.set("n", "dc", dap.continue)
vim.keymap.set("n", "dp", dap.pause)
vim.keymap.set("n", "ds", function ()
   dap.disconnect()
   dap.close()
end)
vim.keymap.set("n", "dt", dap.toggle_breakpoint)
vim.keymap.set("n", "dsi", dap.step_into)
vim.keymap.set("n", "dso", dap.step_over)
vim.keymap.set("n", "dr", dap.repl.open)

-- nvim-dap-ui
vim.keymap.set("n", "<leader>du", function ()
    dapui.toggle()
    nvimtree_api.tree.toggle()
end)

-- nvim-window
vim.keymap.set("n", "<A-w>", nvwindow.pick)
