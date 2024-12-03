return {
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
                gitsigns = true,
            },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        version = "^3.0",
        init = function()
            -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
            -- because `cwd` is not set up properly.
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
                desc = "Start Neo-tree with directory",
                once = true,
                callback = function()
                    if package.loaded["neo-tree"] then
                        return
                    else
                        local stats = vim.uv.fs_stat(vim.fn.argv(0))
                        if stats and stats.type == "directory" then
                            require("neo-tree")
                        end
                    end
                end,
            })
        end,
        opts = {
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function(arg)
                        vim.opt.relativenumber = true
                    end,
                }
            },
            filesystem = {
                filtered_items = {
                    visible = true 
                }
            }
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },
    {
    },
    {
        "ggandor/leap.nvim",
        enabled = false, -- TODO: Reenable once I get around to actually learning how to use this
        dependencies = { "tpope/vim-repeat" }
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        version = "^3.0",
        opts = {},
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    "folke/neodev.nvim",
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>pf",
                function()
                    require("telescope.builtin").find_files()
                end,
            },
            {
                "<leader>gf",
                function()
                    require("telescope.builtin").git_files()
                end,
            },
            {
                "<leader>ps",
                function()
                    require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
                end,
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        version = ">=0.9",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- A list of parser names, or "all"
                ensure_installed = {
                    "vimdoc",
                    "swift",
                    "javascript",
                    "typescript",
                    "c",
                    "zig",
                    "lua",
                    "rust",
                    "cpp",
                    "python",
                    "qmljs",
                    "qmldir",
                    "gitcommit",
                    "svelte",
                },

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
            })
        end
    },
    {
        "theprimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            { "<leader>h", function() require("harpoon").list():add() end },
            { "<C-S>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end },
            { "<leader>1", function() require("harpoon"):list():select(1) end },
            { "<leader>2", function() require("harpoon"):list():select(2) end },
            { "<leader>3", function() require("harpoon"):list():select(3) end },
            { "<leader>4", function() require("harpoon"):list():select(4) end },
            { "<leader>5", function() require("harpoon"):list():select(5) end },
            { "<leader>6", function() require("harpoon"):list():select(6) end },
            { "<leader>7", function() require("harpoon"):list():select(7) end },
            { "<leader>8", function() require("harpoon"):list():select(8) end },
            { "<leader>9", function() require("harpoon"):list():select(9) end },
        },
    },
    {
        "mbbill/undotree",
        version = "^6.0",
        keys = {
            {
                "<leader>u",
                function()
                    vim.cmd.UndotreeToggle()
                end,
            },
        },
    },
    {
        "tpope/vim-fugitive",
        version = "^3.0",
        keys = {
            {
                "<leader>gds",
                "<cmd>Gvdiffsplit<CR>",
                desc = [[Show staged and working tree versions of the
                file side by side]],
            },
            { "<leader>gl", "<cmd>G log<CR>", desc = "Git log" },
            { "<leader>gs", "<cmd>G<CR>", desc = "Git status" },
            { "<leader>gp", "<cmd>G push<CR>", desc = "Git push" },
            { "<leader>gfp", "<cmd>G push --force<CR>", desc = "Git force push" },
            { "<leader>gP", "<cmd>G pull<CR>", desc = "Git pull" },
        },
    },
    "tpope/vim-rhubarb",
    { "tpope/vim-commentary", version = "^1.0" },
    {
        "freddiehaddad/feline.nvim",
        version = "^1.0",
        opts = {},
        config = function(_, opts)
            local ctp_feline = require("catppuccin.groups.integrations.feline")

            require("feline").setup({
                components = ctp_feline.get(),
            })

            local winbar_components = {
                active = {},
                inactive = {},
            }

            table.insert(winbar_components.active, {})
            table.insert(winbar_components.active[1], {
                provider = {
                    name = "file_info",
                    opts = {
                        type = "relative",
                    },
                },
            })

            require("feline").winbar.setup({
                components = winbar_components,
            })

            -- later to be set up, if i feel that way
            -- require('feline').statuscolumn.setup()
        end,
    },
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        tag = "stable",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "folke/trouble.nvim",
        version = "^3.0",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    "theprimeagen/vim-be-good",
    {
        "Bekaboo/dropbar.nvim",
        version = "^9.0",
        dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
    },
    {
        "folke/todo-comments.nvim",
        version = "^1.0",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {},
        lazy = false,
        keys = {
            { "<leader>tdt", "<cmd>Trouble todo<CR>" },
            { "<leader>tts", "<cmd>TodoTelescope<CR>" },
        },
    },
    {
        "m4xshen/autoclose.nvim",
        opts = {}
    },
    {
        "lewis6991/gitsigns.nvim",
        version = "~0.9",
        opts = {
            current_line_blame = true,
        },
    },
    {
        "mfussenegger/nvim-dap",
        version = "~0.8",
        config = function(_, _)
            local dap = require("dap")

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "/usr/local/bin/codelldb",
                    args = {
                        "--port",
                        "${port}",
                        "--liblldb",
                        "/usr/local/opt/llvm/lib/liblldb.dylib",
                    },
                },
            }

            local codelldbConf = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    lldb = {
                        library = "/usr/local/opt/llvm/lib/liblldb.dylib",
                    },
                },
            }

            dap.configurations.cpp = codelldbConf
            dap.configurations.c = codelldbConf

            require("dapui").setup()
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        version = "^4.0",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
    },
    "jay-babu/mason-nvim-dap.nvim",
    {
        "yorickpeterse/nvim-window",
        keys = {
            {
                "<A-w>",
                function()
                    require("nvim-window").pick()
                end,
            },
        },
    },
    {
        "petertriho/nvim-scrollbar",
        config = function()
            require("scrollbar").setup({
                show_in_active_only = true,
                -- set_highlights = true,
            })
        end,
    },
}
