return {
	{
		"saghen/blink.cmp",
		version = "2.*",
		event = { "InsertEnter", "CmdlineEnter" },

		dependencies = {
			"saghen/blink.lib",
		},

		build = function()
			require("blink.cmp").build():pwait()
		end,

		opts = {
			sources = {
				default = { "lsp", "buffer" },

				providers = {
					lsp = {
						fallbacks = {},
					},
				},
			},
		},
	},
}
