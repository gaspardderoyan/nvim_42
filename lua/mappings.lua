-- set leader key
vim.g.mapleader = " "

-- RANDOMN --

-- Hide highlights
vim.api.nvim_set_keymap('n', '<Leader>h', ':noh<CR>', {
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
vim.api.nvim_set_keymap('n', '<Leader>cf', ':lua CopyCurrentFile()<CR>', {
    silent = true,
    desc = "Copy the whole file to system clipboard"
})

-- copy selection to clipboard in visual mode
vim.api.nvim_set_keymap('v', '<Leader>y', "\"+y", {
    silent = false,
    desc = "Copy to clipboard"
})


-- KEYMAPS FOR TABS
vim.api.nvim_set_keymap('n', '<Leader>th', ':tabp<CR>', {
    silent = true,
    desc = "Previous tab"
})
vim.api.nvim_set_keymap('n', '<Leader>tl', ':tabn<CR>', {
    silent = true,
    desc = "Next tab"
})
vim.api.nvim_set_keymap('n', '<Leader>tn', ':tabnew<CR>', {
    silent = true,
    desc = "Create new tab"
})
vim.api.nvim_set_keymap('n', '<Leader>tc', ':tabclose<CR>', {
    silent = true,
    desc = "Close tab"
})

-- SPLIT SCREEN -- I really hate ctrl key
vim.api.nvim_set_keymap('n', '<Leader>sq', '<C-w>q', {
    silent = false,
    desc = "Close the current window"
})
vim.api.nvim_set_keymap('n', '<Leader>ss', '<C-w>s', {
    silent = false,
    desc = "Split window horizontally"
})
vim.api.nvim_set_keymap('n', '<Leader>sv', '<C-w>v', {
    silent = false,
    desc = "Split window vertically"
})
vim.api.nvim_set_keymap('n', '<Leader>sh', '<C-w><C-h>', {
    silent = false,
    desc = "Move to left split"
})
vim.api.nvim_set_keymap('n', '<Leader>sj', '<C-w><C-j>', {
    silent = false,
    desc = "Move to below split"
})
vim.api.nvim_set_keymap('n', '<Leader>sk', '<C-w><C-k>', {
    silent = false,
    desc = "Move to above split"
})
vim.api.nvim_set_keymap('n', '<Leader>sl', '<C-w><C-l>', {
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
vim.keymap.set("n", "<leader>E", "<CMD>Oil<CR>", { desc = "Go to Oil file explorer", silent = false})

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

