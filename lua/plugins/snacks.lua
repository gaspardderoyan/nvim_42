return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		input = { enabled = true },
		scratch = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{
						icon = "󰈞 ",
						key = "f",
						desc = "Find Files",
						action = function()
							require("telescope.builtin").find_files({
								find_command = {
									"fd",
									"--type",
									"f",
									"--exclude",
									"*.o",
									"--exclude",
									"*.out",
									"--regex",
									"^(.*\\..*)$",
								},
							})
						end,
					},
					{
						icon = "󰍉 ",
						key = "g",
						desc = "Live Grep",
						action = function()
							require("telescope.builtin").live_grep()
						end,
					},
					{
						icon = "󰈙 ",
						key = "b",
						desc = "Buffers",
						action = function()
							require("telescope.builtin").buffers()
						end,
					},
					{
						icon = "󰋚 ",
						key = "r",
						desc = "Recent Files",
						action = function()
							require("telescope.builtin").oldfiles()
						end,
					},
					{
						icon = "󰋖 ",
						key = "h",
						desc = "Help Tags",
						action = function()
							require("telescope.builtin").help_tags()
						end,
					},
					{
						icon = " ",
						key = "s",
						desc = "Git Branches",
						action = function()
							require("telescope.builtin").git_branches()
						end,
					},
					{
						icon = "󰜘 ",
						key = "c",
						desc = "Git Commits",
						action = function()
							require("telescope.builtin").git_commits()
						end,
					},
					{
						icon = "󰈚 ",
						key = "m",
						desc = "Marks",
						action = function()
							require("telescope.builtin").marks()
						end,
					},
					{
						icon = "󰏗 ",
						key = "R",
						desc = "Registers",
						action = function()
							require("telescope.builtin").registers()
						end,
					},
					{
						icon = "󰈚 ",
						key = "v",
						desc = "Nvim Config",
						action = function()
							require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
						end,
					},
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
		explorer = { enabled = true, replace_netrw = true },
		indent = { enabled = true },
		picker = {
			enabled = true,
			sources = {
				---@class snacks.picker.explorer.config
				explorer = {
					layout = { preset = "sidebar", preview = "main", hidden = { "preview" } },
				},
			},
		},
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		toggle = { enabled = true, map = vim.keymap.set, which_key = true },
		lazygit = { enabled = true },
	},
	keys = {
		{
			"<leader>.",
			function()
				Snacks.scratch({ type = "markdown" })
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit Log",
		},
		{
			"<leader>gf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit File History",
		},
	},
}
