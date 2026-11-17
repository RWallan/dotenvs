return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = "nvim-tree/nvim-web-devicons",
	init = function()
		-- Evita a statusline "piscar" vazia até o lualine carregar
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			vim.o.statusline = " "
		else
			vim.o.laststatus = 0
		end
	end,
	opts = function()
		vim.o.laststatus = vim.g.lualine_laststatus
		return {}
	end,
}
