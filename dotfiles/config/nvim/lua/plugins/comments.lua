-- Comentários usam o `gc`/`gcc` nativo do Neovim (0.10+), que já respeita
-- injeções do treesitter (ex.: <script>/<style> no Svelte).
return {
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TodoQuickFix", "TodoLocList" }, -- picker: <leader>ft (snacks)
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
