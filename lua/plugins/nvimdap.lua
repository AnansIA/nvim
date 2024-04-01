return {
	'mfussenegger/nvim-dap',
	dependencies = {
		"mfussenegger/nvim-dap-python", -- Para soporte específico de Python
		"rcarriga/nvim-dap-ui", -- Para una interfaz de usuario mejorada
		'nvim-neotest/nvim-nio', --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
	},
	config = function()
		local path = require("config.nvimdapconf")
		--require('dap-python').setup(path.actual_path('run'))  -- Cambia la ruta según tu configuración de Python
		local dap, dapui = require('dap'), require('dapui')

		dap.adapters.python = function(cb, _) -- _ = config
			cb({
				type = 'executable',
				command = path.actual_path('run'),
				args = { '-m', 'debugpy.adapter' },
				options = {
					source_filetype = 'python',
				},
			})
		end

		dap.configurations.python = {
			{
				name = "debugpy",
				type = "python",
				request = 'launch',
				program = "${file}",
				pythonPath = path.actual_path('run'),
			} }
		dapui.setup() -- Configura la UI de DAP
		-- Configura los keybindings básicos para nvim-dap (Opcional)
		vim.keymap.set('n', '<F5>', dap.continue, { silent = true })
		vim.keymap.set('n', '<F10>', dap.step_over, { silent = true })
		vim.keymap.set('n', '<F11>', dap.step_into, { silent = true })
		vim.keymap.set('n', '<F12>', dap.step_out, { silent = true })
		vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, { silent = true })
		vim.keymap.set('n', '<Leader>B', function()
			dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
		end, { silent = true })
		vim.keymap.set('n', '<Leader>lp', function()
			dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
		end, { silent = true })
		vim.keymap.set('n', '<Leader>dr', dap.repl.open, { silent = true })
		vim.keymap.set('n', '<Leader>dl', dap.run_last, { silent = true })
		--Listeners para Dap-UI
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
