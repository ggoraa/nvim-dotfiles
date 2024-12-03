require("voltangle.opts")
require("voltangle.keymaps")

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

require("lazy").setup({
	spec = "plugins",
	ui = {
		border = "rounded",
		size = {
			width = 0.8,
			height = 0.8,
		},
	},
})

local dap = require("dap")
local dapui = require("dapui")

-- nvim-dap
vim.keymap.set("n", "dc", dap.continue)
vim.keymap.set("n", "dp", dap.pause)
vim.keymap.set("n", "ds", function()
	dap.disconnect()
	dap.close()
end)
vim.keymap.set("n", "dt", dap.toggle_breakpoint)
vim.keymap.set("n", "dsi", dap.step_into)
vim.keymap.set("n", "dso", dap.step_over)
vim.keymap.set("n", "dr", dap.repl.open)

-- nvim-dap-ui
vim.keymap.set("n", "<leader>du", function()
	dapui.toggle()
	vim.api.nvim_exec2("Neotree toggle", {})
end)

local swift_lsp = vim.api.nvim_create_augroup("swift_lsp", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "swift" },
	callback = function()
		local root_dir = vim.fs.dirname(vim.fs.find({
			"Package.swift",
			".git",
		}, { upward = true })[1])
		local client = vim.lsp.start({
			name = "sourcekit-lsp",
			cmd = { "sourcekit-lsp" },
			root_dir = root_dir,
		})
		vim.lsp.buf_attach_client(0, client)
	end,
	group = swift_lsp,
})

vim.cmd.colorscheme("catppuccin")
