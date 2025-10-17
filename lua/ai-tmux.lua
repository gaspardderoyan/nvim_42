-- AI Tmux Toggle
-- Manages showing/hiding AI CLI tools in tmux panes with session preservation

local M = {}

-- Configuration
M.config = {
	tool_name = "opencode",
	parking_session = "ai-tools",
	split_ratio = 0.4,
}

-- Helper: Execute tmux command and return output
local function tmux_exec(cmd)
	local output = vim.fn.system("tmux " .. cmd)
	local exit_code = vim.v.shell_error
	return output, exit_code
end

-- Helper: Check if we're inside tmux
local function is_in_tmux()
	return vim.env.TMUX ~= nil
end

-- Helper: Ensure parking session exists
local function ensure_parking_session()
	local session = M.config.parking_session
	local output, code = tmux_exec("has-session -t " .. session .. " 2>/dev/null")
	if code ~= 0 then
		-- Create detached session
		tmux_exec("new-session -d -s " .. session)
	end
end

-- Find opencode pane by process name
function M.detect_opencode_pane()
	local output = tmux_exec('list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}"')

	for line in output:gmatch("[^\r\n]+") do
		if line:match(M.config.tool_name) then
			local pane_id = line:match("^(%S+)")
			return pane_id
		end
	end

	return nil
end

-- Check if pane is in current window
function M.is_pane_here(pane_id)
	if not pane_id then
		return false
	end

	-- Get current window coordinates
	local current = tmux_exec('display-message -p "#{session_name}:#{window_index}"')
	current = current:gsub("%s+$", "") -- trim whitespace

	-- Extract session:window from pane_id (format: session:window.pane)
	local pane_window = pane_id:match("^([^.]+)")

	return current == pane_window
end

-- Show opencode pane
function M.show_opencode()
	if not is_in_tmux() then
		vim.notify("Not running in tmux", vim.log.levels.WARN)
		return
	end

	local pane_id = M.detect_opencode_pane()

	if pane_id then
		-- Opencode is running somewhere
		if M.is_pane_here(pane_id) then
			-- Already visible, just focus it
			tmux_exec("select-pane -t " .. pane_id)
		else
			-- In parking session, join it to current window
			local current_window = tmux_exec('display-message -p "#{session_name}:#{window_index}"')
			current_window = current_window:gsub("%s+$", "")

			-- Calculate split width
			local term_width = vim.o.columns
			local ai_width = math.floor(term_width * M.config.split_ratio)

			-- Join pane from parking session as horizontal split on the right
			local _, code =
				tmux_exec(string.format("join-pane -h -l %d -s %s -t %s", ai_width, pane_id, current_window))

			if code == 0 then
				-- Focus the newly joined pane
				tmux_exec("select-pane -t " .. pane_id)
			else
				vim.notify("Failed to join pane", vim.log.levels.ERROR)
			end
		end
	else
		-- Opencode not running, start it manually in tmux
		vim.notify("Starting " .. M.config.tool_name .. "...", vim.log.levels.INFO)

		-- Calculate split width
		local term_width = vim.o.columns
		local ai_width = math.floor(term_width * M.config.split_ratio)

		-- Split window horizontally and run opencode
		local cmd = string.format(
			"split-window -h -l %d -c '#{pane_current_path}' '%s'",
			ai_width,
			M.config.tool_name
		)

		local _, code = tmux_exec(cmd)

		if code == 0 then
			vim.notify("Started " .. M.config.tool_name .. " in tmux pane", vim.log.levels.INFO)
		else
			vim.notify("Failed to start " .. M.config.tool_name, vim.log.levels.ERROR)
		end
	end
end

-- Hide opencode pane
function M.hide_opencode()
	if not is_in_tmux() then
		vim.notify("Not running in tmux", vim.log.levels.WARN)
		return
	end

	local pane_id = M.detect_opencode_pane()

	if not pane_id then
		vim.notify("No " .. M.config.tool_name .. " pane found", vim.log.levels.WARN)
		return
	end

	if not M.is_pane_here(pane_id) then
		vim.notify(M.config.tool_name .. " already hidden", vim.log.levels.INFO)
		return
	end

	-- Ensure parking session exists
	ensure_parking_session()

	-- Break pane to parking session
	local _, code = tmux_exec(string.format("break-pane -d -s %s -t %s:", pane_id, M.config.parking_session))

	if code == 0 then
		-- Focus back to nvim pane
		local nvim_panes = tmux_exec('list-panes -F "#{pane_id} #{pane_current_command}"')
		for line in nvim_panes:gmatch("[^\r\n]+") do
			if line:match("nvim") then
				local nvim_pane = line:match("^(%S+)")
				tmux_exec("select-pane -t " .. nvim_pane)
				break
			end
		end
	else
		vim.notify("Failed to hide " .. M.config.tool_name, vim.log.levels.ERROR)
	end
end

-- Main toggle function
function M.toggle()
	if not is_in_tmux() then
		vim.notify("Not running in tmux - falling back to Sidekick toggle", vim.log.levels.WARN)
		-- require("sidekick.cli").toggle({ name = M.config.tool_name, focus = false })
		return
	end

	local pane_id = M.detect_opencode_pane()

	if pane_id and M.is_pane_here(pane_id) then
		-- Pane is visible, hide it
		M.hide_opencode()
	else
		-- Pane is hidden or not running, show it
		M.show_opencode()
	end
end

return M
