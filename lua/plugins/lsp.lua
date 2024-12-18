return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "clangd" }
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
            lspconfig.clangd.setup({})
            lspconfig.pyright.setup({})
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
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostics" })

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
        end,
    }
}
