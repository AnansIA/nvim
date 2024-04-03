require "config.basic"
require "config.lazy"
--require("config.nvimdapconf").setup_debugpy_virtualenv()
require("config.nvimdapconf")


function RunDoq()
	vim.cmd('write')
	local path = vim.fn.expand('%')
	vim.cmd('silent !doq -f ' .. path  .. ' --formatter=sphinx -w')
	vim.cmd('edit!')
end

vim.api.nvim_set_keymap('n', '<C-d>', ':lua RunDoq()<CR>', { noremap = true, silent = true})



vim.o.guifont = "IosevkaTerm Nerd Font Mono:pixelsize=20"
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.cmd('set cursorline')
vim.o.termguicolors = true
