local telescope_builtin = require('telescope.builtin')

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>ef", vim.cmd.Ex)
vim.keymap.set('n', '<leader>pf', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', telescope_builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

