
-- RANDOMN --

-- set leader key
vim.g.mapleader = " "

-- Remap escape key
vim.keymap.set('i', 'kj', '<Esc>', {
    desc = "Escape"
})

-- Hide highlights
vim.keymap.set('n', '<Leader>h', ':noh<CR>', {
    silent = false,
    desc = "Hide highlights"
})

-- FILES --

vim.keymap.set("n", "<Leader>w", ":w<CR>", {
    desc = "Save file",
    silent = false
})

vim.keymap.set("n", "<Leader>W", ":wall<CR>", {
    desc = "Save all file",
    silent = false
})

vim.keymap.set("n", "<Leader>q", ":q<CR>", {
    desc = "Quit file",
    silent = false
})

-- CLIPBOARD --

-- copy the whole current file to clipboard
vim.keymap.set('n', '<Leader>cf', ':lua CopyCurrentFile()<CR>', {
    silent = true,
    desc = "Copy the whole file to system clipboard"
})

-- copy selection to clipboard in visual mode
vim.keymap.set('v', '<Leader>y', "\"+y", {
    silent = false,
    desc = "Copy to clipboard"
})


-- KEYMAPS FOR TABS
vim.keymap.set('n', '<Leader>th', ':tabprevious<CR>', { silent = true, desc = "Previous tab" })
vim.keymap.set('n', '<Leader>tl', ':tabnext<CR>',     { silent = true, desc = "Next tab" })
vim.keymap.set('n', '<Leader>tn', ':tabnew<CR>',      { silent = true, desc = "Create new tab" })
vim.keymap.set('n', '<Leader>tc', ':tabclose<CR>',    { silent = true, desc = "Close tab" })

-- SPLIT SCREEN
vim.keymap.set('n', '<Leader>sq', '<C-w>q',   { silent = false, desc = "Close the current window" })
vim.keymap.set('n', '<Leader>ss', '<C-w>s',   { silent = false, desc = "Split window horizontally" })
vim.keymap.set('n', '<Leader>sv', '<C-w>v',   { silent = false, desc = "Split window vertically" })
vim.keymap.set('n', '<Leader>sh', '<C-w>h',   { silent = false, desc = "Move to left split" })
vim.keymap.set('n', '<Leader>sj', '<C-w>j',   { silent = false, desc = "Move to below split" })
vim.keymap.set('n', '<Leader>sk', '<C-w>k',   { silent = false, desc = "Move to above split" })
vim.keymap.set('n', '<Leader>sl', '<C-w>l',   { silent = false, desc = "Move to right split" })

-- OPTIONAL: Swapping / rotating splits
vim.keymap.set('n', '<Leader>sx', '<C-w>x',   { silent = false, desc = "Swap with next split" })
vim.keymap.set('n', '<Leader>sr', '<C-w>r',   { silent = false, desc = "Rotate splits" })
vim.keymap.set('n', '<Leader>sH', '<C-w>H',   { silent = false, desc = "Move current split to far left" })
vim.keymap.set('n', '<Leader>sJ', '<C-w>J',   { silent = false, desc = "Move current split to bottom" })
vim.keymap.set('n', '<Leader>sK', '<C-w>K',   { silent = false, desc = "Move current split to top" })
vim.keymap.set('n', '<Leader>sL', '<C-w>L',   { silent = false, desc = "Move current split to far right" })
vim.keymap.set('n', '<Leader>sT', '<C-w>T',   { silent = false, desc = "Move current split to new tab" })

-- BUFFER NAVIGATION
vim.keymap.set('n', '<Leader>bh', ':bprevious<CR>',   { silent = false, desc = "Previous buffer" })
vim.keymap.set('n', '<Leader>bl', ':bnext<CR>',       { silent = false, desc = "Next buffer" })
vim.keymap.set('n', '<Leader>bd', ':bdelete<CR>',     { silent = false, desc = "Delete current buffer" })
vim.keymap.set('n', '<Leader>be', ':enew<CR>',        { silent = false, desc = "New empty buffer" })

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

-- OIL.NVIM --
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Go to Oil file explorer", silent = false})

-- Define a Lua function to open help in the current window (new buffer).
local function open_help_in_current_window(topic)
  -- If no topic is provided, open the help index in a new buffer.
  if topic == nil or topic == "" then
    topic = ""
  end

  -- Create a new empty buffer in the current window.
  vim.cmd("enew")

  -- Load the requested help topic in this new buffer.
  vim.cmd("help " .. topic)
end

-- Create a user command, e.g., :HelpNew <topic>
vim.api.nvim_create_user_command("HelpNew", function(opts)
  open_help_in_current_window(opts.args)
end, {
  nargs = "?",
  complete = "help",  -- Offers completion for help topics.
  desc = "Open Vim help in the current window (new buffer).",
})

