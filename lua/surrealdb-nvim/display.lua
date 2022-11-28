local config = require("surrealdb-nvim.config")

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

---draws a virtual text based on the passed parameter success.
---@param success boolean
local function draw_virtual_text(success)
	api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
	local status = "fail"
	if success then
		status = "success"
	end
	local row = api.nvim_win_get_cursor(0)[1]
	local virt_text = config.virtual_texts[status]
	api.nvim_buf_set_extmark(0, ns_id, row - 1, 0, { virt_text = { virt_text } })
end

---highlights text in the given buffer by the passed indices.
---@param start_row integer
---@param start_col integer
---@param end_row integer
---@param end_col integer
function M.highlight_query(start_row, start_col, end_row, end_col)
	for i = start_row, end_row + 1 do
		local col_start = 0
		local col_end = -1
		if i == start_row then
			col_start = start_col - 1
		end
		if i == end_row then
			col_end = end_col
		end
		api.nvim_buf_add_highlight(0, ns_query_highlight_id, "Visual", i - 1, col_start, col_end)
	end
end

function M.highlight_line(line)
	api.nvim_buf_add_highlight(0, ns_query_highlight_id, "Visual", line - 1, 0, -1)
end

---returns a boolean based on the success of the surrealdb query.
---@return boolean
local function is_success()
	local line = api.nvim_buf_get_lines(0, 3, 4, false)
	return string.match(line[1], '"status": "OK"')
end

---removes the virtual texts from the current buffer
function M.clear_virtual_namespaces()
	api.nvim_buf_clear_namespace(0, ns_query_highlight_id, 0, -1)
	api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
end

---displays the passed content in a buffer
---@param content table
function M.buffer_output(content)
	api.nvim_buf_clear_namespace(0, ns_query_highlight_id, 0, -1)
	local win_tmp = api.nvim_get_current_win()
	if fn.bufloaded(config.output.buf_name) == 0 then
		if config.output.split == "vertical" then
			init_buffer(":vsplit")
		end
		if config.output.split == "horizontal" then
			init_buffer(":split")
		end
	end

	local buf = fn.bufnr(config.output.buf_name)
	local win = fn.win_findbuf(buf)[1]

	api.nvim_set_current_win(win)
	cmd(":%d")
	api.nvim_buf_set_text(buf, 0, 0, 0, 0, content)
	cmd(config.output.format_cmd)
	local success = is_success()
	api.nvim_set_current_win(win_tmp)
	draw_virtual_text(success)
end

return M
