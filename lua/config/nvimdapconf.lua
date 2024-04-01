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


return {
	actual_path = actual_path,
	setup_debugpy_virtualenv = setup_debugpy_virtualenv
}
