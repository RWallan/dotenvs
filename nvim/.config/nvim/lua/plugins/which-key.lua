return {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>b", group = "Buffer" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>n", group = "Other" },
			{ "<leader>r", group = "Resize" },
			{ "<leader>s", group = "Split" },
			{ "<leader>w", group = "Workspace" },
		})
	end,
}
