return {
	"L3MON4D3/LuaSnip",
	version = "v2.*", -- Sigue la última versión mayor lanzada.
	-- Para instalar jsregexp opcionalmente, descomenta la siguiente línea.
	-- build = "make install_jsregexp",
	config = function()
		local ls = require("luasnip")
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
