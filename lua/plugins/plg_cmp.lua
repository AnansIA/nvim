return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/cmp-vsnip',
		'hrsh7th/vim-vsnip',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'windwp/nvim-autopairs'
	},
	event = "VeryLazy",
	main = "plugins.configcmp",
	config = function()
		local cmp = require('cmp')

		cmp.setup({
			snippet = {
				expand = function(args)
					require('luapnsip').lsp_expand(args.body)
				end,
			},
			sources = {
				{ name = 'buffer' },
				{ name = 'path' },
				{ name = 'vsnip' },
				{ name = 'luasnip' },
				{ name = 'cmdline' }
			},
			mapping = {
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
			}

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
				{ name = 'cmdline' }
			}),
			matching = { disallow_symbol_nonprefix_matching = false }
		})
	end
}
