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
		return {
			sections = {
				lualine_z = {
					{
						-- Status do OpenCode, sem forçar o carregamento do plugin
						function()
							if not package.loaded.opencode then
								return ""
							end
							return require("opencode").statusline()
						end,
					},
				},
			},
		}
	end,
}
