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

-- Identifica se um buffer pertence ao Antigravity
local function is_antigravity_buf(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(buf) then
		return false
	end
	return vim.bo[buf].filetype == "antigravity"
		or (vim.bo[buf].buftype == "terminal" and vim.api.nvim_buf_get_name(buf):find("Antigravity") ~= nil)
end

-- Navegação segura para splits a partir do modo terminal (compatível com vim-tmux-navigator e splits nativos)
local function term_nav(direction, fallback)
	return function()
		local tmux_cmd = "TmuxNavigate" .. direction
		if vim.fn.exists(":" .. tmux_cmd) == 2 then
			vim.cmd("stopinsert")
			vim.cmd(tmux_cmd)
		else
			vim.cmd("stopinsert")
			vim.cmd("wincmd " .. fallback)
		end
	end
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
		{
			"<leader>aa",
			function()
				vim.cmd("AntigravityToggle")
				vim.schedule(function()
					if is_antigravity_buf() then
						vim.cmd("startinsert")
					end
				end)
			end,
			desc = "Antigravity: abrir/fechar",
		},
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

		local group = vim.api.nvim_create_augroup("AntigravityTerminalCustom", { clear = true })

		-- Configurações de buffer, atalhos de navegação e entrada no modo terminal ao abrir
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "antigravity",
			callback = function(args)
				local buf = args.buf

				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
				vim.opt_local.signcolumn = "no"

				-- Entra já no modo terminal (insert)
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_current_buf() == buf then
						vim.cmd("startinsert")
					end
				end)

				-- Mapeamentos de navegação entre splits a partir do modo terminal (estilo Claude Code e vim-tmux-navigator)
				local map_opts = { buffer = buf, silent = true }

				-- Navegação via <C-h>, <C-j>, <C-k>, <C-l>
				vim.keymap.set(
					"t",
					"<C-h>",
					term_nav("Left", "h"),
					vim.tbl_extend("force", map_opts, { desc = "Navegar para janela à esquerda" })
				)
				vim.keymap.set(
					"t",
					"<C-j>",
					term_nav("Down", "j"),
					vim.tbl_extend("force", map_opts, { desc = "Navegar para janela abaixo" })
				)
				vim.keymap.set(
					"t",
					"<C-k>",
					term_nav("Up", "k"),
					vim.tbl_extend("force", map_opts, { desc = "Navegar para janela acima" })
				)
				vim.keymap.set(
					"t",
					"<C-l>",
					term_nav("Right", "l"),
					vim.tbl_extend("force", map_opts, { desc = "Navegar para janela à direita" })
				)

				-- Atalhos tradicionais <C-w>h/j/k/l/w/c/p no terminal
				vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h", map_opts)
				vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j", map_opts)
				vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k", map_opts)
				vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l", map_opts)
				vim.keymap.set("t", "<C-w>w", "<C-\\><C-n><C-w>w", map_opts)
				vim.keymap.set("t", "<C-w>c", "<C-\\><C-n><C-w>c", map_opts)
				vim.keymap.set("t", "<C-w>p", "<C-\\><C-n><C-w>p", map_opts)
				vim.keymap.set("t", "<C-w><C-h>", "<C-\\><C-n><C-w>h", map_opts)
				vim.keymap.set("t", "<C-w><C-j>", "<C-\\><C-n><C-w>j", map_opts)
				vim.keymap.set("t", "<C-w><C-k>", "<C-\\><C-n><C-w>k", map_opts)
				vim.keymap.set("t", "<C-w><C-l>", "<C-\\><C-n><C-w>l", map_opts)
			end,
		})

		-- Garante que ao entrar/focar na janela do Antigravity, entre já no modo terminal (igual Claude Code enter_insert = true)
		vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
			group = group,
			callback = function(args)
				local buf = args.buf or vim.api.nvim_get_current_buf()
				if is_antigravity_buf(buf) then
					vim.schedule(function()
						if vim.api.nvim_get_current_buf() == buf then
							vim.cmd("startinsert")
						end
					end)
				end
			end,
		})
	end,
}
