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
return M
