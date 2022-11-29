local query = require("surrealdb-nvim.query")
local utils = require("surrealdb-nvim.utils")
local config = require("surrealdb-nvim.config")
local default = require("surrealdb-nvim.default")
local display = require("surrealdb-nvim.display")

local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

---sets the filetype of the current buffer to sql.
local function set_filetype()
	cmd(":set filetype=sql")
end

---sets the keymaps from the config for the current buffer.
local function set_keymaps()
	if config.keymaps ~= nil then
		utils.set_keymaps(config.keymaps, 0)
	end
end

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

---command function to create a scratchpad.
---@param opts table
local function surreal_db_scratch(opts)
	local is_no_name_buf = utils.is_string_empty(api.nvim_buf_get_name(0))
	local not_loaded = fn.bufloaded(config.scratchpad.buf_name) == 0

	if not_loaded and not is_no_name_buf and config.scratchpad.split == "vertical" then
		cmd(":vsplit")
		cmd(":enew")
	end
	if not_loaded and not is_no_name_buf and config.scratchpad.split == "horizontal" then
		cmd(":split")
		cmd(":enew")
	end

	cmd(":setlocal buftype=nofile")
	cmd(":setlocal bufhidden=hide")
	cmd(":setlocal noswapfile")
	cmd(":set filetype=sql")
	cmd(":file " .. config.scratchpad.buf_name .. "")
	set_keymaps()
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

api.nvim_create_user_command("SurrealDBScratch", surreal_db_scratch, {})

local file_pattern = table.concat(config.file.extensions, ",")
local au_group = api.nvim_create_augroup("surrealdb.nvim", { clear = true })

local auto_cmds = {
	{ "BufRead", set_filetype },
	{ "BufRead", set_keymaps },
	{ "BufNewFile", set_filetype, "BufNewFile", set_keymaps },
}

for _, auto_cmd in ipairs(auto_cmds) do
	api.nvim_create_autocmd(auto_cmd[1], { group = au_group, pattern = file_pattern, callback = auto_cmd[2] })
end

api.nvim_create_autocmd(
	"InsertEnter",
	{ group = au_group, pattern = file_pattern, callback = display.clear_virtual_namespaces }
)

if config.file.run_on_safe then
	api.nvim_create_autocmd("BufWrite", {
		group = au_group,
		pattern = file_pattern,
		callback = function()
			cmd(":SurrealDBRun buf")
		end,
	})
end
