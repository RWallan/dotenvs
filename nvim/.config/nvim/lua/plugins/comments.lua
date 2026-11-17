-- Comentários usam o `gc`/`gcc` nativo do Neovim (0.10+).
return {
	{
		-- Ajusta o commentstring conforme o contexto treesitter (jsx, svelte, html...)
		"JoosepAlviste/nvim-ts-context-commentstring",
		opts = { enable_autocmd = false },
		init = function()
			local get_option = vim.filetype.get_option
			---@diagnostic disable-next-line: duplicate-set-field
			vim.filetype.get_option = function(filetype, option)
				if option == "commentstring" then
					local ok, cs = pcall(function()
						return require("ts_context_commentstring.internal").calculate_commentstring()
					end)
					if ok and cs then
						return cs
					end
				end
				return get_option(filetype, option)
			end
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous todo comment",
			},
		},
		opts = {
			highlight = {
				keyword = "",
				after = "",
			},
		},
	},
}
