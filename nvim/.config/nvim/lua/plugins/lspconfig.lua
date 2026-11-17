return { -- LSP Plugins
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Carrega tipos do luv quando `vim.uv` aparece no arquivo
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog", "MasonUninstall" },
		opts = {},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			-- Garante que as capabilities do blink.cmp sejam registradas antes dos servers iniciarem
			"saghen/blink.cmp",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local function telescope(picker)
						return function()
							require("telescope.builtin")[picker]()
						end
					end

					map("<leader>lgd", telescope("lsp_definitions"), "Goto definition")
					map("<leader>lgr", telescope("lsp_references"), "Goto references")
					map("<leader>lgI", telescope("lsp_implementations"), "Goto implementation")
					map("<leader>lgD", vim.lsp.buf.declaration, "Goto declaration")
					map("<leader>lD", telescope("lsp_type_definitions"), "Type Definition")
					map("<leader>ls", telescope("lsp_document_symbols"), "Document symbols")
					map("<leader>lws", telescope("lsp_dynamic_workspace_symbols"), "Workspace symbols")
					map("<leader>ln", vim.lsp.buf.rename, "Rename")
					map("<leader>la", vim.lsp.buf.code_action, "Code action", { "n", "x" })
					map("<leader>ld", vim.diagnostic.open_float, "Show inline diagnostic")
					map("<leader>lS", "<cmd>LspRestart<CR>", "Restart LSP Server")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if not client then
						return
					end

					-- Destaca referências da palavra sob o cursor
					if client:supports_method("textDocument/documentHighlight", event.buf) then
						local highlight_augroup = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "user-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>lth", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle inlay hints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
				},
			})

			-- Configurações específicas por servidor (API nativa vim.lsp.config).
			-- As capabilities do blink.cmp já são aplicadas em `vim.lsp.config("*")` pelo próprio plugin.
			local servers = {
				marksman = {},
				pyright = {},
				-- Web / Svelte (o lspconfig já avisa o svelte ao salvar arquivos .js/.ts)
				ts_ls = {},
				cssls = {},
				svelte = {},
				eslint = {}, -- só ativa em projetos com config do eslint
				-- TOML (Cargo.toml, pyproject.toml...)
				taplo = {},
				-- Go
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							staticcheck = true,
							completeUnimported = true,
							analyses = {
								unusedparams = true,
								unusedwrite = true,
								nilness = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			for name, config in pairs(servers) do
				if next(config) then
					vim.lsp.config(name, config)
				end
			end

			-- Rust: o rust-analyzer vem do rustup (`rustup component add rust-analyzer`),
			-- assim acompanha a versão do toolchain do projeto (rust-toolchain.toml)
			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						check = { command = "clippy" },
						cargo = { allFeatures = true },
					},
				},
			})
			if vim.fn.executable("rust-analyzer") == 1 then
				vim.lsp.enable("rust_analyzer")
			end

			local ensure_installed = vim.tbl_keys(servers)
			vim.list_extend(ensure_installed, {
				"stylua",
				"ruff",
				"prettierd",
				"gofumpt",
				"goimports",
				"golangci-lint",
				"markdownlint",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- mason-lspconfig v2: habilita (vim.lsp.enable) automaticamente os servers instalados
			require("mason-lspconfig").setup({
				ensure_installed = {},
				-- stylua é usado via conform.nvim, não precisa rodar como LSP
				-- rust_analyzer é habilitado acima, a partir do rustup
				automatic_enable = { exclude = { "stylua", "rust_analyzer" } },
			})
		end,
	},
}
