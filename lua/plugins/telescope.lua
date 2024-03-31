return {
	"nvim-telescope/telescope.nvim",
	--lazy = false,
	event = "VeryLazy",
	dependencies = {
		'nvim-lua/plenary.nvim',
		'jonarrien/telescope-cmdline.nvim',
		'nvim-telescope/telescope-file-browser.nvim', {
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make'
	}
	},
	tag = '0.1.6',
	opts = {
		extensions = {
			fzf = {
				fuzzy                   = true,
				override_generic_sorter = true,
				override_file_sorter    = true,
				case_mode               = 'smart_case',
			},
			cmdline = {
				picker   = {
					layout_config = {
						width  = 120,
						height = 25,
					}
				},
				mappings = {
					complete      = '<Tab>',
					run_selection = '<C-CR>',
					run_input     = '<CR>',
				},
			},


		}
	},
	config = function(opts)
		require('telescope').setup(opts)
		require('telescope').load_extension('fzf')
		require("telescope").load_extension('cmdline')
	end,
	keys = {
		{
			':',
			'<cmd>Telescope cmdline<cr>',
			desc = 'Cmdline'
		},
		{
			"ff",
			function()
				require('telescope.builtin').find_files({
					promp_title = "Files",


				})
			end,
			desc = "Buscador de archivos",
		},
		{
			"fg",
			function()
				require('telescope.builtin').git_files({ show_untracked = true })
			end,
			desc = "Busca archivos git",
		},
		{
			"fb",
			function()
				require('telescope.builtin').buffers()
			end,
			desc="Muestra los buffers activos"

		},
		{
			"fm",
			function()
				require('telescope.builtin').git_status()
			end,
			desc ="Muestra solo los archivos modificados en git"
		},
		{
			"fc",
			function()
				require('telescope.builtin').git_bcommits()
			end,
			desc = "Commits del buffer actual"
		},
		{
			"fh",
			function()
				require('telescope.builtin').help_tags()
			end,
			desc = "Ayuda de neovim"

		}


	},

}
