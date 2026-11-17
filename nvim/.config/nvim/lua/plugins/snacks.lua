return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		input = {
			enabled = true,
		},

		picker = {
			enabled = true,

			win = {
				input = {
					keys = {
						["<a-o>"] = {
							"opencode_send",
							mode = { "n", "i" },
						},
					},
				},
			},

			actions = {
				opencode_send = function(picker)
					local opencode = require("opencode")

					local items = vim.tbl_map(function(item)
						return item.file
								and opencode.format({
									path = item.file,
									from = item.pos,
									to = item.end_pos,
								})
							or item.text
					end, picker:selected({ fallback = true }))

					opencode.prompt(table.concat(items, ", ") .. " ")
				end,
			},
		},
	},
}
