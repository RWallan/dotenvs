local parsers = {
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
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	-- A branch main não suporta lazy-loading
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		ts.setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- Instala apenas os parsers que ainda faltam
		local installed = ts.get_installed()
		local missing = vim.tbl_filter(function(p)
			return not vim.list_contains(installed, p)
		end, parsers)
		if #missing > 0 then
			ts.install(missing)
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
			callback = function(args)
				if pcall(vim.treesitter.start, args.buf) then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo.foldmethod = "expr"
					vim.wo.foldlevel = 99
					vim.wo.foldenable = true
				end
			end,
		})
	end,
}
