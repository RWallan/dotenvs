-- ########## CONFIGURAÇÕES CORE DO NEOVIM ##########

-- Instala o LazyNvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Importando módulos de configuração
require("options") -- Importa as configurações relacionadas ao cmd do neovim
require("lazy").setup("plugins") -- Importa os plugins e suas configurações
