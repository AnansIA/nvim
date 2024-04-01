return {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",  -- Colección opcional de snippets predefinidos.
    event = "InsertEnter",  -- Cargar el plugin cuando entras en modo insertar.
    config = function()
        local ls = require("luasnip")

        -- Configuración básica de LuaSnip
        ls.setup({
            history = true,  -- Habilita el historial para navegar a través de los snippets previamente expandidos.
            updateevents = "TextChanged,TextChangedI",  -- Eventos que actualizan los snippets.
        })
        -- Cargar snippets de VSCode de manera perezosa
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Keybindings básicos para expandir y navegar por los snippets.
        local opts = { silent = true }
        vim.keymap.set({ "i", "s" }, "<C-k>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, opts)

        vim.keymap.set({ "i", "s" }, "<C-j>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, opts)
    end,
}

