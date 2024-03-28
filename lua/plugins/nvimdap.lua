return {
	'mfussenegger/nvim-dap',
	dependencies = {
		"jay-babu/mason-nvim-dap.nvim",
		config = function()
			require("mason-nvim-dap").setup({})
		end,
		"theHamsta/nvim-dap-virtual-text",
		'nvim-neotest/nvim-nio',
		"rcarriga/nvim-dap-ui",
		"anuvyklack/hydra.nvim",
		"nvim-telescope/telescope-dap.nvim",
		"rcarriga/cmp-dap",
		"mfussenegger/nvim-dap-python"
	},
	config = function()
		require("config.nvimdapconf")
		local ok_telescope, telescope = pcall(require, "telescope")
		if ok_telescope then
			telescope.load_extension("dap")
		end

		local ok_cmp, cmp = pcall(require, "cmp")
		if ok_cmp then
			cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
				sources = cmp.config.sources({
					{ name = "dap" },
				}, {
					{ name = "buffer" },
				}),
			})
		end
		local dap = require('dap')
		dap.adapters.python = function(cb, config)
			if config.request == 'attach' then
				---@diagnostic disable-next-line: undefined-field
				local port = (config.connect or config).port
				---@diagnostic disable-next-line: undefined-field
				local host = (config.connect or config).host or '127.0.0.1'
				cb({
					type = 'server',
					port = assert(port,
						'`connect.port` is required for a python `attach` configuration'),
					host = host,
					options = {
						source_filetype = 'python',
					},
				})
			else
				cb({
					type = 'executable',
				--command = vim.fn.stdpath("data") .. "/lua/.virtualenvs/debugpy/bin/python",
				command = require('config.nvimdapconf').actual_path('run'),

					args = { '-m', 'debugpy.adapter' },
					options = {
						source_filetype = 'python',
					},
				})
			end
		end
		local dap = require('dap')
		dap.configurations.python = {
			{
				-- The first three options are required by nvim-dap
				type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
				request = 'launch',
				name = "Launch file",

				-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

				program = "${file}", -- This configuration will launch the current file if used.
				pythonPath = function()
					-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
					-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
					-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
					local cwd = vim.fn.getcwd()
					if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
						return cwd .. '/venv/bin/python'
					elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
						return cwd .. '/.venv/bin/python'
					else
						return '/usr/bin/python'
					end
				end,
			},
		}
	end,

}
