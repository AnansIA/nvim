require("config")
require("plugins")
-- Copiar todo el buffer al portapapeles del sistema
vim.api.nvim_set_keymap('n', '<Leader>c', ':%y+<CR>', { noremap = true, silent = true })

-- Pegar del portapapeles del sistema
vim.api.nvim_set_keymap('n', '<<Leader>p>', '"+p', { noremap = true, silent = true })





