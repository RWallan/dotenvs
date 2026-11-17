return {
	{
		"saghen/blink.cmp",
		version = "2.*",

		dependencies = {
			"saghen/blink.lib",
		},

		build = function()
			require("blink.cmp").build():pwait()
		end,

		opts = {
			sources = {
				default = { "lsp", "buffer" },

				per_filetype = {
					opencode_ask = { "lsp", "buffer" },
				},

				providers = {
					lsp = {
						fallbacks = {},
					},
				},
			},
		},
	},
}
