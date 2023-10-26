require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = true,
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    integrations = {
        cmp = true,
    }
})
