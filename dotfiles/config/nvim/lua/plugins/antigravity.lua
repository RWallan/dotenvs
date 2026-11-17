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

-- Envia prompt diretamente para o terminal do Antigravity (abre se necessário)
local function enviar_para_antigravity(texto)
	require("antigravity.terminal").open({ "-i", "--prompt", texto })
end

return {
	"Showwaiyan/antigravity.nvim",
	cmd = {
		"AntigravityAsk",
		"AntigravitySelect",
		"AntigravityToggle",
		"AntigravityClose",
	},
	keys = {
		-- Abertura e envio rápidos (similaridade visual e funcional ao Claude Code)
		{ "<leader>aa", "<cmd>AntigravityToggle<CR>", desc = "Antigravity: abrir/fechar" },
		{
			"<leader>af",
			function()
				local arquivo = arquivo_atual()
				if not arquivo then
					return
				end
				local referencia = "@" .. arquivo
				vim.fn.setreg("+", referencia)
				vim.notify("Referência copiada: " .. referencia)
			end,
			desc = "Antigravity: copiar referência do arquivo",
		},
		{
			"<leader>aF",
			function()
				local arquivo = arquivo_atual()
				if arquivo then
					enviar_para_antigravity("Analise este arquivo: @" .. arquivo)
				end
			end,
			desc = "Antigravity: enviar arquivo",
		},
		{
			"<leader>as",
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
				enviar_para_antigravity("Analise estas linhas do arquivo: " .. referencia)
			end,
			mode = "v",
			desc = "Antigravity: enviar linhas selecionadas",
		},

		-- Features exclusivas do Antigravity (placeholders, presets e diagnósticos LSP)
		{ "<leader>ai", "<cmd>AntigravityAsk<CR>", desc = "Antigravity: prompt interativo" },
		{ "<leader>ai", ":AntigravityAsk ", mode = "v", desc = "Antigravity: perguntar sobre seleção" },
		{ "<leader>ap", "<cmd>AntigravitySelect<CR>", desc = "Antigravity: presets rápidos" },
		{ "<leader>ap", ":AntigravitySelect<CR>", mode = "v", desc = "Antigravity: presets rápidos (seleção)" },
		{
			"<leader>ad",
			function()
				local arquivo = arquivo_atual()
				if arquivo then
					enviar_para_antigravity("Corrija estes diagnósticos em @" .. arquivo .. ":\n@diagnostics")
				else
					enviar_para_antigravity("Corrija estes diagnósticos:\n@diagnostics")
				end
			end,
			desc = "Antigravity: corrigir diagnósticos LSP",
		},
		{
			"<leader>ag",
			function()
				enviar_para_antigravity("Revise as seguintes alterações do git diff:\n@diff")
			end,
			desc = "Antigravity: revisar git diff",
		},
		{ "<leader>ac", "<cmd>AntigravityClose<CR>", desc = "Antigravity: fechar/encerrar sessão" },
	},
	opts = {
		cmd = "agy",
		disable_links = false,
		ask = {
			split = "right",
			width = 0.35, -- Mesmo tamanho (35% da tela) do Claude Code
			prompt = "Perguntar ao Antigravity: ",
		},
		select = {
			prompt = "Preset do Antigravity: ",
			prompts = {
				["1_explicar"] = "Explique @this e o contexto relevante",
				["2_corrigir_erros"] = "Corrija os erros e diagnósticos em @this: @diagnostics",
				["3_otimizar"] = "Otimize @this para melhor desempenho e legibilidade",
				["4_revisar"] = "Revise @this detalhadamente apontando possíveis bugs e melhorias",
				["5_testes"] = "Crie testes unitários abrangentes para @this",
				["6_git_diff"] = "Revise o git diff das alterações atuais: @diff",
			},
		},
		mappings = {
			scroll_up = "<C-u>",
			scroll_down = "<C-d>",
		},
	},
	config = function(_, opts)
		require("antigravity").setup(opts)

		-- Oculta números de linha e signcolumn no terminal do Antigravity (igual ao Claude Code)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "antigravity",
			callback = function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt_local.signcolumn = "no"
			end,
		})
	end,
}
