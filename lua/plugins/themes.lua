return {
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
    },
    { 
        "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000,
    },
    {
        "rose-pine/neovim", 
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine-moon")
        end
    }
}


