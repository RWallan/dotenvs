return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvimtools/none-ls-extras.nvim" },
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- LINTERS --
				-- require("none-ls.diagnostics.ruff"),
				require("none-ls.diagnostics.eslint_d"),
				null_ls.builtins.diagnostics.golangci_lint,
				null_ls.builtins.diagnostics.sqlfluff.with({
					extra_args = { "--dialect", "bigquery" },
				}),
				-- null_ls.builtins.formatting.sql_formatter.with({
				--     extra_args = { "--tabWidth", "4" },
				-- }),

				-- FORMATTERS --
				null_ls.builtins.formatting.prettierd, -- HTML
				null_ls.builtins.formatting.stylua, -- LUA
				require("none-ls.formatting.eslint"),
				require("none-ls.formatting.ruff"),
				null_ls.builtins.formatting.gofmt,

				-- CODE ACTIONS --
				null_ls.builtins.code_actions.gomodifytags,
			},
		})

		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format file " })
	end,
}
