-- set leader key
vim.g.mapleader = " "

--[[ Normal toggle

    vim.api.nvim_set_keymap("n", "<leader>e", ':NvimTreeToggle<CR>', {
        noremap = true,
        silent = true,
        desc = 'Toggle NvimTree',
    })
--]]

-- toggle/focus NvimTree
vim.keymap.set("n", "<leader>e", nvimTreeFocusOrToggle)

-- save the current file
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", {
    noremap = true,
    silent = true,
    desc = "Save file"
})

-- copy the whole current file to clipboard
vim.api.nvim_set_keymap('n', '<Leader>cf', ':lua CopyCurrentFile()<CR>', { noremap = true, silent = true, desc = "Copy the whole file to system clipboard"})

-- open tab silently 
vim.keymap.set('n', 'T', open_tab_silent, {
    noremap = true,
    silent = true,
    desc = "Open tab silently",
})

-- copy selection to clipboard in visual mode
vim.api.nvim_set_keymap('v', '<Leader>y', "\"+y", {
    noremap = true,
    silent = false,
    desc = "Copy to clipboard"
})

-- source the current file
vim.api.nvim_set_keymap('n', '<Leader>so', ":so %<CR>", {
    noremap = true,
    silent = false,
    desc = "Source the current file"
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

