return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	cmd = "Alpha",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⢀⠀⠀⠀⠀⡀⠀⠀⠀⠀⡀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠒⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠶⢾⠀⠀⠀⢸⢧⠀⠀⠀⡰⡇⠀⠊⠀⢀⡴⢺⠇⠀⠀⡠⠊⠁⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣇⣿⣀⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠀⠀⢀⠄⠂⠀⠀⢠⣼⠰⠾⠀⠀⢀⡟⠈⢧⠀⡴⠁⡇⢀⡤⠚⠁⠀⡼⠀⠀⠈⢀⢤⠆⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠠⡀⠀⠀⠀⣞⠰⣿⣛⠢⠘⠦⣦⣠⣀⠠⠀⠀⠀⡴⠊⠀⠠⠔⠁⠀⠀⠀⠀⠀⢠⡄⠀⠀⡤⡸⠁⠀⠈⠛⠀⢀⣙⡉⣠⣤⣤⠀⡇⢀⡤⠚⠁⡼⠀⠀⠀",
			"⠀⠀⠀⠀⠀⣀⡀⠀⠈⠓⢄⢸⡿⣀⣡⠤⠴⢲⡒⠒⠤⣍⡓⠷⣤⣊⠀⠀⣀⡀⠠⠒⠉⠀⠀⠀⢠⡇⠘⠦⢚⣁⠁⠀⣶⡾⠟⠿⣿⠟⢸⣿⣥⡁⠀⠛⠁⠀⠀⢰⠃⠀⣀⡀",
			"⠀⠀⠀⠀⠀⠀⣀⣉⣑⠒⣰⣟⡫⢅⣀⡀⠀⠀⢧⠀⠀⠀⠊⣳⣲⠽⢿⣉⣱⠃⠀⠒⠒⠀⠀⠀⡾⠀⠀⠀⣿⡏⠀⢸⣿⠾⠃⢀⣿⠀⣤⣤⣿⠏⠀⠀⠀⠀⢀⡈⠋⠉⡽⠁",
			"⠀⠀⠀⠀⠈⠉⠀⠀⣀⢼⣫⠅⠠⢭⠶⠾⢭⣓⣶⣷⣦⣤⣞⢳⣾⠀⠀⠨⠙⡆⠀⠀⠀⠲⣖⠚⠁⠀⠀⢀⣿⣇⣤⣸⣿⣾⠇⠘⠟⠀⠉⠉⢁⣤⣆⠀⣾⣿⠿⣿⣷⠸⣃⠀",
			"⠀⠀⠀⠀⠀⠠⠐⠉⠀⢿⣥⡄⠠⠤⠒⣋⣽⣿⣿⠉⠻⡿⣿⢣⣶⣷⠤⠤⢞⣀⣀⠀⠀⠀⠈⣳⡄⠀⠀⠸⠿⠛⠋⣨⣥⣤⡀⣶⣿⣿⣷⡀⢸⡿⣿⠀⣿⣿⣴⣿⠏⢀⡝⠁",
			"⠀⠀⠀⠀⠀⣀⠴⠖⠒⠪⠭⣄⡀⠰⣤⣀⢻⣿⣿⠀⠈⠁⠈⢗⣽⡿⣿⢅⡒⠤⢄⡉⠀⠠⣾⣁⠀⣠⣶⣿⣷⡄⣼⡿⠛⣿⣷⣿⡇⠘⣿⡇⣿⣧⣿⡇⣿⣿⢻⣷⡄⢫⡀⠀",
			"⠀⠀⠀⠀⠠⡇⠀⠀⣀⣀⡀⠀⠉⠳⢄⠛⢆⣿⣿⡇⣾⣰⣰⣿⠏⢀⣿⠑⢌⠑⢄⠈⠂⣠⠞⠁⣰⣿⠏⠈⠋⢱⣿⡇⠀⣿⡟⣿⣇⣼⡿⢹⣿⠛⢻⣿⢹⠿⠀⠛⠛⢀⣱⡄",
			"⠀⠀⠀⠀⣠⠵⠚⢉⡁⠀⠉⢣⠒⠠⣀⡑⠦⣈⠻⢿⣷⣷⡿⠃⢀⣾⠃⠀⠀⠢⠀⣠⣾⠥⣤⠀⣿⣿⠀⢀⣤⡸⣿⣧⣴⣿⠃⣿⡿⠟⠁⠛⠋⠀⡀⡀⢠⡖⠶⠶⠦⠽⢦⠀",
			"⠀⠀⢠⠞⠁⠀⠀⠀⠈⠢⡀⠀⡇⠀⠀⠀⢶⠨⡙⠲⠤⣄⡤⠶⠋⣥⣀⠀⠀⠀⠀⣠⠀⣰⠇⠀⢻⣿⣶⣿⡿⠁⠙⠛⠛⠁⣀⡤⣄⣠⠞⠉⠳⢤⡀⠁⢸⠀⠀⢠⣤⢴⠀⠀",
			"⠀⢀⣫⠔⠂⠉⠉⠐⠤⡀⠀⡸⠁⠀⠀⠀⢸⠀⢸⠀⠀⠀⣴⠀⣀⣀⢈⡇⠀⠠⠊⠀⠴⠷⠒⣷⠀⠉⠉⣁⣤⡆⠀⣠⡴⠚⠁⠀⠈⠁⠀⢀⠀⡀⠉⠳⢼⡀⢀⣼⢠⡾⠀⠀",
			"⠀⡞⠀⣀⡤⠄⣀⠀⠄⡈⢢⡁⠀⠀⠀⠀⡾⠀⢸⡇⠀⠀⡗⠀⠹⣿⣷⡀⠀⠀⠀⣠⠄⠀⢠⠇⣠⠴⠋⠁⣼⡵⠚⠁⠀⠀⡠⣯⣮⢽⢵⢭⢯⡷⣄⠀⠀⠀⠈⠁⠀⠀⠀⠀",
			"⢀⡼⠋⠀⣀⡤⠤⠤⢤⣈⢺⠁⠀⠀⠀⢸⠃⠀⢸⠀⠀⠀⣇⠀⠀⠈⠻⣷⡀⠀⠊⠀⠀⢀⡿⠚⠁⠀⠀⠀⠁⢀⣠⠤⣖⠺⣗⠫⠩⠈⠈⡡⠦⠤⠜⠁⠀⠀⡀⠒⠤⢄⠀⠀",
			"⠈⣆⢠⠚⠁⠀⢀⣠⠴⠶⢭⣀⠀⣀⣀⣀⡀⠀⣸⠀⠀⠀⢘⡤⠖⠚⠓⢲⡹⡄⠀⠀⠀⠈⠀⠀⣀⡠⣾⣿⣮⣝⠘⣧⠨⠖⠋⠒⠢⠴⠋⠀⠀⠀⠀⠀⠤⡀⠈⠑⠢⣀⠀⠀",
			"⠀⠹⡀⢠⡀⣰⠋⠀⣠⠖⢀⣹⡷⣄⠀⠀⠉⠒⠇⢀⡠⠞⠁⠀⠀⢠⠖⠉⠈⠵⡄⣀⡤⡔⢶⠹⡅⣼⣯⡻⣿⢿⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠢⢄⠀⠈⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠈⠢⣁⠙⠷⣾⣁⣶⠟⣡⡾⣫⡿⣶⣤⡒⠊⠁⠀⠀⣀⠴⢄⠸⣄⣤⣔⢾⠹⡌⢧⢹⣈⠧⠗⣸⣿⡃⢂⡾⠁⠀⠀⢀⠄⠀⠀⠀⡾⢷⡄⠀⠀⠀⠉⠢⣀⠀⠀⠀⠀⠀",
			"⠀⠀⢀⡴⠋⣠⠴⠀⠈⠙⠾⢯⣾⡡⣾⣿⣿⣿⣷⣆⠊⣩⣄⢴⢺⡙⡟⢮⡸⣌⡧⠕⠚⣩⠖⠋⣀⠈⢉⡴⠋⠀⠀⠀⡰⠁⠀⠀⠐⠾⢃⣤⠃⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀",
			"⠀⢀⠎⢀⡞⠁⠀⠀⠀⠀⠀⡀⠉⢿⣷⣿⣿⣟⣿⡾⠇⠸⣿⡎⢇⡱⠼⢒⠩⠀⠀⠘⠸⣇⠹⢄⣨⡷⠋⠀⠀⠀⢀⠜⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠸⣀⣼⠁⠀⠀⠀⠀⢠⢴⣷⣆⢲⣍⡛⠛⠛⠉⣴⡆⠀⠙⠋⢠⠰⡀⠀⠀⠘⠢⢄⣀⠈⠓⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⢀⡏⠸⡀⠀⠀⠀⠀⠈⢿⣞⣿⡄⠻⡷⠀⠀⠀⠈⠀⠀⠀⠀⠀⠑⠪⠭⠭⡍⢳⠀⠨⠭⠳⠦⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⣼⠳⣄⢳⡀⠀⠀⠀⠀⠘⣯⠼⢏⠀⢾⡷⠀⠀⠠⠄⣀⠤⠒⢒⣒⠒⠒⣉⠴⠃⠀⠀⠀⣠⠤⠖⠚⣓⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠹⡀⠈⢦⠳⡀⠀⠀⠀⢠⣤⠀⢈⠆⡤⣄⠀⠞⣠⠚⡡⠒⠉⠀⠀⠀⠀⠀⠀⠀⣠⠖⠉⠀⠀⠀⠉⠉⠙⠳⢦⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠙⢄⠀⠣⠙⠄⠀⢠⢏⡝⠀⠜⡀⠙⠁⡠⠚⣡⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		}

		-- set menu
		dashboard.section.buttons.opts.spacing = 0

		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New File", "<cmd>enew<CR>"),
			dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>Neotree toggle<cr>"),
			dashboard.button("SPC ff", "󰈲  > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fg", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>AutoSession restore<CR>"),
			dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		}

		alpha.setup(dashboard.opts)

		local group = vim.api.nvim_create_augroup("user-alpha", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "alpha",
			command = "setlocal nofoldenable",
		})
		-- Volta para o dashboard ao fechar o último buffer (evento do bufdelete.nvim)
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "BDeletePre *",
			callback = function()
				if vim.api.nvim_buf_get_name(0) == "" then
					vim.cmd([[:Alpha | bd#]])
				end
			end,
		})
	end,
}
