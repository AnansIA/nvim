return {
	"L3MON4D3/LuaSnip",
	"rafamadriz/friendly-snippets",  -- Colección de snippets
	version = "v2.*", -- Sigue la última versión mayor lanzada.
	-- Para instalar jsregexp opcionalmente, descomenta la siguiente línea.
	build = "make install_jsregexp",
	event = "VeryLazy",
	config = function()
		local ls = require("luasnip")
		-- create snippet
		-- s(context, nodes, condition, ...)
		local snippet = ls.s

		-- TODO: Write about this.
		--  Useful for dynamic nodes and choice nodes
		-- local snippet_from_nodes = ls.sn

		-- This is the simplest node.
		--  Creates a new text node. Places cursor after node by default.
		--  t { "this will be inserted" }
		--
		--  Multiple lines are by passing a table of strings.
		--  t { "line 1", "line 2" }
		local t = ls.text_node

		-- Insert Node
		--  Creates a location for the cursor to jump to.
		--      Possible options to jump to are 1 - N
		--      If you use 0, that's the final place to jump to.
		--
		--  To create placeholder text, pass it as the second argument
		--      i(2, "this is placeholder text")
		local i = ls.insert_node

		-- Function Node
		--  Takes a function that returns text
		-- local f = ls.function_node

		-- This a choice snippet. You can move through with <c-l> (in my config)
		--   c(1, { t {"hello"}, t {"world"}, }),
		--
		-- The first argument is the jump position
		-- The second argument is a table of possible nodes.
		--  Note, one thing that's nice is you don't have to include
		--  the jump position for nodes that normally require one (can be nil)
		-- local c = ls.choice_node

		-- local d = ls.dynamic_node

		-- TODO: Document what I've learned about lambda
		-- local l = require("luasnip.extras").lambda

		-- local events = require("luasnip.util.events")

		local shortcut = function(val)
			if type(val) == "string" then
				return { t { val }, i(0) }
			end

			if type(val) == "table" then
				for k, v in ipairs(val) do
					if type(v) == "string" then
						val[k] = t { v }
					end
				end
			end

			return val
		end

		local make = function(tbl)
			local result = {}
			for k, v in pairs(tbl) do
				table.insert(result, (snippet({ trig = k, desc = v.desc }, shortcut(v))))
			end

			return result
		end

		ls.cleanup()
		for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/alpha/snips/ft/*.lua", true)) do
			local ft = vim.fn.fnamemodify(ft_path, ":t:r")
			ls.add_snippets(ft, make(loadfile(ft_path)()))
		end

		-- Configuración de LuaSnip
		ls.setup({
			history = true, -- Habilita el historial para navegar a través de los snippets previamente expandidos.
			updateevents = "TextChanged, TextChangedI",

			enable_autosnippets = true,
			ext_ops = {
				[require('luasnip.util.types').choiceNode] = {
					active = {
						virt_text = { { "<- Choice", "Error" } }
					},
				},

			},

		})
		-- Opcional: Cargar algunos snippets por defecto
		require("luasnip.loaders.from_vscode").lazy_load()
		-- Configurando keymaps para LuaSnip
		local opts = { silent = true }
		-- Expandir o saltar al siguiente snippet
		vim.keymap.set({ "i", "s" }, "<C-k>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end, opts)
		-- Saltar al snippet anterior
		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, opts)

		-- Seleccionar dentro de un snippet
		vim.keymap.set("i", "<C-l>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, opts)
	end,
}
