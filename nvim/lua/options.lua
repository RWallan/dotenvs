-- Seta o tab para 4 espaçamentos
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- Seta o global leader
vim.g.mapleader = " "

-- Navigate vim panes
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

-- Kill the buffer
vim.keymap.set("n", "<leader>c", ":bd<CR>")

-- Seta os números de linha
vim.opt.number = true -- Mostra o número da linha
vim.opt.relativenumber = true -- Usa números relativos de linha
