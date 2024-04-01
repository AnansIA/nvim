return {
	'neovim/nvim-lspconfig',
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		'folke/neodev.nvim',
	},
	config = function()
		-- Keybindings básicos para el diagnóstico
		vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
		vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
		vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
		vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('UserLspConfig', {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
				vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
				vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
				vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
				vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, opts)
				vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
				vim.keymap.set('n', '<space>f', function()
					vim.lsp.buf.format { async = true }
				end, {})
			end
		})


		require("neodev").setup({})

		require("lspconfig").lua_ls.setup({
			--capabilities = require('cmp_nvim_lsp').default_capabilities(),
			settings = {
				Lua = {
					telemetry = { enable = false },
					workspace = { checkThirdParty = false },
					codeLens = { enable = true },
					completion = { callSnippet = "Enable" },
				}
			}
		})
		require("lspconfig").clangd.setup({
			settings = {
				clangd = {}
			}
		})

		require("lspconfig").pylsp.setup({
			settings = {
				pylsp = {
					plugins = {
						ignore = { 'W391' },
						maxLineLength = 200
					}
				}
			}
		})

		-- Configuración para mason que permite la gestión de servidores LSP, formateadores, y linters.
		require("mason").setup()
		require("mason-lspconfig").setup()
	end
}
