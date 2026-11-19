-- snacks.nvim: um plugin no lugar de telescope, neo-tree, alpha, indent-blankline,
-- bufdelete, bufferline e lazygit.nvim (mesmos atalhos de antes).
-- Docs: :help snacks

local function pick(source, opts)
	return function()
		Snacks.picker[source](opts)
	end
end

-- Se só restou o buffer vazio [No Name], volta para o dashboard
local function dashboard_if_empty()
	vim.schedule(function()
		for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
			if b.name ~= "" or b.changed == 1 then
				return
			end
		end
		Snacks.dashboard()
	end)
end

return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	---@type snacks.Config
	opts = {
		input = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				explorer = {
					hidden = true, -- mostra dotfiles (.env, .gitignore...)
					ignored = true, -- mostra arquivos listados no .gitignore
					layout = {
						layout = {
							width = 25,
							min_width = 25,
						},
					},
				},
			},
		},
		explorer = { enabled = true, replace_netrw = true },
		lazygit = { enabled = true },
		indent = {
			enabled = true,
			indent = { char = "┊" },
			scope = { enabled = true },
			animate = { enabled = false },
		},
		dashboard = {
			enabled = true,
			preset = {
				header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⢀⠀⠀⠀⠀⡀⠀⠀⠀⠀⡀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠒⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠶⢾⠀⠀⠀⢸⢧⠀⠀⠀⡰⡇⠀⠊⠀⢀⡴⢺⠇⠀⠀⡠⠊⠁⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣇⣿⣀⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠀⠀⢀⠄⠂⠀⠀⢠⣼⠰⠾⠀⠀⢀⡟⠈⢧⠀⡴⠁⡇⢀⡤⠚⠁⠀⡼⠀⠀⠈⢀⢤⠆⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠠⡀⠀⠀⠀⣞⠰⣿⣛⠢⠘⠦⣦⣠⣀⠠⠀⠀⠀⡴⠊⠀⠠⠔⠁⠀⠀⠀⠀⠀⢠⡄⠀⠀⡤⡸⠁⠀⠈⠛⠀⢀⣙⡉⣠⣤⣤⠀⡇⢀⡤⠚⠁⡼⠀⠀⠀
⠀⠀⠀⠀⠀⣀⡀⠀⠈⠓⢄⢸⡿⣀⣡⠤⠴⢲⡒⠒⠤⣍⡓⠷⣤⣊⠀⠀⣀⡀⠠⠒⠉⠀⠀⠀⢠⡇⠘⠦⢚⣁⠁⠀⣶⡾⠟⠿⣿⠟⢸⣿⣥⡁⠀⠛⠁⠀⠀⢰⠃⠀⣀⡀
⠀⠀⠀⠀⠀⠀⣀⣉⣑⠒⣰⣟⡫⢅⣀⡀⠀⠀⢧⠀⠀⠀⠊⣳⣲⠽⢿⣉⣱⠃⠀⠒⠒⠀⠀⠀⡾⠀⠀⠀⣿⡏⠀⢸⣿⠾⠃⢀⣿⠀⣤⣤⣿⠏⠀⠀⠀⠀⢀⡈⠋⠉⡽⠁
⠀⠀⠀⠀⠈⠉⠀⠀⣀⢼⣫⠅⠠⢭⠶⠾⢭⣓⣶⣷⣦⣤⣞⢳⣾⠀⠀⠨⠙⡆⠀⠀⠀⠲⣖⠚⠁⠀⠀⢀⣿⣇⣤⣸⣿⣾⠇⠘⠟⠀⠉⠉⢁⣤⣆⠀⣾⣿⠿⣿⣷⠸⣃⠀
⠀⠀⠀⠀⠀⠠⠐⠉⠀⢿⣥⡄⠠⠤⠒⣋⣽⣿⣿⠉⠻⡿⣿⢣⣶⣷⠤⠤⢞⣀⣀⠀⠀⠀⠈⣳⡄⠀⠀⠸⠿⠛⠋⣨⣥⣤⡀⣶⣿⣿⣷⡀⢸⡿⣿⠀⣿⣿⣴⣿⠏⢀⡝⠁
⠀⠀⠀⠀⠀⣀⠴⠖⠒⠪⠭⣄⡀⠰⣤⣀⢻⣿⣿⠀⠈⠁⠈⢗⣽⡿⣿⢅⡒⠤⢄⡉⠀⠠⣾⣁⠀⣠⣶⣿⣷⡄⣼⡿⠛⣿⣷⣿⡇⠘⣿⡇⣿⣧⣿⡇⣿⣿⢻⣷⡄⢫⡀⠀
⠀⠀⠀⠀⠠⡇⠀⠀⣀⣀⡀⠀⠉⠳⢄⠛⢆⣿⣿⡇⣾⣰⣰⣿⠏⢀⣿⠑⢌⠑⢄⠈⠂⣠⠞⠁⣰⣿⠏⠈⠋⢱⣿⡇⠀⣿⡟⣿⣇⣼⡿⢹⣿⠛⢻⣿⢹⠿⠀⠛⠛⢀⣱⡄
⠀⠀⠀⠀⣠⠵⠚⢉⡁⠀⠉⢣⠒⠠⣀⡑⠦⣈⠻⢿⣷⣷⡿⠃⢀⣾⠃⠀⠀⠢⠀⣠⣾⠥⣤⠀⣿⣿⠀⢀⣤⡸⣿⣧⣴⣿⠃⣿⡿⠟⠁⠛⠋⠀⡀⡀⢠⡖⠶⠶⠦⠽⢦⠀
⠀⠀⢠⠞⠁⠀⠀⠀⠈⠢⡀⠀⡇⠀⠀⠀⢶⠨⡙⠲⠤⣄⡤⠶⠋⣥⣀⠀⠀⠀⠀⣠⠀⣰⠇⠀⢻⣿⣶⣿⡿⠁⠙⠛⠛⠁⣀⡤⣄⣠⠞⠉⠳⢤⡀⠁⢸⠀⠀⢠⣤⢴⠀⠀
⠀⢀⣫⠔⠂⠉⠉⠐⠤⡀⠀⡸⠁⠀⠀⠀⢸⠀⢸⠀⠀⠀⣴⠀⣀⣀⢈⡇⠀⠠⠊⠀⠴⠷⠒⣷⠀⠉⠉⣁⣤⡆⠀⣠⡴⠚⠁⠀⠈⠁⠀⢀⠀⡀⠉⠳⢼⡀⢀⣼⢠⡾⠀⠀
⠀⡞⠀⣀⡤⠄⣀⠀⠄⡈⢢⡁⠀⠀⠀⠀⡾⠀⢸⡇⠀⠀⡗⠀⠹⣿⣷⡀⠀⠀⠀⣠⠄⠀⢠⠇⣠⠴⠋⠁⣼⡵⠚⠁⠀⠀⡠⣯⣮⢽⢵⢭⢯⡷⣄⠀⠀⠀⠈⠁⠀⠀⠀⠀
⢀⡼⠋⠀⣀⡤⠤⠤⢤⣈⢺⠁⠀⠀⠀⢸⠃⠀⢸⠀⠀⠀⣇⠀⠀⠈⠻⣷⡀⠀⠊⠀⠀⢀⡿⠚⠁⠀⠀⠀⠁⢀⣠⠤⣖⠺⣗⠫⠩⠈⠈⡡⠦⠤⠜⠁⠀⠀⡀⠒⠤⢄⠀⠀
⠈⣆⢠⠚⠁⠀⢀⣠⠴⠶⢭⣀⠀⣀⣀⣀⡀⠀⣸⠀⠀⠀⢘⡤⠖⠚⠓⢲⡹⡄⠀⠀⠀⠈⠀⠀⣀⡠⣾⣿⣮⣝⠘⣧⠨⠖⠋⠒⠢⠴⠋⠀⠀⠀⠀⠀⠤⡀⠈⠑⠢⣀⠀⠀
⠀⠹⡀⢠⡀⣰⠋⠀⣠⠖⢀⣹⡷⣄⠀⠀⠉⠒⠇⢀⡠⠞⠁⠀⠀⢠⠖⠉⠈⠵⡄⣀⡤⡔⢶⠹⡅⣼⣯⡻⣿⢿⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠢⢄⠀⠈⠀⠀⠀⠀⠀⠀
⠀⠀⠈⠢⣁⠙⠷⣾⣁⣶⠟⣡⡾⣫⡿⣶⣤⡒⠊⠁⠀⠀⣀⠴⢄⠸⣄⣤⣔⢾⠹⡌⢧⢹⣈⠧⠗⣸⣿⡃⢂⡾⠁⠀⠀⢀⠄⠀⠀⠀⡾⢷⡄⠀⠀⠀⠉⠢⣀⠀⠀⠀⠀⠀
⠀⠀⢀⡴⠋⣠⠴⠀⠈⠙⠾⢯⣾⡡⣾⣿⣿⣿⣷⣆⠊⣩⣄⢴⢺⡙⡟⢮⡸⣌⡧⠕⠚⣩⠖⠋⣀⠈⢉⡴⠋⠀⠀⠀⡰⠁⠀⠀⠐⠾⢃⣤⠃⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀
⠀⢀⠎⢀⡞⠁⠀⠀⠀⠀⠀⡀⠉⢿⣷⣿⣿⣟⣿⡾⠇⠸⣿⡎⢇⡱⠼⢒⠩⠀⠀⠘⠸⣇⠹⢄⣨⡷⠋⠀⠀⠀⢀⠜⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠸⣀⣼⠁⠀⠀⠀⠀⢠⢴⣷⣆⢲⣍⡛⠛⠛⠉⣴⡆⠀⠙⠋⢠⠰⡀⠀⠀⠘⠢⢄⣀⠈⠓⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢀⡏⠸⡀⠀⠀⠀⠀⠈⢿⣞⣿⡄⠻⡷⠀⠀⠀⠈⠀⠀⠀⠀⠀⠑⠪⠭⠭⡍⢳⠀⠨⠭⠳⠦⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⣼⠳⣄⢳⡀⠀⠀⠀⠀⠘⣯⠼⢏⠀⢾⡷⠀⠀⠠⠄⣀⠤⠒⢒⣒⠒⠒⣉⠴⠃⠀⠀⠀⣠⠤⠖⠚⣓⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠹⡀⠈⢦⠳⡀⠀⠀⠀⢠⣤⠀⢈⠆⡤⣄⠀⠞⣠⠚⡡⠒⠉⠀⠀⠀⠀⠀⠀⠀⣠⠖⠉⠀⠀⠀⠉⠉⠙⠳⢦⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠙⢄⠀⠣⠙⠄⠀⢠⢏⡝⠀⠜⡀⠙⠁⡠⠚⣡⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
				keys = {
					{ icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
					{ icon = " ", key = "x", desc = "File Explorer", action = ":lua Snacks.explorer()" },
					{ icon = "󰈲 ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
					{ icon = " ", key = "g", desc = "Find Word", action = ":lua Snacks.picker.grep()" },
					{ icon = "󰁯 ", key = "s", desc = "Restore Session", action = ":AutoSession restore" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 0, padding = 1 },
			},
		},
	},
	keys = {
		-- Busca (antes: telescope)
		{ "<leader>fh", pick("help"), desc = "Find help" },
		{ "<leader>fk", pick("keymaps"), desc = "Find keymaps" },
		{ "<leader>ff", pick("files"), desc = "Find files" },
		{ "<leader>fs", pick("pickers"), desc = "Find select picker" },
		{ "<leader>fw", pick("grep_word"), desc = "Find current word", mode = { "n", "x" } },
		{ "<leader>fg", pick("grep"), desc = "Find by grep" },
		{ "<leader>fd", pick("diagnostics"), desc = "Find diagnostics" },
		{ "<leader>fr", pick("resume"), desc = "Find resume" },
		{ "<leader>f.", pick("recent"), desc = "Find recent files" },
		{ "<leader>fb", pick("buffers"), desc = "Find existing buffers" },
		{ "<leader>f/", pick("grep_buffers"), desc = "Find [/] in open files" },
		{ "<leader>fn", pick("files", { cwd = vim.fn.stdpath("config") }), desc = "Find Neovim files" },
		{
			"<leader>ft",
			function()
				require("todo-comments")
				Snacks.picker.todo_comments()
			end,
			desc = "Find todos",
		},
		{ "/", pick("lines"), desc = "[/] Fuzzily search in current buffer" },

		-- Explorador (antes: neo-tree)
		{
			"<leader>ee",
			function()
				Snacks.explorer()
			end,
			desc = "Toggle file explorer",
		},

		-- Git (antes: lazygit.nvim)
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Open lazy git",
		},

		-- Buffers (antes: bufdelete + bufferline). [b e ]b são nativos do Neovim 0.11+
		{
			"<leader>bc",
			function()
				Snacks.bufdelete()
				dashboard_if_empty()
			end,
			desc = "Close buffer",
		},
		{
			"<leader>bC",
			function()
				Snacks.bufdelete.other()
			end,
			desc = "Close all other buffers",
		},
		{
			"<leader>ba",
			function()
				Snacks.bufdelete.all()
				dashboard_if_empty()
			end,
			desc = "Close all buffers",
		},
	},
}
