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
---returns true if string is empty, false otherwise.
---@param s string
---@return boolean
function M.is_string_empty(s)
	return s == nil or s == ""
end

return M
