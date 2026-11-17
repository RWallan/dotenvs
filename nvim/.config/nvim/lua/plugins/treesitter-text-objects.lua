return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",

		config = function()
			local textobjects = require("nvim-treesitter-textobjects")

			textobjects.setup({
				select = {
					lookahead = true,

					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "<c-v>",
					},

					include_surrounding_whitespace = true,
				},

				move = {
					set_jumps = true,
				},

				lsp_interop = {
					enable = true,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")

			local move = require("nvim-treesitter-textobjects.move")

			-- Select
			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end, { desc = "Select function outer" })

			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end, { desc = "Select function inner" })

			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end, { desc = "Select class outer" })

			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end, { desc = "Select class inner" })

			vim.keymap.set({ "x", "o" }, "as", function()
				select.select_textobject("@scope", "locals")
			end, { desc = "Select scope" })

			-- Move: next function
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function start" })

			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				move.goto_next_end("@function.outer", "textobjects")
			end, { desc = "Next function end" })

			-- Move: previous function
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Previous function start" })

			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end, { desc = "Previous function end" })

			-- Classes
			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				move.goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class start" })

			vim.keymap.set({ "n", "x", "o" }, "][", function()
				move.goto_next_end("@class.outer", "textobjects")
			end, { desc = "Next class end" })

			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Previous class start" })

			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				move.goto_previous_end("@class.outer", "textobjects")
			end, { desc = "Previous class end" })

			-- Loops
			vim.keymap.set({ "n", "x", "o" }, "]o", function()
				move.goto_next_start("@loop.*", "textobjects")
			end, { desc = "Next loop" })

			-- Scope
			vim.keymap.set({ "n", "x", "o" }, "]s", function()
				move.goto_next_start("@scope", "locals")
			end, { desc = "Next scope" })

			-- Fold
			vim.keymap.set({ "n", "x", "o" }, "]z", function()
				move.goto_next_start("@fold", "folds")
			end, { desc = "Next fold" })

			-- Conditionals
			vim.keymap.set({ "n", "x", "o" }, "]d", function()
				move.goto_next_start("@conditional.outer", "textobjects")
			end, { desc = "Next conditional" })

			vim.keymap.set({ "n", "x", "o" }, "[d", function()
				move.goto_previous_start("@conditional.outer", "textobjects")
			end, { desc = "Previous conditional" })
		end,
	},
}
