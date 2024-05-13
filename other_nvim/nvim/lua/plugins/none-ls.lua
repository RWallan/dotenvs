return {
    "nvimtools/none-ls.nvim",
    dependencies = {"nvimtools/none-ls-extras.nvim"},
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                -- LINTERS --

                -- FORMATTERS --
                null_ls.builtins.formatting.prettier, -- HTML
                null_ls.builtins.formatting.stylua, -- LUA
            },
        })

        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {})
    end,
}

