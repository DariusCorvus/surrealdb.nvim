local utils = require("lua.surrealdb-nvim.utils")
local display = require("lua.surrealdb-nvim.display")
local config = require("lua.surrealdb-nvim.config")

local api = vim.api
local fn = vim.fn
local M = {}

---returns the composed command with the passed query and connection.
---@param query string
---@param connection table|nil
---@return string
local function compose_request(query, connection)
	if connection == nil then
		connection = config.connection
	end
	return string.format(
		'curl -u %s:%s -d "%s" --header "Accept: application/json" --header "NS: %s" --header "DB: %s" %s',
		connection.user,
		connection.pass,
		query,
		connection.ns,
		connection.db,
		connection.host
	)
end

---executes the passed command
---@param command string
---@return table
local function fetch(command)
	local json = {}
	local stderr = ""
	local job_id = fn.jobstart(command, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data, _)
			table.insert(json, fn.join(data))
		end,
		on_stderr = function(_, data, _)
			stderr = stderr .. fn.join(data)
		end,
	})

	fn.jobwait({ job_id })
	return json
end

---executes the passed query on the passed connection.
---@param query string
---@param connection table|nil
local function execute(query, connection)
	local call_fn = compose_request(query, connection)
	local output = fetch(call_fn)
	display.buffer_output(output)
end

---executes the content of the passed buffer.
---@param bufnr? integer
function M.execute_buffer(bufnr)
	local buffer_content = utils.get_buffer_content(bufnr)
	execute(buffer_content, nil)
end

---executes the line under the cursor.
function M.execute_line()
	local line = api.nvim_get_current_line()
	execute(line, nil)
	display.highlight_line(api.nvim_win_get_cursor(0)[1])
end

---executes the visual selection from the passed buffer.
---@param bufnr? integer
function M.execute_selection(bufnr)
	local text = utils.get_visual_selection(bufnr)
	local sr, sc, er, ec = utils.get_visual_selection_range()
	execute(text, nil)
	display.highlight_query(sr, sc, er, ec)
end

return M
