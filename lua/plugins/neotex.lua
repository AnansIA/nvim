return {
    "donRaphaco/neotex",
    config = function()
      vim.g.neotex_enabled = 1 -- Habilita NeoTex por defecto
      -- Configura aquí otras opciones de NeoTex según necesites
    end,
    ft = { "tex" }, -- Carga NeoTex solo para archivos .tex
  }
