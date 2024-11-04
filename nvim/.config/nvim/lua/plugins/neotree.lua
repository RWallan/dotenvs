return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        local neotree = require("neo-tree")

        neotree.setup({
            window = {
                width = 27,
                mappings = {
                    ["[b"] = "prev_source",
                    ["]b"] = "next_source",
                },
            },
        })
        local keymap = vim.keymap
        keymap.set("n", "<leader>eq", "<cmd>Neotree toggle<CR>", { desc = "Toggle Quick File Explorer" })
        keymap.set("n", "<leader>eb", "<cmd>Neotree buffers toggle<CR>", { desc = "Toggle Buffer Explorer" })
    end
}
