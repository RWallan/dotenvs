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
			blink_cmp = { style = "bordered" },
			fidget = true,
			gitsigns = true,
			mason = true,
			mini = { enabled = true },
			native_lsp = { enabled = true },
			snacks = { enabled = true },
			treesitter = true,
			which_key = true,
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
