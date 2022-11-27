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
return M
