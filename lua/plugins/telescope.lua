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
						'--regex', '^(.*\\..*)$',
					}, -- no_ignore = true
				})
			end, { desc = "Find files" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = "Live Grep"})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc = "Buffers"})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = "Help Tags"})
            vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {desc = "Recent Files"})
            vim.keymap.set('n', '<leader>fs', builtin.git_branches , {desc = "Git Branches"})
            vim.keymap.set('n', '<leader>fc', builtin.git_commits , {desc = "Git Commits"})
            vim.keymap.set('n', '<leader>fC', builtin.git_bcommits , {desc = "Git Buffer Commits"})
            vim.keymap.set('n', '<leader>fR', builtin.lsp_references , {desc = "LSP References"})
            vim.keymap.set('n', '<leader>fm', builtin.marks , {desc = "Marks"})
            vim.keymap.set('n', '<leader>fG', builtin.registers , {desc = "Registers"})
            vim.keymap.set('n', '<leader>fv', function()
                builtin.find_files { cwd = vim.fn.stdpath("config") }
            end, { desc = "Nvim Config" })
            
            -- Custom filtered buffer symbols picker
            vim.keymap.set('n', '<leader>fS', function()
                local pickers = require "telescope.pickers"
                local finders = require "telescope.finders"
                local conf = require("telescope.config").values
                local actions = require "telescope.actions"
                local action_state = require "telescope.actions.state"
                local utils = require "telescope.utils"
                
                -- Symbol names to ignore
                local ignored_symbols = {
                    ["exec_async"] = true,
                    ["prep_async"] = true,
                    ["post_async"] = true
                }
                
                -- Symbol types we want to show (LSP symbol kinds)
                local allowed_symbol_kinds = {
                    [6] = true,   -- Method
                    [12] = true,  -- Function  
                    [5] = true,   -- Class
                }
                
                local bufnr = vim.api.nvim_get_current_buf()
                
                -- Get LSP document symbols
                local params = { textDocument = vim.lsp.util.make_text_document_params() }
                local results_lsp, err = vim.lsp.buf_request_sync(
                    bufnr, "textDocument/documentSymbol", params, 1000
                )
                
                local symbols = {}
                if results_lsp then
                    for _, server_result in pairs(results_lsp) do
                        if server_result.result then
                            local function extract_symbols(syms, parent_name)
                                for _, symbol in ipairs(syms) do
                                    -- Check if it's an allowed symbol type
                                    if allowed_symbol_kinds[symbol.kind] then
                                        local symbol_name = symbol.name
                                        -- Skip ignored symbols
                                        if not ignored_symbols[symbol_name] then
                                            local kind_name = vim.lsp.protocol.SymbolKind[symbol.kind] or "Unknown"
                                            local range = symbol.selectionRange or symbol.range
                                            table.insert(symbols, {
                                                name = symbol_name,
                                                kind = kind_name,
                                                lnum = range.start.line + 1,
                                                col = range.start.character + 1,
                                                parent = parent_name,
                                                bufnr = bufnr
                                            })
                                        end
                                    end
                                    -- Recursively check children
                                    if symbol.children then
                                        extract_symbols(symbol.children, symbol.name)
                                    end
                                end
                            end
                            extract_symbols(server_result.result)
                        end
                    end
                end
                
                -- If no LSP symbols, fallback to basic treesitter
                if #symbols == 0 then
                    builtin.treesitter({
                        symbols = { "function", "method", "class" }
                    })
                    return
                end
                
                pickers.new({}, {
                    prompt_title = "Buffer Symbols (Filtered)",
                    finder = finders.new_table {
                        results = symbols,
                        entry_maker = function(entry)
                            local display_name = entry.parent and 
                                string.format("%s.%s", entry.parent, entry.name) or 
                                entry.name
                            return {
                                value = entry,
                                display = string.format("[%s] %s", entry.kind:lower(), display_name),
                                ordinal = entry.name,
                                filename = vim.api.nvim_buf_get_name(entry.bufnr),
                                lnum = entry.lnum,
                                col = entry.col,
                            }
                        end,
                    },
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(prompt_bufnr, map)
                        actions.select_default:replace(function()
                            actions.close(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            if selection then
                                vim.api.nvim_win_set_cursor(0, {selection.lnum, selection.col - 1})
                            end
                        end)
                        return true
                    end,
                }):find()
            end, { desc = "Buffer Symbols (Filtered)" })
        end
    }
}
