local query = require("lua.surrealdb-nvim.query")
local utils = require("lua.surrealdb-nvim.utils")
local config = require("lua.surrealdb-nvim.config")
local default = require("lua.surrealdb-nvim.default")
local display = require("lua.surrealdb-nvim.display")

local api = vim.api
local cmd = vim.cmd

---command function to update certain connection variables.
---@param opts table
local function surreal_db_connection(opts)
	local args = opts["args"]
	if args == "" or args == "env" then
		for key, value in pairs(utils.load_connection_from_env()) do
			config.update_connection(key, value)
		end
		return
	end

	if args == "user" or args == "pass" or args == "host" or args == "ns" or args == "db" then
		config.connection_input(args)
		return
	end

	if args == "all" then
		for key, _ in pairs(default.connection_mapping) do
			config.connection_input(key)
		end
		return
	end
end

---command function to execute buffer, selection or line.
---@param opts table
local function surreal_db_run(opts)
	local args = opts["args"]
	if args == "" or args == "buf" or args == "buffer" then
		query.execute_buffer()
		return
	end
	if args == "sel" or args == "selection" then
		query.execute_selection()
		return
	end
	if args == "ln" or args == "line" then
		query.execute_line()
		return
	end
end

api.nvim_create_user_command("SurrealDBConnection", surreal_db_connection, {
	nargs = "?",
	complete = function(_, _, _)
		return { "env", "user", "pass", "host", "ns", "db", "all" }
	end,
})

api.nvim_create_user_command("SurrealDBRun", surreal_db_run, {
	nargs = "?",
	complete = function(_, _, _)
		return { "buf", "buffer", "sel", "selection", "ln", "line" }
	end,
})

