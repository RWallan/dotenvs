return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            "     ⣿⠁⠀⠀⠀⠀⠀⡇⠀⠀⣸⠀⠀⠀⠀⢀⣻⠀⠀⢸⡀⠀⠀⢳⡀⠀⠀⠀⣞⢸⣆⠀⠀⠀⢸⡀⠀⢰⠀⠀⠀⢳⠀⠀⠀⠀⠁⠀⠀⠀",
            "     ⠇⠀⠀⠀⠀⠀⢸⠀⡀⠀⡟⣆⠀⠀⠀⢸⠧⠴⠆⠀⠳⡀⠀⠀⠳⡀⠀⢸⢻⠲⠼⢆⠀⠀⠀⣇⠀⢸⣆⠀⠀⠘⡆⠀⠀⠀⠀⠀⠀⠀",
            "   ⠀  ⠀⠀⠀⠀⠀⣼⣴⡿⣔⣇⠉⠓⠦⣄⣸⠀⠀⠀⠀⠀⠻⠶⣄⣀⠙⠦⣸⡆⠀⠀⠀⠓⢤⡀⠸⡷⣄⢻⢦⡀⠀⢷⠀⠀⠀⡆⠀⠀⠀",
            "   ⠀⠀  ⠀⠀⠀⠀⣿⠛⠀⠈⠉⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⠐⠨⠍⠉⠉⠛⠀⠀⠀⠀⠀⠉⠙⠚⠬⠟⠃⠻⡦⣼⠀⠀⣆⡇⠀⠀⠀",
            "   ⠀  ⡀⢰⠀⠀⢠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⡆⢀⢿⠁⠀⠀⠀",
            "   ⠀  ⠸⡄⣧⠀⢸⣃⣤⣖⣻⣿⣿⠿⣿⣿⣟⣓⣲⣭⣑⠀⠀⠀⠀⠀⠀⠀⠀⢈⡥⣶⣺⣿⣿⣿⣿⣷⠲⠦⣄⡀⠀⠀⡇⢸⡼⠀⠀⠀⠀",
            "   ⠀⠀  ⢱⡘⡆⢸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠀⠈⠉⠉⠉⠉⠉⠓⠛⠓⠲⣧⡇⠃⠀⠀⠀⠀",
            "   ⠀⠀⠀  ⢳⡸⡄⡇⢠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⢠⠀⠀⠀⠀⠀",
            "   ⠀⠀⠀⠀  ⢳⡹⣇⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢃⡇⠀⠀⠀⠀⠀",
            "                                                  ",
            "   __   ___ _____    ___        __   _    __     _    ___ ",
            "  / /  / _//_  _/  ,' _/      ,'_/ ,' \\  /  \\  .' \\  / o |",
            " / /_ / _/  / /   _\\ `.      / /_ / o | / o | / o / /  ,' ",
            "/___//___/ /_/   /___,'      |__/ |_,' /__,' /_n_/ /_/`_\\ ",
        }

        -- set menu
        dashboard.section.buttons.val = {
            dashboard.button("e", "  > New File", "<cmd>enew<CR>"),
            dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>Neotree toggle<CR>"),
            dashboard.button("SPC ff", "�  > Find File", "<cmd>Telescope find_files<CR>"),
            dashboard.button("SPC fw", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
            dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
        }

        alpha.setup(dashboard.opts)
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end
}
