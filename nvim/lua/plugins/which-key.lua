return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {},
    config = function()
        local wk = require("which-key")

        wk.register({
            ["<leader>"] = {
                f = { name = "Find" },
                e = { name = "Explorer" },
                b = { name = "Buffer" },
                l = { name = "LSP" },
                s = { name = "Split" },
                g = { name = "Git" },
                n = { name = "Other" },
                x = { name = "Trouble" }
            },
        })
    end,
}