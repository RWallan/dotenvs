return { -- Autoformat
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Sem fallback para LSP em linguagens sem estilo padronizado
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 500,
				lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback",
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			go = { "gofumpt", "goimports" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
		},
	},
}
