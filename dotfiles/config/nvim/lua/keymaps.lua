local keymap = vim.keymap

keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Split management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close current split" })

-- Resize management
keymap.set("n", "<leader>rl", "<cmd>vertical resize +5<CR>", { desc = "Increment size vertically" })
keymap.set("n", "<leader>rh", "<cmd>vertical resize -5<CR>", { desc = "Decrement size vertically" })
keymap.set("n", "<leader>rk", "<cmd>resize +5<CR>", { desc = "Increment size horizontally" })
keymap.set("n", "<leader>rj", "<cmd>resize -5<CR>", { desc = "Decrement size horizontally" })

-- Buffer management
keymap.set("n", "<leader>bo", "<cmd>enew<CR>", { desc = "Open new buffer" })
keymap.set("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Go to previous buffer" })
keymap.set("n", "<leader>bf", "<cmd>e %<CR>", { desc = "Open current file in new buffer" })
