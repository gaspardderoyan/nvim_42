-- lua/plugins/hardtime.lua
return {
	"m4xshen/hardtime.nvim",
	lazy = false, -- load immediately (you can set to true if you prefer lazy loading)
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {
		disable_mouse = false,
		-- put your config options here
		-- example:
		-- disabled_keys = {
		--   ["<Up>"] = {},
		--   ["<Down>"] = {},
		-- },
	},
	config = function(_, opts)
		require("hardtime").setup(opts)
	end,
}
