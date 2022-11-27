local utils = require("surrealdb-nvim.utils")
local default = require("surrealdb-nvim.default")
local fn = vim.fn

local M = default

function M.update_config(opts)
	M = utils.recursive_table_update(M, opts)
end

function M.update_connection(key, value)
	M.connection[key] = value
end

function M.connection_input(key)
	local input = fn.input
	if key == "pass" then
		input = fn.inputsecret
	end

	local result = input(key .. ": ")
	if utils.is_string_empty(result) then
		result = default
	end
	M.update_connection(key, result)
end

return M
