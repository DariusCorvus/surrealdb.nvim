local config = require("lua.surrealdb-nvim.config")

local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local M = {}

local ns_id = api.nvim_create_namespace("surrealdb-nvim")
local ns_query_highlight_id = api.nvim_create_namespace("surrealdb-nvim-query-highlight")

---initializes the current buffer for the surrealdb response.
---@param split_cmd string vim command for the split direction
local function init_buffer(split_cmd)
	cmd(split_cmd)
	cmd(":enew")
	cmd(":setlocal buftype=nofile")
	cmd(":setlocal bufhidden=hide")
	cmd(":setlocal noswapfile")
	cmd(":setlocal nonumber norelativenumber scl=no")
	cmd(":set filetype=json")
	cmd(":file " .. config.output.buf_name .. "")
end

return M
