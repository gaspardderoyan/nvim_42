-- AI Tmux Toggle
-- Manages showing/hiding AI CLI tools in tmux panes with session preservation

local M = {}

-- Configuration
M.config = {
	tool_name = "opencode",
	parking_session = "ai-tools",
	split_ratio = 0.4,
}

M.pane_cache = {}

--- Execute tmux command and return output while logging failures
--- @param cmd string The tmux command to execute
--- @param opts? table Options table with allow_fail boolean
--- @return string output The command output
--- @return number exit_code The exit code from the command
local function tmux_exec(cmd, opts)
	opts = opts or {}
	local output = vim.fn.system("tmux " .. cmd)
	local exit_code = vim.v.shell_error
	if exit_code ~= 0 and not opts.allow_fail then
		local message = string.format("tmux %s failed with exit code %d", cmd, exit_code)
		if output and output ~= "" then
			message = message .. ": " .. output:gsub("%s+$", "")
		end
		vim.notify(message, vim.log.levels.ERROR)
	end
	return output, exit_code
end

--- Check if running inside a tmux session
--- @return boolean True if inside tmux, false otherwise
local function is_in_tmux()
	return vim.env.TMUX ~= nil
end

--- Escape a value for safe shell usage
--- @param value string The value to escape
--- @return string The escaped value
local function shell_escape(value)
	return vim.fn.shellescape(value or "")
end

--- Remove trailing whitespace from a string
--- @param value string The value to trim
--- @return string The trimmed value
local function trim(value)
	return (value or ""):gsub("%s+$", "")
end

--- Normalize a directory path to its absolute form
--- @param dir string The directory path to normalize
--- @return string The normalized directory path
local function normalize_dir(dir)
	if not dir or dir == "" then
		return dir
	end
	local ok, resolved = pcall(vim.loop.fs_realpath, dir)
	local path = ok and resolved or vim.fn.fnamemodify(dir, ":p")
	if path and #path > 1 and path:sub(-1) == "/" then
		path = path:sub(1, -2)
	end
	return path
end

--- Get the current working directory
--- @return string The current working directory
local function get_current_dir()
	return normalize_dir(vim.fn.getcwd())
end

--- Check if a tmux pane exists by its ID
--- @param pane_id string The pane ID to check
--- @return boolean True if pane exists, false otherwise
local function pane_exists(pane_id)
	if not pane_id then
		return false
	end
	local _, code = tmux_exec(string.format('display-message -p -t %s "#{pane_id}"', pane_id), { allow_fail = true })
	return code == 0
end

--- Get the current tmux session name
--- @return string|nil The session name or nil if not in tmux
local function get_current_session()
	local output, code = tmux_exec('display-message -p "#{session_name}"', { allow_fail = true })
	if code ~= 0 then
		return nil
	end
	return trim(output)
end

local PANE_FORMAT =
	"#{pane_id}\t#{session_name}\t#{pane_start_command}\t#{pane_current_command}\t#{pane_title}\t#{pane_current_path}"

--- Check if a command matches the configured tool
--- @param cmd string The command to check
--- @return boolean True if command matches tool, false otherwise
local function command_matches_tool(cmd)
	if not cmd or cmd == "" then
		return false
	end
	if cmd == M.config.tool_name then
		return true
	end
	local base = cmd:match("([^/]+)$")
	return base == M.config.tool_name
end

--- Parse a tmux pane information line
--- @param line string The line to parse from tmux list-panes output
--- @return table|nil A table with pane metadata or nil if parsing fails
local function parse_pane_line(line)
	if not line or line == "" then
		return nil
	end
	local fields = vim.split(line, "\t", { plain = true })
	if #fields < 6 then
		return nil
	end
	local meta = {
		id = fields[1],
		session = fields[2],
		start_cmd = fields[3],
		current_cmd = fields[4],
		title = fields[5],
		path = normalize_dir(fields[6]) or fields[6],
	}
	return meta
end

--- Check if a pane metadata matches the configured tool
--- @param meta table The pane metadata table
--- @return boolean True if pane matches tool, false otherwise
local function pane_matches_tool(meta)
	if not meta then
		return false
	end
	if command_matches_tool(meta.start_cmd) or command_matches_tool(meta.current_cmd) then
		return true
	end
	return trim(meta.title) == M.config.tool_name
end

--- Get the window identifier for a given pane
--- @param pane_id string The pane ID
--- @return string|nil The window identifier (session:window_index) or nil
local function get_pane_window(pane_id)
	local output, code = tmux_exec(
		string.format('display-message -p -t %s "#{session_name}:#{window_index}"', pane_id),
		{ allow_fail = true }
	)
	if code ~= 0 then
		return nil
	end
	return trim(output)
end

