return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ensure_installed = {
                    "ruff",
                    "debugpy",
                    "pyright"
                }
            })
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "jsonls", -- JSON
                    "pyright",-- PYTHON
                    "remark_ls", -- MARKDOWN
                    "sqls", -- SQL
                    "tsserver" -- JAVASCRIPT
                }
            })
        end
    },
    {
        "jay-babu/mason-null-ls.nvim",
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = {
                    "stylua", -- LUA
                    "eslint_d", -- JS
                    "prettier", -- HTML
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities() -- Completions

            local lspconfig = require("lspconfig")
            lspconfig.pyright.setup({capabilities = capabilities}) -- Python LSP
            lspconfig.lua_ls.setup({capabilities = capabilities}) -- Lua LSP
            lspconfig.jsonls.setup({capabilities = capabilities}) -- Json LSP
            lspconfig.remark_ls.setup({capabilities = capabilities}) -- Markdown LSP
            lspconfig.sqls.setup({capabilities = capabilities}) -- SQL LSP
            lspconfig.tsserver.setup({capabilities = capabilities}) -- JavaScript LSP

            -- Keymaps padrões
            vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, {}) -- Abre o diagnóstico
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {}) -- Vai até o diagnóstico anterior
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {}) -- Vai até o diagnóstico posterior

            -- Mapeia as keys após o LSP acoplar no buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- Vai até a declaração do objeto
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Vai até a definição do objeto
                    vim.keymap.set("n", "<leader>ld", vim.lsp.buf.hover, opts) -- Mostra informações do objeto
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- Executa os code actions disponíveis
                end
            })
        end
    }
}
