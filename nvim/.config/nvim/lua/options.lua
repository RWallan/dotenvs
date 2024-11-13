--- Map leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--- Nerd font
vim.g.have_nerd_font = true

--- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

--- Enabling mouse to resizing
vim.opt.mouse = "a"

--- Hiding the mode
vim.opt.showmode = false

--- Sync clipboard between OS and Neovim
vim.schedule(
    function()
        vim.opt.clipboard = 'unnamedplus'
    end
)

--- Enable break indent
vim.opt.breakindent = true

--- Save undo history
vim.opt.undofile = true

--- Case-insensitive seach \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

--- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

--- Decrease update time
vim.opt.updatetime = 250

--- Decrease mapped sequence wait time
--- Displays which-key popup sooner
vim.opt.timeoutlen = 300

--- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

--- Sets how neovim will display certain whitespace characters in the editor
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

--- Preview substitutions live
vim.opt.inccommand = 'split'

--- Highlight selected line
vim.opt.cursorline = true

--- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

--- Tab as spaces
vim.opt.expandtab = true