--- Get the current window identifier
--- @return string|nil The window identifier (session:window_index) or nil
local function get_current_window()
	local output, code = tmux_exec('display-message -p "#{session_name}:#{window_index}"', { allow_fail = true })
	if code ~= 0 then
		return nil
	end
	return trim(output)
end

--- Cache a pane ID for a given directory
--- @param dir string The directory path
--- @param pane_id string The pane ID to cache
--- @param session string The session name
local function remember_pane(dir, pane_id, session)
	if not dir or dir == "" or not pane_id or pane_id == "" then
		return
	end
	dir = normalize_dir(dir) or dir
	if not pane_exists(pane_id) then
		M.pane_cache[dir] = nil
		return
	end
	M.pane_cache[dir] = {
		id = pane_id,
		session = session,
	}
end

--- Ensure the parking session exists and return a suitable pane for it
--- @return string|nil The pane ID from parking session or nil if creation failed
local function ensure_parking_session()
	local session = M.config.parking_session
	local _, code = tmux_exec("has-session -t " .. session, { allow_fail = true })
	if code ~= 0 then
		tmux_exec("new-session -d -s " .. session)
		tmux_exec("set-option -t " .. session .. " base-index 950")
	end

	local current_dir = get_current_dir()
	local cached = current_dir and M.pane_cache[current_dir]
	if cached and pane_exists(cached.id) then
		return cached.id
	end

	local output = tmux_exec(string.format("list-panes -t %s -F %s", shell_escape(session), shell_escape(PANE_FORMAT)))
	for line in output:gmatch("[^\r\n]+") do
		local meta = parse_pane_line(line)
		if meta and pane_matches_tool(meta) and meta.path == current_dir then
			remember_pane(current_dir, meta.id, meta.session)
			return meta.id
		end
	end

	local create_cmd = string.format(
		"new-window -P -d -F %s -t %s -c %s %s",
		shell_escape("#{pane_id}"),
		shell_escape(session),
		shell_escape(current_dir),
		shell_escape(M.config.tool_name)
	)
	local pane_id, new_code = tmux_exec(create_cmd)
	if new_code == 0 then
		remember_pane(current_dir, trim(pane_id), session)
		return trim(pane_id)
	end
end

--- Find opencode pane by process name and current directory
--- @return string|nil The pane ID if found, nil otherwise
function M.detect_opencode_pane()
	local current_dir = get_current_dir()
	local cached = current_dir and M.pane_cache[current_dir]
	if cached and pane_exists(cached.id) then
		return cached.id
	end
	if current_dir then
		M.pane_cache[current_dir] = nil
	end

	local output = tmux_exec(string.format("list-panes -a -F %s", shell_escape(PANE_FORMAT)))
	for line in output:gmatch("[^\r\n]+") do
		local meta = parse_pane_line(line)
		if meta and pane_matches_tool(meta) and meta.path == current_dir then
			remember_pane(current_dir, meta.id, meta.session)
			return meta.id
		end
	end

	return nil
end

--- Find suitable parking pane in ai-tools session with same directory
--- @return string|nil The pane ID if found, nil otherwise
function M.find_suitable_parking_pane()
	local current_dir = get_current_dir()
	local output = tmux_exec(
		string.format("list-panes -t %s -F %s", shell_escape(M.config.parking_session), shell_escape(PANE_FORMAT))
	)
	for line in output:gmatch("[^\r\n]+") do
		local meta = parse_pane_line(line)
		if meta and pane_matches_tool(meta) and meta.path == current_dir then
			remember_pane(current_dir, meta.id, meta.session)
			return meta.id
		end
	end
	return nil
end

--- Check if pane is in the current window
--- @param pane_id string The pane ID to check
--- @return boolean True if pane is in current window, false otherwise
function M.is_pane_here(pane_id)
	if not pane_exists(pane_id) then
		return false
	end

	local current = get_current_window()
	if not current then
		return false
	end

	local pane_window = get_pane_window(pane_id)

	return pane_window == current
end

--- Join a pane into the current window
--- @param pane_id string The pane ID to join
--- @return boolean True if successful, false otherwise
local function join_pane_into_current(pane_id)
	if not pane_exists(pane_id) then
		return false
	end

	local current_window = get_current_window()
	if not current_window then
		return false
	end

	local term_width = vim.o.columns
	local ai_width = math.floor(term_width * M.config.split_ratio)
	local _, code = tmux_exec(
		string.format("join-pane -h -l %d -s %s -t %s", ai_width, pane_id, current_window),
		{ allow_fail = true }
	)
	if code == 0 then
		tmux_exec("select-pane -t " .. pane_id)
		return true
	end

	return false
end

