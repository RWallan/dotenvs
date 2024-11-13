return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			"                   /^\\     .",
			"              /\\   'V'",
			"             /__\\   I      O  o",
			"            //..\\\\  I     .",
			"            \\].`[/  I",
			"            /l\\/j\\  (]    .  O",
			"           /. ~~ ,\\/I          .",
			"           \\\\L__j^\\/I       o",
			"            \\/--v}  I     o   .",
			"            |    |  I   _________",
			"            |    |  I c(`       ')o",
			"            |    l  I   \\.     ,/      -Lets Codar",
			"          _/j  L l\\_!  _//^---^\\\\_",
			"       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~        ",
		}

		-- set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New File", "<cmd>enew<CR>"),
			dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>Neotree toggle<cr>"),
			dashboard.button("SPC ff", "�  > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fg", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		}

		alpha.setup(dashboard.opts)
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
		vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			pattern = "BDeletePre *",
			group = "alpha_on_empty",
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				local name = vim.api.nvim_buf_get_name(bufnr)

				if name == "" then
					vim.cmd([[:Alpha | bd#]])
				end
			end,
		})
	end,
}
