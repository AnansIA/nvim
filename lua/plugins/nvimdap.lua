return {
    'mfussenegger/nvim-dap',
    dependencies = {
        "mfussenegger/nvim-dap-python",  -- Para soporte específico de Python
        "rcarriga/nvim-dap-ui",  -- Para una interfaz de usuario mejorada
	'nvim-neotest/nvim-nio',			--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    },
    config = function()
	local path = require("config.nvimdapconf")
        require('dap-python').setup(path.actual_path('run'))  -- Cambia la ruta según tu configuración de Python
        require('dapui').setup()  -- Configura la UI de DAP
        -- Configura los keybindings básicos para nvim-dap (Opcional)
        local dap = require('dap')
        vim.keymap.set('n', '<F5>', dap.continue, {silent = true})
        vim.keymap.set('n', '<F10>', dap.step_over, {silent = true})
        vim.keymap.set('n', '<F11>', dap.step_into, {silent = true})
        vim.keymap.set('n', '<F12>', dap.step_out, {silent = true})
        vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, {silent = true})
        vim.keymap.set('n', '<Leader>B', function()
            dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end, {silent = true})
        vim.keymap.set('n', '<Leader>lp', function()
            dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
        end, {silent = true})
        vim.keymap.set('n', '<Leader>dr', dap.repl.open, {silent = true})
        vim.keymap.set('n', '<Leader>dl', dap.run_last, {silent = true})
    end,
}

