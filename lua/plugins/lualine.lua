return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		-- Use rose-pine theme directly instead of auto
		local rose_pine_theme = require("lualine.themes.rose-pine")

		local colors = require("rose-pine.palette")

		local function separator()
			return {
				function()
					return "│"
				end,
				color = { fg = colors.overlay, bg = "NONE", gui = "bold" },
				padding = { left = 0, right = 0 },
			}
		end

		local function custom_branch()
			local gitsigns = vim.b.gitsigns_head
			local fugitive = vim.fn.exists("*FugitiveHead") == 1 and vim.fn.FugitiveHead() or ""
			local branch = gitsigns or fugitive
			if branch == nil or branch == "" then
				return ""
			else
				return " " .. branch
			end
		end

		local modes = { "normal", "insert", "visual", "replace", "command", "inactive", "terminal" }
		for _, mode in ipairs(modes) do
			if rose_pine_theme[mode] then
				if rose_pine_theme[mode].a then
					rose_pine_theme[mode].a.bg = "NONE"
				end
				if rose_pine_theme[mode].b then
					rose_pine_theme[mode].b.bg = "NONE"
				end
				if rose_pine_theme[mode].c then
					rose_pine_theme[mode].c.bg = "NONE"
				end
			end
		end

		if not rose_pine_theme.terminal then
			rose_pine_theme.terminal = vim.deepcopy(rose_pine_theme.normal)
			rose_pine_theme.terminal.a.bg = "NONE"
			rose_pine_theme.terminal.b.bg = "NONE"
			rose_pine_theme.terminal.c.bg = "NONE"
		end

		opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
			theme = rose_pine_theme,
			component_separators = "",
			section_separators = "",
			globalstatus = true,
			disabled_filetypes = { statusline = { "snacks_dashboard" } },
		})

		opts.sections = {
			lualine_a = {
				{
					"mode",
					fmt = function(str)
						return str:sub(1, 1)
					end,
					padding = { left = 1, right = 1 },
				},
			},
			lualine_b = {
				{
					custom_branch,
					color = { fg = colors.foam, bg = "none" },
					padding = { left = 1, right = 1 },
				},
				{
					"diff",
					colored = true,
					diff_color = {
						added = { fg = colors.foam, bg = "none", gui = "bold" },
						modified = { fg = colors.gold, bg = "none", gui = "bold" },
						removed = { fg = colors.love, bg = "none", gui = "bold" },
					},
					source = nil,
					padding = { left = 0, right = 1 },
				},
				separator(),
			},
			lualine_c = {
				{
					"filename",
					file_status = true,
					path = 4,
					shorting_target = 20,
					symbols = {
						modified = "[+]",
						readonly = "[-]",
						unnamed = "[?]",
						newfile = "[!]",
					},
					color = { fg = colors.iris, bg = "none" },
					padding = { left = 1, right = 1 },
				},
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					sections = { "error", "warn", "info", "hint" },
					diagnostics_color = {
						error = function()
							local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
							return { fg = (count == 0) and colors.foam or colors.love, bg = "none", gui = "bold" }
						end,
						warn = function()
							local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
							return { fg = (count == 0) and colors.foam or colors.gold, bg = "none", gui = "bold" }
						end,
						info = function()
							local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
							return { fg = (count == 0) and colors.foam or colors.iris, bg = "none", gui = "bold" }
						end,
						hint = function()
							local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
							return { fg = (count == 0) and colors.foam or colors.pine, bg = "none", gui = "bold" }
						end,
					},
					symbols = {
						error = "󰅚 ",
						warn = "󰀪 ",
						info = "󰋽 ",
						hint = "󰌶 ",
					},
					colored = true,
					update_in_insert = false,
					always_visible = false,
					padding = { left = 0, right = 1 },
				},
			},
			lualine_x = {
				{
					function()
						local bufnr_list = vim.fn.getbufinfo({ buflisted = 1 })
						local total = #bufnr_list
						local current_bufnr = vim.api.nvim_get_current_buf()
						local current_index = 0

						for i, buf in ipairs(bufnr_list) do
							if buf.bufnr == current_bufnr then
								current_index = i
								break
							end
						end

						return string.format(" %d/%d", current_index, total)
					end,
					color = { fg = colors.gold, bg = "none" },
					padding = { left = 1, right = 1 },
				},
			},
			lualine_y = {
				separator(),
				{
					"filetype",
					icon_only = true,
					colored = false,
					color = { fg = colors.iris, bg = "none" },
					padding = { left = 1, right = 1 },
				},
			},
			lualine_z = {
				separator(),
				{
					"location",
					color = { fg = colors.love, bg = "none" },
					padding = { left = 1, right = 1 },
				},
			},
		}

		return opts
	end,
}
