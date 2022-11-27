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
