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
			go = { "goimports", "gofumpt" },
			rust = { "rustfmt" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			-- Usa o prettier do projeto (com prettier-plugin-svelte) quando houver config;
			-- senão cai no formatador do svelte-language-server (lsp_format = "fallback")
			svelte = function(bufnr)
				local has_prettier_config = vim.fs.root(bufnr, function(name)
					return name:match("^%.prettierrc") ~= nil or name:match("^prettier%.config%.") ~= nil
				end)
				return has_prettier_config and { "prettierd" } or {}
			end,
		},
	},
}
