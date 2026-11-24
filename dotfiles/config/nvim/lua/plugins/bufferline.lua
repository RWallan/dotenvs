-- bufferline.nvim: abas dos buffers abertos na parte superior
return {
	"akinsho/bufferline.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local C = require("catppuccin.palettes").get_palette()
		local highlights = require("catppuccin.special.bufferline").get_theme()()
		highlights.fill = { bg = C.base } -- mesma cor do editor (sem faixa crust/preta)
		return {
		highlights = highlights,
		options = {
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			offsets = {
				{ filetype = "snacks_picker_list", text = "Explorer", text_align = "left", separator = true },
			},
		},
		}
	end,
}
