local ctp_feline = require('catppuccin.groups.integrations.feline')

require("feline").setup({
    components = ctp_feline.get(),
})
require('feline').winbar.setup()
require('feline').statuscolumn.setup()

