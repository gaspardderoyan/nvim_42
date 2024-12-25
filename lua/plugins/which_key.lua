return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.add({
            { "<leader>b", group = "buffers" },
            { "<leader>t", group = "tabs" },
            { "<leader>f", group = "telescope" },
            { "<leader>s", group = "splits" },
        })
    end
}

