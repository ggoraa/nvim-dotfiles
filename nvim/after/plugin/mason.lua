local mason = require("mason")
local lspconfig = require("mason-lspconfig")
local lspzero = require("lsp-zero")

mason.setup {}
lspconfig.setup {
	ensure_installed = {"tsserver", "rust_analyzer", "lua_ls"},
	handlers = { lspzero.default_setup }
}

