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
	event = "VeryLazy",
	config = function()
		local luasnip = require("luasnip")
		require("luasnip/loaders/from_vscode").lazy_load()
		local cmp = require('cmp')
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			view = {
				entries = 'custom', -- this appears to be the issue
			},
			sources = {
				{
					{
						name = 'buffer',
						option = {
							get_bufnrs = function()
								return { vim.api.nvim_get_current_buf() }
							end,

						}
					},
					{ name = 'path' },
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'cmdline' },

				}, {
				name = 'buffer',
			}
			},
			mapping = {
				['<C-a>'] = cmp.mapping.scroll_docs(-4),
				['<C-b>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<Tab>'] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true
				}),
			},
			window = {
				documentation = cmp.config.window.bordered()
			},
		})

		cmp.event:on("confirm_done",
			require('nvim-autopairs.completion.cmp').on_confirm_done { map_char = { text = "" } })
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
