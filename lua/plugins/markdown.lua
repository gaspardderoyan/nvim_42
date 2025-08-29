return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		opts = {},
		ft = { "markdown", "codecompanion" },
	},
	-- {
	-- 	"OXY2DEV/markview.nvim",
	-- 	lazy = false,
	-- 	opts = {
	-- 		preview = {
	-- 			filetypes = { "markdown", "codecompanion" },
	-- 			ignore_buftypes = {},
	-- 		},
	-- 	},
	-- },
}
