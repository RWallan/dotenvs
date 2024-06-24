return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function()
        local keymap = vim.keymap

        keymap.set("n", "<leader>ms", "<cmd>MarkdownPreview<CR>", { desc = "Starts the preview" })
        keymap.set("n", "<leader>mS", "<cmd>MarkdownPreviewStop<CR>", { desc = "Stops the preview" })
    end,
}
