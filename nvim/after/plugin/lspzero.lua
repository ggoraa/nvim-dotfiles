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

lsp.setup()
