return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = 'rafamadriz/friendly-snippets',

        -- use a release tag to download pre-built binaries
        version = 'v0.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = { preset = 'default' },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },
            sources = {
                -- add lazydev to your completion providers
                default = { "lazydev", "lsp", "path", "snippets", "buffer", "markdown"},
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                    markdown = {
                        name = 'RenderMarkdown',
                        module = 'render-markdown.integ.blink'
                    }
                },
            },
        },
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
			local ensure_installed = {
				"lua_ls",
				"clangd",
				"gopls"
			}
			if vim.uv.os_uname().sysname == 'Darwin' then
				table.insert(ensure_installed, "ts_ls")
			end
            require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = ensure_installed,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            local lspconfig = require("lspconfig")

			-- function to toggle LSP diagnostics
			local toggle_diagnostics = function()
				if not vim.diagnostic.is_enabled() then
					vim.diagnostic.enable()
					vim.notify("LSP Diagnostics Enabled")
				else
					vim.diagnostic.enable(false)
					vim.notify("LSP Diagnostics Disabled")
				end
			end

            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },

                },
                capabilities = capabilities,
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
            })
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.gopls.setup({
                capabilities = capabilities,
            })


			-- Key Mappings
			vim.keymap.set('n', '<leader>dt', toggle_diagnostics, { desc = "Toggle Diagnostics Enabled/Disabled" }) -- Option 1: <leader>de (toggle diagnostics)
            ---@diagnostic disable: missing-fields
            vim.keymap.set('i', '<C-a>', vim.lsp.buf.signature_help, { desc = "Signature help" }) -- Trigger while typing
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover" })
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
                desc = "Jump to definition"
            })
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
                desc = "Jump to declaration"
            })
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {
                desc = "List references"
            })
            -- Show code actions
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code actions" })

            -- Rename symbol
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename symbol" })
            -- Show diagnostics for the current line
            vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = "Show diagnostics" })

            -- Go to the next diagnostic
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })

            -- Go to the previous diagnostic
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

            -- List diagnostics in the quickfix list
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = "Diagnostics in quickfix" })
            -- Add workspace folder
            vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })

            -- Remove workspace folder
            vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })

            -- List workspace folders
            vim.keymap.set('n', '<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, { desc = "List workspace folders" })
            ---@diagnostic enable: missing-fields
        end
    }
}
