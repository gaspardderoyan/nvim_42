return {
	{
		"folke/sidekick.nvim",
		opts = {
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
				},
				win = {
					layout = "right",
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
		},
		-- stylua: ignore
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if require("sidekick").nes_jump_or_apply() then
						return "" -- handled
					end
					return "<Tab>" -- fallback to normal tab
				end,
				expr = true,
				mode = { "i", "n" },
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<leader>aa",
				function() require("sidekick.cli").toggle() end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function() require("sidekick.cli").select() end,
				-- Or to select only installed tools:
				-- require("sidekick.cli").select({ filter = { installed = true } })
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
			-- Example of a keybinding to open Claude directly
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
