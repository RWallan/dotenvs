return {
	"nickjvandyke/opencode.nvim",
	version = "*",
	init = function()
		vim.g.opencode_opts = {}
	end,
	keys = {
		{
			"<C-a>",
			function()
				require("opencode").ask("")
			end,
			mode = { "n", "x" },
			desc = "Ask OpenCode…",
		},
		{
			"<C-x>",
			function()
				require("opencode").select()
			end,
			mode = { "n", "x" },
			desc = "Select OpenCode…",
		},
		{
			"go",
			function()
				return require("opencode").operator("@this ")
			end,
			mode = { "n", "x" },
			expr = true,
			desc = "Append range to OpenCode",
		},
		{
			"goo",
			function()
				return require("opencode").operator("@this ") .. "_"
			end,
			expr = true,
			desc = "Append line to OpenCode",
		},
		{
			"<S-C-u>",
			function()
				require("opencode").command("session.half.page.up")
			end,
			desc = "Scroll OpenCode up",
		},
		{
			"<S-C-d>",
			function()
				require("opencode").command("session.half.page.down")
			end,
			desc = "Scroll OpenCode down",
		},
	},
}
