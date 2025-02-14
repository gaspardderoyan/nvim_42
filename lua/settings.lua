-- GENERAL -- 
-- tab width
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- mouse
vim.opt.mouse = 'a'

vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('config') .. '/undo'

-- Ensure the directory exists

vim.o.hlsearch = true
vim.o.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true

vim.opt.colorcolumn = "80"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.have_nerd_font = true

vim.o.autoread = true

vim.opt.scrolloff = 10

vim.opt.grepprg = 'rg --vimgrep -uu --glob "!.git"'

-- FOLDS -- 
-- basic
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99

-- Auto-save and load folds
vim.api.nvim_create_augroup("AutoSaveFolds", {})
vim.api.nvim_create_autocmd("BufWinLeave", {
    group = "AutoSaveFolds",
    pattern = "*",
    callback = function(args)
-- Only proceed if this buffer actually has a name and isn't a special buffer:
        local buftype = vim.api.nvim_buf_get_option(args.buf, "buftype")
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        if buftype == "" and bufname ~= "" then
            vim.cmd("mkview")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = "AutoSaveFolds",
    pattern = "*",
    callback = function(args)
        local buftype = vim.api.nvim_buf_get_option(args.buf, "buftype")
        local bufname = vim.api.nvim_buf_get_name(args.buf)

        if buftype == "" and bufname ~= "" then
            vim.cmd("silent! loadview")
        end
    end,
})
-- Toggle fold with <Tab>
-- vim.keymap.set("n", "<Tab>", "za", { noremap = true, silent = true })





function CopyCurrentFile()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local text = table.concat(lines, "\n")
    vim.fn.setreg("+", text)
    print("File copied to clipboard!")
end

-- Function to disable indent guides
local function disable_indent_for_help()
    if vim.bo.filetype == 'help' then
        -- Assuming 'Snacks' is the global table for snacks.nvim
        if Snacks and Snacks.indent and Snacks.indent.disable then
            Snacks.indent.disable()
            vim.opt.colorcolumn = "0"
            vim.cmd("wincmd R")
        end
    end
end

-- Create an autocommand for help filetypes
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'help',
    callback = disable_indent_for_help,
})

-- Indentation settings for web dev
vim.api.nvim_create_augroup("FileTypeIndentation", {})
vim.api.nvim_create_autocmd("FileType", {
    group = "FileTypeIndentation",
    pattern = { "html", "javascript", "css" },
    callback = function()
        vim.opt_local.expandtab = true    -- Use spaces instead of tabs.
        vim.opt_local.tabstop = 2         -- Number of spaces per tab.
        vim.opt_local.softtabstop = 2     -- Number of spaces for <Tab> and <BS>.
        vim.opt_local.shiftwidth = 2      -- Indentation level.
        vim.opt_local.autoindent = true   -- Copy indent from the current line.
        vim.opt_local.smartindent = true  -- Automatically inserts indentation.
    end,
})

-- HIghlight tabs and trailing spaces for web dev
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "javascript", "css" },
    callback = function()
        vim.opt_local.list = true
        vim.opt_local.listchars = { tab = "»·", trail = "·" }
    end,
})


vim.opt.shell = "/usr/bin/zsh"

-- reloads the file to check for changes eg. switched git branch
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- function that takes a buffer as arg, otherwise takes the current one
-- if in the first 15 lines it sees the // NO_LSP comment, disables lsp diags
local function toggle_lsp_diagnostics(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 15, false) -- Check first 15 lines
    for _, line in ipairs(lines) do
        if line:match("//%s*NO_LSP") then
            vim.diagnostic.disable(bufnr)
            return
        end
    end
    vim.diagnostic.enable(bufnr)
end

-- autocmd
vim.api.nvim_create_autocmd({ "BufReadPost", "TextChanged", "InsertLeave" }, {
    pattern = "*.c",
    callback = function(args)
        toggle_lsp_diagnostics(args.buf)
    end,
})

vim.diagnostic.config({
	virtual_text = false, -- no text at the end of line, need to open the hover to find it
	underline = true, -- underlines where the mistakes is 
})

