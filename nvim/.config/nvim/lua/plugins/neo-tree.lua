return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>ee", ":Neotree toggle<CR>", desc = "Toogle file explorer", silent = true },
	},
	config = function()
		local neotree = require("neo-tree")
		neotree.setup({
			window = {
				width = 27,
				mappings = {
					["[b"] = "prev_source",
					["]b"] = "next_source",
				},
			},
		})
	end,
}
