-- set leader key
vim.g.mapleader = " "

--[[ Normal toggle
--
--     vim.api.nvim_set_keymap("n", "<leader>e", ':NvimTreeToggle<CR>', {
--         noremap = true,
--         silent = true,
--         desc = 'Toggle NvimTree',
--     })
--]]

-- toggle/focus NvimTree
-- vim.keymap.set("n", "<leader>e", nvimTreeFocusOrToggle)

-- save the current file
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", {
    noremap = true,
    silent = true,
    desc = "Save file"
})

-- copy the whole current file to clipboard
vim.api.nvim_set_keymap('n', '<Leader>cf', ':lua CopyCurrentFile()<CR>', { noremap = true, silent = true, desc = "Copy the whole file to system clipboard"})

-- open tab silently 
-- vim.keymap.set('n', 'T', open_tab_silent, {
--     noremap = true,
--     silent = true,
--     desc = "Open tab silently",
-- })

-- copy selection to clipboard in visual mode
vim.api.nvim_set_keymap('v', '<Leader>y', "\"+y", {
    noremap = true,
    silent = false,
    desc = "Copy to clipboard"
})

-- Hide highlights
vim.api.nvim_set_keymap('n', '<Leader>h', ':noh<CR>', {
    noremap = true,
    silent = false,
    desc = "Hide highlights"
})

-- KEYMAPS FOR TABS
vim.api.nvim_set_keymap('n', '<Leader>th', ':tabp<CR>', {
    noremap = true,
    silent = true,
    desc = "Previous tab"
})
vim.api.nvim_set_keymap('n', '<Leader>tl', ':tabn<CR>', {
    noremap = true,
    silent = true,
    desc = "Next tab"
})
vim.api.nvim_set_keymap('n', '<Leader>tn', ':tabnew<CR>', {
    noremap = true,
    silent = true,
    desc = "Create new tab"
})
vim.api.nvim_set_keymap('n', '<Leader>tc', ':tabclose<CR>', {
    noremap = true,
    silent = true,
    desc = "Close tab"
})

-- SPLIT SCREEN -- I really hate ctrl key
vim.api.nvim_set_keymap('n', '<Leader>sq', '<C-w>q', {
    noremap = true,
    silent = false,
    desc = "Close the current window"
})
vim.api.nvim_set_keymap('n', '<Leader>ss', '<C-w>s', {
    noremap = true,
    silent = false,
    desc = "Split window horizontally"
})
vim.api.nvim_set_keymap('n', '<Leader>sv', '<C-w>v', {
    noremap = true,
    silent = false,
    desc = "Split window vertically"
})
vim.api.nvim_set_keymap('n', '<Leader>sh', '<C-w><C-h>', {
    noremap = true,
    silent = false,
    desc = "Move to left split"
})
vim.api.nvim_set_keymap('n', '<Leader>sj', '<C-w><C-j>', {
    noremap = true,
    silent = false,
    desc = "Move to below split"
})
vim.api.nvim_set_keymap('n', '<Leader>sk', '<C-w><C-k>', {
    noremap = true,
    silent = false,
    desc = "Move to above split"
})
vim.api.nvim_set_keymap('n', '<Leader>sl', '<C-w><C-l>', {
    noremap = true,
    silent = false,
    desc = "Move to right split"
})

-- TODO command to open oil w/ space-e

-- Normal mode 'J' command merges the current line with the next line, but we store the cursor position (mz) and restore it (`z).
-- This prevents your cursor from jumping unnecessarily after the join.
vim.keymap.set("n", "J", "mzJ`z")

-- Center the screen after half-page scrolling in normal mode.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- When searching forward (n) or backward (N), center the screen afterward.
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- The "greatest remap ever": When in visual mode (x) and pressing <leader>p, paste over a selection
-- without overwriting the default register (use "_d to delete and then P).
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Disable (nop) the 'Q' command in normal mode because it's rarely used (and can conflict with macros).
vim.keymap.set("n", "Q", "<nop>")


-- <leader>s starts a global search-and-replace using the word under cursor.
-- The placeholder `<Left><Left><Left>` positions the cursor within the command line to adjust the search string if needed.
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- TODO find another thing than 's'

-- OIL.NVIM --
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Go to Oil file explorer", silent = false})
