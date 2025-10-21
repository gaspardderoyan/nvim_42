return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = true,
		-- priority = 1000,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		-- priority = 1000,
		-- config = function()
		-- 	vim.cmd("colorscheme catppuccin-macchiato")
		-- 	vim.cmd([[
		-- 		  hi Normal guibg=NONE ctermbg=NONE
		-- 		  hi NormalNC guibg=NONE ctermbg=NONE
		-- 		  hi EndOfBuffer guibg=NONE ctermbg=NONE
		-- 		  hi VertSplit guibg=NONE ctermbg=NONE
		-- 		  hi StatusLine guibg=NONE ctermbg=NONE
		-- 		  hi LineNr guibg=NONE ctermbg=NONE
		-- 		  hi SignColumn guibg=NONE ctermbg=NONE
		-- 		]])
		-- end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "moon",
				dark_variant = "moon",
			})
			vim.cmd("colorscheme rose-pine")
			vim.cmd([[
				  hi Normal guibg=NONE ctermbg=NONE
				  hi NormalNC guibg=NONE ctermbg=NONE
				  hi EndOfBuffer guibg=NONE ctermbg=NONE
				  hi VertSplit guibg=NONE ctermbg=NONE
				  hi StatusLine guibg=NONE ctermbg=NONE
				  hi LineNr guibg=NONE ctermbg=NONE
				  hi SignColumn guibg=NONE ctermbg=NONE
				  hi StatusLineTerm guibg=NONE ctermbg=NONE
				  hi StatusLineTermNC guibg=NONE ctermbg=NONE
				]])
		end,
	},
	{
		"Mofiqul/dracula.nvim",
		-- priority = 1000,
		-- config = function()
		--     require("dracula").setup({})
		--          vim.cmd("colorscheme dracula")
		-- vim.cmd("highlight Tabline guibg=#111217")
		-- vim.cmd("highlight TablineFill guibg=#1C1E26")
		-- vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
		-- Make sign column background match the normal background
		-- vim.cmd('highlight SignColumn guibg=NONE ctermbg=NONE')
		-- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#3D4052' })
		-- end
	},
}
