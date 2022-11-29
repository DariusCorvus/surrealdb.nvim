local M = {}

local split_direction = { VERTICAL = "vertical", HORIZONTAL = "horizontal" }

M.connection_mapping = {
	host = "localhost:8000/sql",
	ns = "test",
	db = "test",
	user = "root",
	pass = "root",
}

M.connection = M.connection_mapping

M.file = {
	extensions = { "*.sdb", "*.surql", "*.sql" },
	run_on_safe = false,
	type = "sql",
}

M.keymaps = {
	{ "n", "<leader>5", ":SurrealDBRun buf<CR>" },
	{ "n", "<leader>5l", ":SurrealDBRun ln<CR>" },
	{ "v", "<leader>5", ":<C-U>SurrealDBRun sel<CR>" },
}

M.virtual_texts = {
	success = { "", "GreenSign" },
	fail = { "", "RedSign" },
}

M.output = {
	buf_name = "SurrealDB Response",
	split = split_direction.VERTICAL,
	format_cmd = ":%!jq --indent 2",
}

M.scratchpad = {
	buf_name = "SurrealDB Scratch",
	split = split_direction.HORIZONTAL,
}

return M
