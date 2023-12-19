vim.opt.number = true
vim.opt.relativenumber = true 
vim.opt.rnu = true
vim.opt.nu = true

vim.opt.swapfile = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.termguicolors = true

vim.opt.laststatus = 3 -- global status line

vim.api.nvim_exec ('language en_US', true)

-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
