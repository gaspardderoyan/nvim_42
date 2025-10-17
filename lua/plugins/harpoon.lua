return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()
			vim.keymap.set("n", "<leader>A", function()
				harpoon:list():add()
			end, { desc = "Add file to harpoon", silent = false })
			vim.keymap.set("n", "<C-x>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Toggle harpoon quick menu", silent = false })

			-- Set <space>1..<space>5 be my shortcuts to moving to the files
			for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
				vim.keymap.set("n", string.format("<space>%d", idx), function()
					harpoon:list():select(idx)
				end, { desc = string.format("Harpoon to %d", idx), silent = false })
			end

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end, { desc = "Harpoon previous buffer", silent = false })
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end, { desc = "Harpoon next buffer", silent = false })

			-- NEW: Integrate with Telescope for Harpoon marks
			require("telescope").load_extension("harpoon")

			-- NEW: Keymap for Harpoon marks in Telescope
			vim.keymap.set("n", "<leader>fh", function()
				require("telescope").extensions.harpoon.marks()
			end, { desc = "Harpoon marks" })
		end,
	},
}
