vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>vs", vim.cmd.vsplit)
map("n", "<leader>hs", vim.cmd.split)
map("n", "<leader>l", vim.cmd.Lazy)
