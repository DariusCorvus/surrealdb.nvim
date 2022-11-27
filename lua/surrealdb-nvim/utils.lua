table.unpack = table.unpack or unpack
local keymap_generic_opts = { noremap = true, silent = true }
local api = vim.api
local fn = vim.fn

local M = {}

---sets keymaps out of a table global or for the passed buf
---@param keymaps table
---@param buf? number if buf number is passed, keymaps only set for the passed buf
function M.set_keymaps(keymaps, buf)
	for _, keymap in ipairs(keymaps) do
		if buf ~= nil then
			api.nvim_buf_set_keymap(buf, keymap[1], keymap[2], keymap[3], keymap_generic_opts)
		else
			api.nvim_set_keymap(keymap[1], keymap[2], keymap[3], keymap_generic_opts)
		end
	end
end

---recursivly updates the passed destination table with the source table, over every depth of nested tables.
---@param dest table
---@param src table
---@return table
function M.recursive_table_update(dest, src)
	for key, value in pairs(src) do
		if type(value) == "table" then
			dest[key] = M.recursive_table_update(dest, value)
		else
			dest[key] = value
		end
	end
	return dest
end

---returns the buffer content as a string.
---@param buf? integer
---@return string
function M.get_buffer_content(buf)
	local buffer = buf or 0
	local lines = api.nvim_buf_get_lines(buffer, 0, -1, false)
	return table.concat(lines, " ")
end

---splits a string into a table through a passed pattern.
---@param str string
---@param pattern string
---@return table
function M.split_string(str, pattern)
	local t = {}
	for s in str:gmatch(pattern) do
		table.insert(t, s)
	end
	return t
end

-- got this helper function from this repository.
-- https://github.com/theHamsta/nvim-treesitter/blob/a5f2970d7af947c066fb65aef2220335008242b7/lua/nvim-treesitter/incremental_selection.lua#L22-L30
---returns the selection indizes.
---@return integer start_row
---@return integer start_column
---@return integer end_row
---@return integer end_column
function M.get_visual_selection_range()
	local _, csrow, cscol, _ = table.unpack(fn.getpos("'<"))
	local _, cerow, cecol, _ = table.unpack(fn.getpos("'>"))
	if csrow < cerow or (csrow == cerow and cscol <= cecol) then
		return csrow, cscol, cerow, cecol
	else
		return cerow, cecol, csrow, cscol
	end
end

---returns the visual selection as a string.
---@param buf? integer
---@return string
function M.get_visual_selection(buf)
	local buffer = buf or 0
	local start_row, start_col, end_row, end_col = M.get_visual_selection_range()
	local range = api.nvim_buf_get_text(buffer, start_row - 1, start_col - 1, end_row - 1, end_col - 1, {})
	return table.concat(range, " ")
end

---reads the environment variables for the surrealdb server and append /sql to the bind variable.
---@return string
---@return string
---@return string
local function get_connection_env()
	local bind = fn.getenv("BIND")
	if type(bind) == "string" then
		bind = bind:gsub("0.0.0.0", "localhost:8000")
	else
		bind = "localhost:8000"
	end
	bind = bind .. "/sql"

	local user = fn.getenv("USER")
	if type(user) ~= "string" then
		user = "root"
	end
	local pass = fn.getenv("PASS")
	if type(pass) ~= "string" then
		pass = "root"
	end

	return bind, user, pass
end

---returns the credentials from the environment variables: BIND, USER, PASS.
---if a environment variable is not found, the default value for that variable will be returned.
---@return table
function M.load_connection_from_env()
	local host, user, pass = get_connection_env()
	return { host = host, user = user, pass = pass }
end

---returns true if string is empty, false otherwise.
---@param s string
---@return boolean
function M.is_string_empty(s)
	return s == nil or s == ""
end

return M
