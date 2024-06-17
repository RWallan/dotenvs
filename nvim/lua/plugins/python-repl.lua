return {
    "geg2102/nvim-python-repl",
    dependencies = "nvim-treesitter",
    ft = {"python", "lua"},
    config = function()
        local repl = require("nvim-python-repl")
        repl.setup({
            execute_on_send = false,
            vsplit = false,
        })
        local keymap = vim.keymap

        keymap.set("n", "<leader>td", function() repl.send_statement_definition() end, { desc = "Send semantic unit to REPL"})
        keymap.set("v", "<leader>tv", function() repl.send_visual_to_repl() end, { desc = "Send visual selection to REPL"})
        keymap.set("n", "<leader>tb", function() repl.send_buffer_to_repl() end, { desc = "Send entire buffer to REPL"})
        keymap.set("n", "<leader>te", function() repl.toggle_execute() end, { desc = "Automatically execute command in REPL after sent"})
        keymap.set("n", "<leader>tv", function() repl.toggle_vertical() end, { desc = "Create REPL in vertical or horizontal split"})
        keymap.set("n", "<leader>to", function() repl.open_repl() end, { desc = "Opens the REPL in a window split"})
    end
}
