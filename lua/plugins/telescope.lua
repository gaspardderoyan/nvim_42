return {
    -- "BurntSushi/ripgrep",
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            "nvim-telescope/telescope-fzf-native.nvim",
            "apdot/doodle", -- For doodle extension
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
				},
				extensions = {
					doodle = {}
				}
			}
			telescope.load_extension('doodle')
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

            -- Doodle Telescope extensions
            vim.keymap.set("n", "<space>dn", function()
                telescope.extensions.doodle.find_notes()
            end, { desc = "Doodle Find Notes" })

            vim.keymap.set("n", "<space>dff", function()
                telescope.extensions.doodle.find_files()
            end, { desc = "Doodle Find Files" })

            vim.keymap.set("n", "<space>dt", function()
                telescope.extensions.doodle.find_templates()
            end, { desc = "Doodle Find Templates" })
            
            -- Custom filtered buffer symbols picker
            vim.keymap.set('n', '<leader>fS', function()
                local pickers = require 'telescope.pickers'
                local finders = require 'telescope.finders'
                local conf = require('telescope.config').values
                local actions = require 'telescope.actions'
                local action_state = require 'telescope.actions.state'
                local utils = require 'telescope.utils'
                local entry_display = require 'telescope.pickers.entry_display'

                -- Names to ignore
                local ignored_symbols = {
                    exec_async = true,
                    prep_async = true,
                    post_async = true,
                }

                -- LSP SymbolKind values to include
                local allowed_symbol_kinds = {
                    [5] = true,   -- Class
                    [6] = true,   -- Method
                    [12] = true,  -- Function
                }

                local bufnr = vim.api.nvim_get_current_buf()

                -- Collect LSP document symbols
                local params = { textDocument = vim.lsp.util.make_text_document_params() }
                local lsp_results = vim.lsp.buf_request_sync(bufnr, 'textDocument/documentSymbol', params, 1000)

                local symbols = {}
                if lsp_results then
                    for _, server_result in pairs(lsp_results) do
                        if server_result.result then
                            local function collect(syms, parent_name)
                                for _, s in ipairs(syms) do
                                    if allowed_symbol_kinds[s.kind] then
                                        local name = s.name or ""
                                        if not ignored_symbols[name] then
                                            local kind_name = vim.lsp.protocol.SymbolKind[s.kind] or 'Unknown'
                                            local range = s.selectionRange or s.range or (s.location and s.location.range)
                                            table.insert(symbols, {
                                                name = name,
                                                kind = kind_name,
                                                lnum = (range and range.start and range.start.line or 0) + 1,
                                                col = (range and range.start and range.start.character or 0) + 1,
                                                parent = parent_name,
                                                bufnr = bufnr,
                                            })
                                        end
                                    end
                                    if s.children then
                                        collect(s.children, s.name)
                                    end
                                end
                            end
                            collect(server_result.result)
                        end
                    end
                end

                -- Fallback to builtin.treesitter if no symbols found
                if #symbols == 0 then
                    builtin.treesitter({ symbols = { 'function', 'method', 'class' } })
                    return
                end

                -- Columnar display similar to builtin.treesitter
                local displayer = entry_display.create({
                    separator = ' ',
                    items = {
                        { width = 10 },          -- kind
                        { remaining = true },     -- name (with parent)
                        { width = 8, right_justify = true }, -- line:col
                        { width = 0 },            -- filename tail
                    },
                })

                local function make_display(entry)
                    return displayer({
                        { string.format('[%s]', string.lower(entry.kind or '')), 'TelescopeResultsComment' },
                        entry.display_name,
                        { string.format('%d:%d', entry.lnum or 0, entry.col or 0), 'TelescopeResultsNumber' },
                        { utils.path_tail(entry.filename or ''), 'TelescopeResultsIdentifier' },
                    })
                end

                pickers.new({}, {
                    prompt_title = 'Buffer Symbols (Filtered)',
                    finder = finders.new_table({
                        results = symbols,
                        entry_maker = function(e)
                            local filename = vim.api.nvim_buf_get_name(e.bufnr)
                            local display_name = e.parent and (e.parent .. '.' .. e.name) or e.name
                            return {
                                value = e,
                                display = make_display,
                                ordinal = table.concat({ e.kind or '', display_name, filename }, ' '),
                                filename = filename,
                                display_name = display_name,
                                kind = e.kind,
                                lnum = e.lnum,
                                col = e.col,
                            }
                        end,
                    }),
                    sorter = conf.generic_sorter({}),
                    previewer = conf.qflist_previewer({}),
                    attach_mappings = function(prompt_bufnr, _)
                        actions.select_default:replace(function()
                            actions.close(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            if selection then
                                vim.api.nvim_win_set_cursor(0, { selection.lnum, (selection.col or 1) - 1 })
                            end
                        end)
                        return true
                    end,
                }):find()
            end, { desc = 'Buffer Symbols (Filtered)' })
        end
    }
}
