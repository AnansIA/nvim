return {
	-- Imports
	'rcarriga/nvim-notify',
	-- Charge
	event = "VeryLazy",
	--configs
	config = function()
		local notify = require "notify"
		notify.setup {backgroud_color = "#000000"}
		vim.notify = notify.notify
	end,
}
