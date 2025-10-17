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

-- Helper: Ensure parking session exists with opencode in current dir
local function ensure_parking_session()
	local session = M.config.parking_session
	local output, code = tmux_exec("has-session -t " .. session .. " 2>/dev/null")
	if code ~= 0 then
		-- Create detached session
		tmux_exec("new-session -d -s " .. session)
	end

	-- Check if there's already an opencode pane in the session with current dir
	local current_dir = vim.fn.getcwd()
	local output =
		tmux_exec(string.format('list-panes -t %s -F "#{pane_current_command} #{pane_current_path}"', session))
	local has_matching_pane = false
	for line in output:gmatch("[^\r\n]+") do
		local cmd, path = line:match("^(%S+)%s+(.+)$")
		if cmd == M.config.tool_name and path == current_dir then
			has_matching_pane = true
			break
		end
	end
	if not has_matching_pane then
		-- Start opencode in background in the session
		tmux_exec(string.format("new-window -t %s -c '%s' -d '%s'", session, current_dir, M.config.tool_name))
	end
end

-- Find opencode pane by process name and current directory
function M.detect_opencode_pane()
	local output = tmux_exec(
		'list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command} #{pane_current_path}"'
	)

	for line in output:gmatch("[^\r\n]+") do
		local pane_id, cmd, path = line:match("^(%S+)%s+(%S+)%s+(.+)$")
		if cmd == M.config.tool_name and path == vim.fn.getcwd() then
			return pane_id
		end
	end

	return nil
end

-- Find suitable parking pane in ai-tools session with same directory
function M.find_suitable_parking_pane()
	local current_dir = vim.fn.getcwd()
	local output = tmux_exec(
		string.format(
			'list-panes -t %s -F "#{window_index}.#{pane_index} #{pane_current_command} #{pane_current_path}"',
			M.config.parking_session
		)
	)
	for line in output:gmatch("[^\r\n]+") do
		local pane_id, cmd, path = line:match("^(%S+)%s+(%S+)%s+(.+)$")
		if cmd == M.config.tool_name and path == current_dir then
			return M.config.parking_session .. ":" .. pane_id
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
		-- Ensure parking session has opencode in current dir
		ensure_parking_session()
		local parking_pane = M.find_suitable_parking_pane()
		if parking_pane then
			-- Attach via Sidekick and join the pane
			local State = require("sidekick.cli.state")
			local sessions = State.get({ name = M.config.tool_name, started = true })
			if #sessions > 0 then
				State.attach(sessions[1], { show = false, focus = false })
				-- Join the pane to current window
				local current_window = tmux_exec('display-message -p "#{session_name}:#{window_index}"')
				current_window = current_window:gsub("%s+$", "")
				local term_width = vim.o.columns
				local ai_width = math.floor(term_width * M.config.split_ratio)
				local _, code =
					tmux_exec(string.format("join-pane -h -l %d -s %s -t %s", ai_width, parking_pane, current_window))
				if code == 0 then
					tmux_exec("select-pane -t " .. parking_pane)
				else
					vim.notify("Failed to join pane", vim.log.levels.ERROR)
				end
			else
				vim.notify("No session found", vim.log.levels.ERROR)
			end
		else
			-- Start manually in tmux
			vim.notify("Starting " .. M.config.tool_name .. "...", vim.log.levels.INFO)
			local term_width = vim.o.columns
			local ai_width = math.floor(term_width * M.config.split_ratio)
			local cmd =
				string.format("split-window -h -l %d -c '#{pane_current_path}' '%s'", ai_width, M.config.tool_name)
			local _, code = tmux_exec(cmd)
			if code == 0 then
				vim.notify("Started " .. M.config.tool_name .. " in tmux pane", vim.log.levels.INFO)
			else
				vim.notify("Failed to start " .. M.config.tool_name, vim.log.levels.ERROR)
			end
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
		vim.notify("Not running in tmux", vim.log.levels.WARN)
		return
	end

	local State = require("sidekick.cli.state")
	local pane_id = M.detect_opencode_pane()

	-- Check for existing session with filters (running, external/tmux)
	local sessions = State.get({
		name = M.config.tool_name,
		started = true,
		external = true, -- Prioritize tmux/background sessions
	})

	if pane_id and M.is_pane_here(pane_id) then
		-- Visible: hide to parking session
		M.hide_opencode()
	else
		-- Ensure parking session and check for suitable pane
		ensure_parking_session()
		local parking_pane = M.find_suitable_parking_pane()
		if parking_pane then
			-- Attach via Sidekick and join
			local sessions = State.get({ name = M.config.tool_name, started = true })
			if #sessions > 0 then
				State.attach(sessions[1], { show = false, focus = false })
				local pane_id = M.detect_opencode_pane()
				if pane_id and not M.is_pane_here(pane_id) then
					local current_window = tmux_exec('display-message -p "#{session_name}:#{window_index}"')
					current_window = current_window:gsub("%s+$", "")
					local term_width = vim.o.columns
					local ai_width = math.floor(term_width * M.config.split_ratio)
					local _, code =
						tmux_exec(string.format("join-pane -h -l %d -s %s -t %s", ai_width, pane_id, current_window))
					if code == 0 then
						tmux_exec("select-pane -t " .. pane_id)
					end
				elseif pane_id then
					tmux_exec("select-pane -t " .. pane_id)
				end
			else
				M.show_opencode()
			end
		else
			M.show_opencode()
		end
	end
end

return M
