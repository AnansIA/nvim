return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/cmp-git',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'neovim/nvim-lspconfig',
		'windwp/nvim-autopairs',
	},
	config = function()
		local cmp = require 'cmp'
		
		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body) -- Asegúrate de que luasnip está instalado
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-d>'] = cmp.mapping.scroll_docs(-1),
				['<C-f>'] = cmp.mapping.scroll_docs(1),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }), -- Aceptar la sugerencia con Enter
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'cmdline' },
				{ name = 'buffer',  keyword_length = 3 }, -- Autocompletado de palabras en el buffer actual
			})
		})
		cmp.event:on("confirm_done",
			require('nvim-autopairs.completion.cmp').on_confirm_done { map_char = { text = "" } })
		require("luasnip/loaders/from_vscode").lazy_load()
		cmp.setup.filetype('gitcommit', {
			sources = cmp.config.sources({
				--{ name = 'git' },
			--}, {
				{ name = 'buffer' },
			})
		})
		cmp.setup.cmdline({ '/', '?' }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = 'buffer' }
			}
		})

		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
				{
					name = 'cmdline',
					option = {
						ignore_cmds = { 'Man', '!' }
					}
				}
			}),
			matching = { disallow_symbol_nonprefix_matching = false }
		})

	end
}
