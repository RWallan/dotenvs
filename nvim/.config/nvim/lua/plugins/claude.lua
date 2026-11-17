return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("claude-code").setup({
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
		})

		local function arquivo_atual()
			local arquivo = vim.api.nvim_buf_get_name(0)

			if arquivo == "" then
				vim.notify("Nenhum arquivo aberto", vim.log.levels.WARN)
				return nil
			end

			local raiz = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
			local caminho

			if vim.v.shell_error == 0 and raiz and raiz ~= "" then
				caminho = vim.fn.fnamemodify(arquivo, ":.")
				-- Garante caminho relativo à raiz do repositório
				caminho = vim.fs.relpath(raiz, arquivo) or caminho
			else
				caminho = vim.fn.fnamemodify(arquivo, ":.")
			end

			return caminho
		end

		vim.keymap.set("n", "<leader>cf", function()
			local arquivo = arquivo_atual()
			if not arquivo then
				return
			end

			local referencia = "@" .. arquivo

			vim.fn.setreg("+", referencia)
			vim.notify("Referência copiada: " .. referencia)
		end, {
			desc = "Claude Code: copiar referência do arquivo",
		})

		local function enviar_para_claude(texto)
			-- Procura um terminal do Claude Code já aberto.
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)

				if vim.bo[buf].buftype == "terminal" then
					local job = vim.b[buf].terminal_job_id

					if job and job > 0 then
						-- O terminal é selecionado pela janela atual do plugin.
						-- Se houver outros terminais, prefira focar o Claude
						-- antes de usar os atalhos.
						vim.fn.chansend(job, texto .. "\n")
						return true
					end
				end
			end

			vim.notify("Abra o Claude Code primeiro com <leader>cc", vim.log.levels.WARN)
			return false
		end

		-- Enviar referência do arquivo
		vim.keymap.set("n", "<leader>cF", function()
			local arquivo = arquivo_atual()
			if arquivo then
				enviar_para_claude("Analise este arquivo: @" .. arquivo)
			end
		end, {
			desc = "Claude Code: enviar arquivo",
		})

		-- Enviar referência das linhas selecionadas
		vim.keymap.set("v", "<leader>cs", function()
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
		end, {
			desc = "Claude Code: enviar linhas selecionadas",
		})

		-- Abrir/fechar o Claude Code
		vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", {
			desc = "Claude Code: abrir/fechar",
		})
	end,
}
