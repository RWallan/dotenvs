return {
	"rmagatti/auto-session",
	-- Carregado após a UI para continuar salvando a sessão ao sair
	event = "VeryLazy",
	cmd = { "AutoSession" },
	keys = {
		{ "<leader>wr", "<cmd>AutoSession restore<CR>", desc = "Restore session for cwd" },
	},
	opts = {
		auto_restore = false,
		suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
		session_lens = {
			picker = "snacks",
			load_on_setup = false,
		},
	},
}
