 return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜", -- symbol used between a number and the key
            group = "+", -- symbol prepended to a group
        },
        win = {
            border = "single",  -- Change to "rounded" if you prefer
            padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
        },
        layout = {
            height = { min = 4, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 50 }, -- min and max width of the columns
            spacing = 3, -- spacing between columns
            align = "left", -- align columns left, center or right
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        -- NEW: Register plugin groups for better awareness (e.g., Harpoon) using new spec
        wk.add({
            -- Leader mappings
            { "<leader>A", group = "Harpoon Add" },
            { "<leader>c", group = "Copilot" },
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git" },
            { "<leader>h", group = "Harpoon" },
            { "<leader>h_", hidden = true },
        })

        -- Global mappings (non-leader, e.g., Harpoon's <C-x>)
        wk.add({
            { "<C-S-N>", group = "Harpoon Next" },
            { "<C-S-P>", group = "Harpoon Prev" },
            { "<C-x>", group = "Harpoon Menu" },
        })
    end,
}

