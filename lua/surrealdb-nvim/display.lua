local config = require("lua.surrealdb-nvim.config")

local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local M = {}

local ns_id = api.nvim_create_namespace("surrealdb-nvim")
local ns_query_highlight_id = api.nvim_create_namespace("surrealdb-nvim-query-highlight")

return M
