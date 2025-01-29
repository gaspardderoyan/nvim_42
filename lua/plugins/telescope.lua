return {
    -- "BurntSushi/ripgrep",
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        config = function()
			local telescope = require('telescope')
            local builtin = require('telescope.builtin')

			-- Global telescope steup
			telescope.setup{
				defaults = {
					-- file_ignore_patterns = {
					-- 	 "^[^%.]+$", -- Files with no extension
					-- }
				}
			}
			vim.keymap.set('n', '<leader>ff', function()
				builtin.find_files({
					find_command = {
						'fd', '--type', 'f',
						'--exclude', '*.o',
						'--exclude', '*.out',
						'--regex', '^(README|Makefile|.*\\..*)$',
					}, -- no_ignore = true
				})
			end, { desc = "Find files" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = "Live Grep"})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc = "Buffers"})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = "Help Tags"})
            vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {desc = "Recent Files"})
            vim.keymap.set('n', '<leader>fv', function()
                builtin.find_files { cwd = vim.fn.stdpath("config") }
            end, { desc = "Nvim Config" })
        end
    }
}