--- Focus the first nvim pane found
local function focus_first_nvim_pane()
	local nvim_panes = tmux_exec('list-panes -F "#{pane_id} #{pane_current_command}"')
	for line in nvim_panes:gmatch("[^\r\n]+") do
		if line:match("nvim") then
			local pane_id = line:match("^(%S+)")
			if pane_id then
				tmux_exec("select-pane -t " .. pane_id)
				break
			end
		end
	end
end

--- Start the tool in a horizontal split in the current window
--- @param dir string The directory to start the tool in
--- @return boolean True if successful, false otherwise
local function start_tool_in_split(dir)
	local term_width = vim.o.columns
	local ai_width = math.floor(term_width * M.config.split_ratio)
	local cmd = string.format(
		"split-window -h -l %d -P -F %s -c %s %s",
		ai_width,
		shell_escape("#{pane_id}"),
		shell_escape(dir),
		shell_escape(M.config.tool_name)
	)
	local pane_id, code = tmux_exec(cmd)
	if code == 0 then
		remember_pane(dir, trim(pane_id), get_current_session())
		vim.notify("Started " .. M.config.tool_name .. " in tmux pane", vim.log.levels.INFO)
		return true
	end

	vim.notify("Failed to start " .. M.config.tool_name, vim.log.levels.ERROR)
	return false
end

--- Show the opencode pane, creating or restoring it as needed
function M.show_opencode()
	if not is_in_tmux() then
		vim.notify("Not running in tmux", vim.log.levels.WARN)
		return
	end

	local dir = get_current_dir()
	local pane_id = M.detect_opencode_pane()

	if pane_id then
		if M.is_pane_here(pane_id) then
			tmux_exec("select-pane -t " .. pane_id)
			return
		end
		if join_pane_into_current(pane_id) then
			remember_pane(dir, pane_id, get_current_session())
			return
		end
		M.pane_cache[dir] = nil
	end

	ensure_parking_session()
	local parking_pane = M.find_suitable_parking_pane()
	if parking_pane then
		local pane_to_join = parking_pane
		local State = require("sidekick.cli.state")
		local sessions = State.get({ name = M.config.tool_name, started = true })
		if #sessions > 0 then
			State.attach(sessions[1], { show = false, focus = false })
			local refreshed = M.detect_opencode_pane()
			if refreshed and pane_exists(refreshed) then
				pane_to_join = refreshed
			end
		else
			vim.notify("No session found", vim.log.levels.ERROR)
		end
		if join_pane_into_current(pane_to_join) then
			remember_pane(dir, pane_to_join, get_current_session())
			return
		end
	end

	start_tool_in_split(dir)
end

--- Hide the opencode pane by moving it to the parking session
function M.hide_opencode()
	if not is_in_tmux() then
		vim.notify("Not running in tmux", vim.log.levels.WARN)
		return
	end

	local dir = get_current_dir()
	local pane_id = M.detect_opencode_pane()

	if not pane_id then
		vim.notify("No " .. M.config.tool_name .. " pane found", vim.log.levels.WARN)
		return
	end

	if not M.is_pane_here(pane_id) then
		vim.notify(M.config.tool_name .. " already hidden", vim.log.levels.INFO)
		return
	end

	ensure_parking_session()
	local _, code = tmux_exec(string.format("break-pane -d -s %s -t %s:", pane_id, M.config.parking_session))
	if code == 0 then
		remember_pane(dir, pane_id, M.config.parking_session)
		focus_first_nvim_pane()
	else
		vim.notify("Failed to hide " .. M.config.tool_name, vim.log.levels.ERROR)
	end
end

--- Toggle the visibility of the opencode pane
function M.toggle()
	if not is_in_tmux() then
		vim.notify("Not running in tmux", vim.log.levels.WARN)
		return
	end

	local pane_id = M.detect_opencode_pane()
	if pane_id and M.is_pane_here(pane_id) then
		M.hide_opencode()
		return
	end

	ensure_parking_session()
	local parking_pane = M.find_suitable_parking_pane()
	if parking_pane then
		local pane_to_join = parking_pane
		local State = require("sidekick.cli.state")
		local sessions = State.get({
			name = M.config.tool_name,
			started = true,
			external = true,
		})
		if #sessions > 0 then
			State.attach(sessions[1], { show = false, focus = false })
			local refreshed = M.detect_opencode_pane()
			if refreshed and pane_exists(refreshed) then
				pane_to_join = refreshed
			end
		end
		if not M.is_pane_here(pane_to_join) then
			if join_pane_into_current(pane_to_join) then
				remember_pane(get_current_dir(), pane_to_join, get_current_session())
				return
			end
		else
			tmux_exec("select-pane -t " .. pane_to_join)
			return
		end
	end

	M.show_opencode()
end

return M
