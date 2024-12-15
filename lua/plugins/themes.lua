return {
    {
        "scottmckendry/cyberdream.nvim",
        lazy = true,
        priority = 1000,
    },
    { 
        "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000,
        config = function()
            vim.cmd("colorscheme catppuccin-mocha")
        end
    },
    {
        "rose-pine/neovim", 
        name = "rose-pine",
        lazy = true,
        -- config = function()
        --     vim.cmd("colorscheme rose-pine-moon")
        -- end
    }
}


