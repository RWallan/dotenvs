return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>ee", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
	},
	opts = {
		window = {
			width = 27,
			mappings = {
				["[b"] = "prev_source",
				["]b"] = "next_source",
			},
		},
	},
}
