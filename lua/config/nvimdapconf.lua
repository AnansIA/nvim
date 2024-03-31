local dap, dapui, hydra = require "dap", require "dapui", require "hydra"

local function run_shell_command(cmd)
	local result = vim.fn.system(cmd)
	if result == 1 then
		print("Error al ejecutar el comando: " .. cmd)
	end
	return result
end

local function actual_path(mode)
	local base = "/lua/.virtualenvs"
	local mod = "debugpy"
	local env = "/" .. mod
	local run = "/bin/python"
	local source = "/bin/activate"
	if mode == 'run' then
		return vim.fn.stdpath("data") .. base .. env .. run
	elseif mode == 'env' then
		return env
	elseif mode == 'base' then
		return vim.fn.stdpath("data") .. base
	elseif mode == 'source' then
		return vim.fn.stdpath("data") .. base .. env .. source
	elseif mode == 'mod' then
		return mod
	else
		return nil -- Devuelve nil si el modo no es válido
	end
end
local function setup_debugpy_virtualenv()
	local virtualenv_dir = actual_path('base') --vim.fn.expand("/lua/.virtualenvs/debugpy")
	local python_path = actual_path('run')

	if vim.fn.isdirectory(virtualenv_dir) == 0 then
		-- Si el directorio no existe, crea el entorno virtual
		local create_command = "mkdir " ..
		virtualenv_dir .. " | python -m venv " .. virtualenv_dir .. actual_path('env')
		run_shell_command(create_command)
		-- Instala debugpy en el entorno virtual
		local install_command = python_path .. " -m pip install " .. actual_path('mod')
		if run_shell_command(install_command) == 0 then
			-- Imprime un mensaje indicando que el entorno virtual ha sido creado y activado
			return python_path
			--end
		end
	else
		return python_path
	end
end


-- Setup Telescope dap extension
local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
	telescope.load_extension "dap"
end

-- Setup cmp dap
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

-- Set Icons
vim.api.nvim_call_function(
	"sign_define",
	{ "DapBreakpoint", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
)

vim.api.nvim_call_function(
	"sign_define",
	{ "DapBreakpointCondition", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
)

vim.api.nvim_call_function(
	"sign_define",
	{ "DapLogPoint", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
)

vim.api.nvim_call_function(
	"sign_define",
	{ "DapStopped", { linehl = "GitSignsChangeVirtLn", text = "", texthl = "diffChanged", numhl = "" } }
)

vim.api.nvim_call_function(
	"sign_define",
	{ "DapBreakpointRejected", { linehl = "", text = "", texthl = "", numhl = "" } }
)

-- Setup DAPUI
dapui.setup({
	icons = { collapsed = "", current_frame = "", expanded = "" },
	layouts = {
		{
			elements = { "scopes", "watches", "stacks", "breakpoints" },
			size = 80,
			position = "left",
		},
		{ elements = { "console", "repl" }, size = 0.25, position = "bottom" },
	},
	render = { indent = 2 },
})


-- Menu
local hint = [[
 Nvim DAP
 _d_: Start/Continue  _j_: StepOver _k_: StepOut _l_: StepInto ^
 _bp_: Toggle Breakpoint  _bc_: Conditional Breakpoint ^
 _?_: log point ^
 _c_: Run To Cursor ^
 _h_: Show information of the variable under the cursor ^
 _x_: Stop Debbuging ^
 ^^                                                      _<Esc>_
]]


hydra {
	name = "dap",
	hint = hint,
	mode = "n",
	config = {
		color = "blue",
		invoke_on_body = true,
		hint = {
			border = "rounded",
			position = "bottom",
		},
	},
	body = "<leader>d",
	heads = {
		{ "d",  dap.continue },
		{ "bp", dap.toggle_breakpoint },
		{ "l",  dap.step_into },
		{ "j",  dap.step_over },
		{ "k",  dap.step_out },
		{ "h",  dapui.eval },
		{ "c",  dap.run_to_cursor },
		{
			"bc",
			function()
				vim.ui.input({ prompt = "Condition: " }, function(condition)
					dap.set_breakpoint(condition)
				end)
			end,
		},
		{
			"?",
			function()
				vim.ui.input({ prompt = "Log: " }, function(log)
					dap.set_breakpoint(nil, nil, log)
				end)
			end,
		},
		{
			"x",
			function()
				dap.terminate()
				dapui.close {}
				dap.clear_breakpoints()
			end,
		},

		{ "<Esc>", nil, { exit = true } },
	},
}

return {
	actual_path = actual_path,
	setup_debugpy_virtualenv = setup_debugpy_virtualenv
}
