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

			-- vim.keymap.set("n", "<C-i>", function()
			-- 	harpoon:list():select(1)
			-- end, { desc = "Harpoon select file 1", silent = false })
			-- vim.keymap.set("n", "<C-o>", function()
			-- 	harpoon:list():select(2)
			-- end, { desc = "Harpoon select file 2", silent = false })
			-- vim.keymap.set("n", "<C-p>", function()
			-- 	harpoon:list():select(3)
			-- end, { desc = "Harpoon select file 3", silent = false })
			-- vim.keymap.set("n", "<C-[>", function()
			-- 	harpoon:list():select(4)
			-- end, { desc = "Harpoon select file 4", silent = false })

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
