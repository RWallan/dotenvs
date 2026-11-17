-- Caminho do arquivo atual relativo à raiz do repositório git (ou ao cwd)
local function arquivo_atual()
	local arquivo = vim.api.nvim_buf_get_name(0)

	if arquivo == "" then
		vim.notify("Nenhum arquivo aberto", vim.log.levels.WARN)
		return nil
	end

	local raiz = vim.fs.root(arquivo, ".git")
	return (raiz and vim.fs.relpath(raiz, arquivo)) or vim.fn.fnamemodify(arquivo, ":.")
end

-- Envia texto para o primeiro terminal visível (o do Claude Code)
local function enviar_para_claude(texto)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)

		if vim.bo[buf].buftype == "terminal" then
			local job = vim.b[buf].terminal_job_id

			if job and job > 0 then
				vim.fn.chansend(job, texto .. "\n")
				return true
			end
		end
	end

	vim.notify("Abra o Claude Code primeiro com <leader>cc", vim.log.levels.WARN)
	return false
end

return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeResume", "ClaudeCodeVerbose" },
	keys = {
		{ "<leader>cc", "<cmd>ClaudeCode<CR>", desc = "Claude Code: abrir/fechar" },
		{
			"<leader>cf",
			function()
				local arquivo = arquivo_atual()
				if not arquivo then
					return
				end
				local referencia = "@" .. arquivo
				vim.fn.setreg("+", referencia)
				vim.notify("Referência copiada: " .. referencia)
			end,
			desc = "Claude Code: copiar referência do arquivo",
		},
		{
			"<leader>cF",
			function()
				local arquivo = arquivo_atual()
				if arquivo then
					enviar_para_claude("Analise este arquivo: @" .. arquivo)
				end
			end,
			desc = "Claude Code: enviar arquivo",
		},
		{
			"<leader>cs",
			function()
				local arquivo = arquivo_atual()
				if not arquivo then
					return
				end

				local inicio = vim.fn.line("v")
				local fim = vim.fn.line(".")
				if inicio > fim then
					inicio, fim = fim, inicio
				end

				local referencia = string.format("@%s#L%d-%d", arquivo, inicio, fim)
				enviar_para_claude("Analise estas linhas do arquivo: " .. referencia)
			end,
			mode = "v",
			desc = "Claude Code: enviar linhas selecionadas",
		},
	},
	opts = {
		window = {
			position = "vertical",
			split_ratio = 0.35,
			enter_insert = true,
			hide_numbers = true,
			hide_signcolumn = true,
		},
		git = {
			use_git_root = true,
		},
		keymaps = {
			toggle = {
				normal = false,
				terminal = false,
			},
			window_navigation = true,
			scrolling = true,
		},
	},
}
