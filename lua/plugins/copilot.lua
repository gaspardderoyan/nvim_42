return {
	{
		"folke/sidekick.nvim",
		opts = function()
			local split_ratio = 0.4
			return {
				nes = {
					enabled = true,
					debounce = 100,
				},
				cli = {
					mux = {
						enabled = true,
						backend = "zellij",
						create = "terminal", -- or "window" for tmux tabs
						focus = true,
						split = {
							size = split_ratio,
						},
					},
					win = {
						layout = "right",
						split = {
							width = math.floor(vim.o.columns * split_ratio),
						},
					},
					tools = {
						claude = { cmd = { "claude" } },
					},
				},
				copilot = {
					status = {
						enabled = true,
						level = vim.log.levels.WARN,
					},
				},
				debug = true,
			}
		end,
		-- stylua: ignore
		keys = {
			{
				"<Tab>",
				function()
					if require("sidekick").nes_jump_or_apply() then
						return
					end
					return "<Tab>"
				end,
				mode = "n",
				desc = "Sidekick: Jump/Apply Next Edit Suggestion",
			},
			{
				"<leader>aa",
				function() require("sidekick.cli").toggle() end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function() require("sidekick.cli").select() end,
				desc = "Select CLI",
			},
			{
				"<leader>at",
				function() require("sidekick.cli").send({ msg = "{this}" }) end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>av",
				function() require("sidekick.cli").send({ msg = "{selection}" }) end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function() require("sidekick.cli").prompt() end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			{
				"<c-space>",
				function() require("sidekick.cli").focus() end,
				mode = { "n", "x", "i", "t" },
				desc = "Sidekick Switch Focus",
			},
			{
				"<leader>aC",
				function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
				desc = "Sidekick Show Claude",
			},
			{
				"<leader>aO",
				function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
				desc = "Sidekick Toggle OpenCode",
			},
		},
	},
}
