-- Color schema
return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	opts = {
		-- Integrações explícitas: evita varrer todos os plugins do lazy a cada startup
		auto_integrations = false,
		integrations = {
			alpha = true,
			blink_cmp = { style = "bordered" },
			fidget = true,
			gitsigns = true,
			indent_blankline = { enabled = true },
			mason = true,
			mini = { enabled = true },
			native_lsp = { enabled = true },
			neotree = true,
			snacks = { enabled = true },
			telescope = { enabled = true },
			treesitter = true,
			which_key = true,
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
