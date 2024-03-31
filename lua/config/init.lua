require "config.basic"
require "config.lazy"
--require("config.nvimdapconf").setup_debugpy_virtualenv()
require("config.nvimdapconf")

vim.o.guifont = "IosevkaTerm Nerd Font Mono:pixelsize=20"
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.cmd('set cursorline')
vim.o.termguicolors = true
