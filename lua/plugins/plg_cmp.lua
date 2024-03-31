return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		--'hrsh7th/cmp-vsnip',
		--'hrsh7th/vim-vsnip',
		'L3MON4D3/LuaSnip',
		'neovim/nvim-lspconfig',
		'saadparwaiz1/cmp_luasnip',
		'windwp/nvim-autopairs',
	},
	event = "VeryLazy",
	--main = "plugins.configcmp",
	config = function()
		local cmp = require('cmp')

		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
			},
			sources = {
				{
					{ name = 'buffer' },
					{ name = 'path' },
					{ name = 'nvim_lsp' },
		--			{ name = 'vsnip' },
					{ name = 'luasnip' },
					{ name = 'cmdline' },

				}, {
				name = 'buffer',
			}
			},
			mapping = {
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
			},
			window = {
				documentation = cmp.config.window.bordered()
			},
		})

		cmp.event:on("confirm_done", require('nvim-autopairs.completion.cmp').on_confirm_done { map_char= { text = "" }})

		cmp.setup.cmdline({ '/', '?' }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = 'buffer' }
			}
		})

		--		cmp.setup.cmdline(':', {
		--			mapping = cmp.mapping.preset.cmdline(),
		--			sources = cmp.config.sources({
		--				{ name = 'path' }
		--			}, {
		--				{ name = 'cmdline' }
		--			}),
		--			matching = { disallow_symbol_nonprefix_matching = false }
		--		})

		-- `:` cmdline setup.
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
			})
		})
	end
}
