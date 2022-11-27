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
