return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
}
