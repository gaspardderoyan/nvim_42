return {
	{
		"bngarren/checkmate.nvim",
		ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
		opts = {
			-- files = { "*.md" }, -- any .md file (instead of defaults)
			keys = {
				["<leader>Tt"] = {
					rhs = "<cmd>Checkmate toggle<CR>",
					desc = "Toggle todo item",
					modes = { "n", "v" },
				},
				["<leader>Tc"] = false,
				["<leader>Tu"] = false,
				["<leader>T="] = false,
				["<leader>T-"] = false,
				["<leader>Tn"] = {
					rhs = "<cmd>Checkmate create<CR>",
					desc = "Create todo item",
					modes = { "n", "v" },
				},
				["<leader>Tr"] = false,
				["<leader>TR"] = false,
				["<leader>Ta"] = {
					rhs = "<cmd>Checkmate archive<CR>",
					desc = "Archive checked/completed todo items (move to bottom section)",
					modes = { "n" },
				},
				["<leader>Tv"] = false,
				["<leader>T]"] = false,
				["<leader>T["] = false,
			},
		},
	},
}
