-- GENERAL --
-- tab width
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Enable break indent
vim.o.breakindent = true

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- mouse
vim.opt.mouse = "a"

vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/undo"

-- Ensure the directory exists

vim.o.hlsearch = true
vim.o.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true

-- TODO: Make this depend on filetype
-- vim.opt.colorcolumn = "88"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

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

function CopyCurrentFile()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local text = table.concat(lines, "\n")
	vim.fn.setreg("+", text)
	print("File copied to clipboard!")
end

-- Function to disable indent guides for help files
local function disable_indent_for_help()
	if vim.bo.filetype == "help" then
		-- Assuming 'Snacks' is the global table for snacks.nvim
		if require("snacks.indent") and require("snacks.indent").disable then
			require("snacks.indent").disable()
			vim.opt.colorcolumn = "0"
			vim.cmd("wincmd R")
		end
	end
end

-- Create an autocommand for help filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	callback = disable_indent_for_help,
})

-- Indentation settings for web dev
vim.api.nvim_create_augroup("FileTypeIndentation", {})
vim.api.nvim_create_autocmd("FileType", {
	group = "FileTypeIndentation",
	pattern = { "html", "javascript", "css" },
	callback = function()
		vim.opt_local.expandtab = true -- Use spaces instead of tabs.
		vim.opt_local.tabstop = 4 -- Number of spaces per tab.
		vim.opt_local.softtabstop = 4 -- Number of spaces for <Tab> and <BS>.
		vim.opt_local.shiftwidth = 4 -- Indentation level.
		vim.opt_local.autoindent = true -- Copy indent from the current line.
		vim.opt_local.smartindent = true -- Automatically inserts indentation.
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

-- If on mac, correct shell path
if not vim.fn.has("mac") then
	vim.opt.shell = "/usr/bin/zsh"
end

-- reloads the file to check for changes eg. switched git branch
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

-- function that takes a buffer as arg, otherwise takes the current one
-- if in the first 15 lines it sees the // NO_LSP comment, disables lsp diags
local function check_no_lsp_comment(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 15, false) -- Check first 15 lines
	for _, line in ipairs(lines) do
		if line:match("//%s*NO_LSP") then
			vim.diagnostic.enable(false, { buf = bufnr })
			return
		end
	end
	vim.diagnostic.enable(true, { buf = bufnr })
end

-- function to actually toggle lsp diagnostics on/off
function toggle_lsp_diagnostics(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local enabled = vim.diagnostic.is_enabled({ buf = bufnr })
	vim.diagnostic.enable(not enabled, { buf = bufnr })
	print("LSP diagnostics " .. (enabled and "disabled" or "enabled"))
end

-- autocmd
vim.api.nvim_create_autocmd({ "BufReadPost", "TextChanged", "InsertLeave" }, {
	pattern = "*.c",
	callback = function(args)
		check_no_lsp_comment(args.buf)
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.mdc" },
	command = "set filetype=markdown",
	desc = "Set filetype for .mdc files to markdown",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.wo.wrap = true
		-- vim.wo.number = false
		-- vim.wo.relativenumber = false
		vim.wo.linebreak = true
		vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
		vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
	end,
	desc = "Configure markdown buffer settings",
})

vim.diagnostic.config({
	virtual_text = false, -- no text at the end of line, need to open the hover to find it
	underline = true, -- underlines where the mistakes is
})

vim.opt.conceallevel = 1 -- or 2, depending on your preference  - for obsidian nvim

-- Open terminal in insert mode automatically
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.cmd("startinsert")
		-- Hide line numbers in terminal
	end,
})

-- Easier window navigation from terminal
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])

vim.opt.fillchars = { eob = " " }

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
	pattern = "*/todo.md",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})
