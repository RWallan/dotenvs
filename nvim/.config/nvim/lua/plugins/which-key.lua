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

        wk.add({
            { "<leader>f", group = "Find" },
            { "<leader>e", group = "Explorer" },
            { "<leader>b", group = "Buffer" },
            { "<leader>l", group = "LSP" },
            { "<leader>s", group = "Split" },
            { "<leader>g", group = "Git" },
            { "<leader>n", group = "Other" },
            { "<leader>x", group = "Trouble" },
            { "<leader>v", group = "Virtual Env" },
            { "<leader>r", group = "Resize" },
            { "<leader>w", group = "Session" },
            { "<leader>m", group = "Markdown" },
            { "<leader>t", group = "REPL" },
        })
    end,
}
