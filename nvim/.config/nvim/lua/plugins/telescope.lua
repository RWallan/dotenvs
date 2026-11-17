local function builtin(name, opts)
	return function()
		require("telescope.builtin")[name](type(opts) == "function" and opts() or opts)
	end
end

return { -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	cmd = { "Telescope" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>fh", builtin("help_tags"), desc = "Find help" },
		{ "<leader>fk", builtin("keymaps"), desc = "Find keymaps" },
		{ "<leader>ff", builtin("find_files"), desc = "Find files" },
		{ "<leader>fs", builtin("builtin"), desc = "Find select telescope" },
		{ "<leader>fw", builtin("grep_string"), desc = "Find current word" },
		{ "<leader>fg", builtin("live_grep"), desc = "Find by grep" },
		{ "<leader>fd", builtin("diagnostics"), desc = "Find diagnostics" },
		{ "<leader>fr", builtin("resume"), desc = "Find resume" },
		{ "<leader>f.", builtin("oldfiles"), desc = 'Find recent files ("." for repeat)' },
		{ "<leader>fb", builtin("buffers"), desc = "Find existing buffers" },
		{
			"/",
			builtin("current_buffer_fuzzy_find", function()
				return require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
			end),
			desc = "[/] Fuzzily search in current buffer",
		},
		{
			"<leader>f/",
			builtin("live_grep", { grep_open_files = true, prompt_title = "Live Grep in Open Files" }),
			desc = "Find [/] in Open Files",
		},
		{
			"<leader>fn",
			builtin("find_files", function()
				return { cwd = vim.fn.stdpath("config") }
			end),
			desc = "Find Neovim files",
		},
	},
	config = function()
		require("telescope").setup({})
		pcall(require("telescope").load_extension, "fzf")
	end,
}
