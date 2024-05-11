return {
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.6', -- Telescope para busca fuuzy
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            -- Keymap do telescope
            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- Busca arquivos fuuzy
            vim.keymap.set('n', '<leader>fw', builtin.live_grep, {}) -- Busca palavras
        end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup {
                    extensions = {
                        ["ui-select"] = {
                            require("telescope.themes").get_dropdown {}
                        }
                    }
            }
            require("telescope").load_extension("ui-select")
        end
    }
}

