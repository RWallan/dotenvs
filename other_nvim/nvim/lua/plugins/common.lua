return {
    "nvim-lua/plenary.nvim", -- lua function that many plugins use
    "christoomey/vim-tmux-navigator", --tmux & split window navigation
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = { default_prompt = "➤ " },
            select = { backend = { "telescope", "builtin" } },
        },
    }
}
