return {
	'neovim/nvim-lspconfig',
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"folke/neodev.nvim",
	},
	
	config = function()
		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
		vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
		vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
		vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
		local on_attach = function(_, bufnr)
			local opts = {buffer = bufnr}
			vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
			vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
			vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
			--vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
			--vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
			--vim.keymap.set('n', '<space>wl', function()
			--print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			--end, opts)
			--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
			vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, opts)
			vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
			vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
			vim.keymap.set('n', '<space>f', function()
				vim.lsp.buf.format { async = true }
			end, {})
		end
		require("neodev").setup({
			library = { plugins = { "nvim-dap-ui" }, types = true },

		})
		require("lspconfig").lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,		
			settings = {
				Lua = {
					telemetry = { enable = false },
					workspace = { checkThirdParty = false },
					codeLens = { enable = true},
				 	completion = {  callSnippet = "Enable"},


				}
			}
		})
		require("lspconfig").pylsp.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				pylsp = {
					plugins = {
						pycodestyle = {
							ignore = { 'W391' },
							maxLineLength = 100
						}
					}
				}
			}
		})
		require('lspconfig').clangd.setup({
			capabilities = capabilities,
			on_attach = on_attach,

		})
	end
}
