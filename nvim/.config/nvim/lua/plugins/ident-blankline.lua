return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		scope = {
			enabled = true,
			show_start = false,
			show_end = false,
		},

		indent = {
			smart_indent_cap = true,
			char = "┊",
		},
	},
}
