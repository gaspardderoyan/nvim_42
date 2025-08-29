-- Floating terminal
return {
	{
		"voldikss/vim-floaterm",
		init = function()
			vim.g.floaterm_keymap_new = "<F7>"
			vim.g.floaterm_keymap_prev = "<F8>"
			vim.g.floaterm_keymap_next = "<F9>"
			vim.g.floaterm_keymap_toggle = "<F12>"
		end,
		config = function()
			local function run_python_module()
				local current_file = vim.fn.expand("%:p")
				local project_root = vim.fn.finddir(".git/..", current_file .. ";")
				if project_root == "" then
					project_root = vim.fn.getcwd()
				end
				local relative_path = vim.fn.fnamemodify(current_file, ":p:s?" .. project_root .. "/??")
				local module_path = relative_path:gsub("/", "."):gsub("%.py$", "")
				local cmd = string.format("cd %s && python -m %s", project_root, module_path)
				vim.cmd("FloatermNew --autoclose=0 " .. cmd)
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function()
					vim.keymap.set("n", "<F5>", function()
						vim.cmd("w")
						run_python_module()
					end, { buffer = true, silent = true })

					vim.keymap.set("i", "<F5>", function()
						vim.cmd("w")
						run_python_module()
					end, { buffer = true, silent = true })
				end,
			})

			local function run_go_file()
				local current_file = vim.fn.expand("%:p")
				local cmd = string.format("go run %s", current_file)
				vim.cmd("FloatermNew --autoclose=0 " .. cmd)
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = function()
					vim.keymap.set("n", "<F5>", function()
						vim.cmd("w")
						run_go_file()
					end, { buffer = true, silent = true })
				end,
			})
		end,
	},
}
