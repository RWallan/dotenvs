return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",

		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			ts.install({
				"bash",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"vim",
				"vimdoc",
				"python",
				"svelte",
				"typescript",
				"javascript",
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					if pcall(vim.treesitter.start) then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

						vim.wo.foldmethod = "expr"
						vim.wo.foldlevel = 99
						vim.wo.foldenable = true
					end
				end,
			})
		end,
	},
}
