return {
	"akinsho/bufferline.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = "nvim-tree/nvim-web-devicons",
	keys = {
		{ "[b", "<cmd>bp<CR>", desc = "Go to previous buffer" },
		{ "]b", "<cmd>bn<CR>", desc = "Go to next buffer" },
		{ "<leader>bl", "<cmd>BufferLineCloseRight<CR>", desc = "Close all buffers to right" },
		{ "<leader>bh", "<cmd>BufferLineCloseLeft<CR>", desc = "Close all buffers to left" },
		{ "<leader>bC", "<cmd>BufferLineCloseOthers<CR>", desc = "Close all other buffers" },
		{
			"<leader>ba",
			function()
				-- Buffers com alterações não salvas são mantidos (o :bd avisa sobre eles)
				local ok, err = pcall(vim.cmd, "%bd")
				if not ok then
					vim.notify(err, vim.log.levels.WARN)
				end

				-- Se só restou o buffer vazio [No Name], troca pelo dashboard
				local listed = vim.fn.getbufinfo({ buflisted = 1 })
				local buf = vim.api.nvim_get_current_buf()
				if
					#listed <= 1
					and vim.api.nvim_buf_get_name(buf) == ""
					and not vim.bo[buf].modified
					and vim.bo[buf].buftype == ""
				then
					vim.cmd("Alpha")
					if vim.api.nvim_buf_is_valid(buf) and buf ~= vim.api.nvim_get_current_buf() then
						vim.api.nvim_buf_delete(buf, {})
					end
				end
			end,
			desc = "Close all buffers",
		},
	},
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
	end,
}
