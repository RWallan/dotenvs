return {
	{

		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local bufferline = require("bufferline")
			bufferline.setup({
				options = {
					style_preset = bufferline.style_preset.minimal,
					diagnostics = "nvim_lsp",
					separator_style = { "", "" },
					show_buffer_close_icons = false,
				},
				highlights = {
					buffer_visible = {
						bg = "",
					},
				},
			})

			local keymap = vim.keymap
			keymap.set("n", "[b", "<cmd>bp<CR>", { desc = "Go to previous buffer" })
			keymap.set("n", "]b", "<cmd>bn<CR>", { desc = "Go to next buffer" })
			keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseRight<CR>", { desc = "Close all buffers to right" })
			keymap.set("n", "<leader>bh", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close all buffers to left" })
			keymap.set("n", "<leader>bC", "<cmd>BufferLineCloseOther<CR>", { desc = "Close all other buffers" })
			keymap.set("n", "<leader>ba", "<cmd>%bd<CR>", { desc = "Close all buffers" })
		end,
	},
}
