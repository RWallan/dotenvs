return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"bashls", -- bash
				"cssls", -- css
				"dockerls", -- docker
				"docker_compose_language_service", -- docker compose
				"html", -- html
				"jsonls", -- json
				"tsserver", -- javascript
				"lua_ls", -- lua
				"marksman", -- markdown
				"pyright", -- python
				"sqlls", -- sql
				"taplo", -- toml
                "volar", -- vue
				"yamlls", -- yaml
                "gopls", -- golang
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"eslint_d", -- js
				"prettier", -- html/js
				"ruff_lsp", -- python
				"stylua", -- lua
                "sql-formatter", -- SQL Formatter
                "sqlfluff", -- SQL Linter
                "golangci-lint",
                "gomodifytags",
			},
		})
	end,
}
