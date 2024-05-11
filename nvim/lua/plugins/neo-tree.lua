return {
    "nvim-neo-tree/neo-tree.nvim", -- File explorer
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
        -- Keymap do neotree
        vim.keymap.set('n', '<leader>e', ':Neotree filesystem reveal left<CR>')
        vim.keymap.set('n', '<leader>b', ':Neotree buffers reveal left<CR>')
    end
}

