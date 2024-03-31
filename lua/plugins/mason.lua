return {
    "williamboman/mason.nvim",
    
    config = require('mason').setup({
    automatic_installation = true,  -- automáticamente instala los LSPs
    })
    }
