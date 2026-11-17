return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile", "BufWritePost" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			markdown = { "markdownlint" },
			go = { "golangcilint" },
		}

		-- golangci-lint analisa o pacote salvo em disco: não adianta rodar ao sair do insert
		local only_on_save = { go = true }

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("lint", { clear = true }),
			callback = function(ev)
				-- Só roda em buffers editáveis (evita ruído em popups do LSP)
				if not vim.bo.modifiable then
					return
				end
				if ev.event == "InsertLeave" and only_on_save[vim.bo.filetype] then
					return
				end
				lint.try_lint()
			end,
		})
	end,
}
