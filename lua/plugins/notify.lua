return {
	'rcarriga/nvim-notify',
	event = "VeryLazy",
	config = function()
		local notify = require "notify"
		notify.setup {backgroud_color = "#000000"}
		vim.notify = notify.notify
	end,
}
