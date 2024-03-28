return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		'LiadOz/nvim-dap-repl-highlights'
	},
	lazy = false,
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
		require('nvim-dap-repl-highlights').setup()
		require('nvim-treesitter.configs').setup {
			highlight = {
				enable = true,
			},
			ensure_installed = { 'dap_repl' },

		}
	end,
}
