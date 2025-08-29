return {
	"epwalsh/obsidian.nvim",
	-- ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "main",
				path = "~/SyncThing/Gas24"
			}
		},
		daily_notes = {
			folder = "Daily Notes",
		},
		ui = {
			enable = true,
		},
	},
}
