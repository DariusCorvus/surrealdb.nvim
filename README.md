# surrealdb.nvim
<p align="center">
	<img src="https://raw.githubusercontent.com/DariusCorvus/DariusCorvus/main/assets/surrealdb-nvim-256.png"/>
</p>

---

<p align="center">
	<img src="https://raw.githubusercontent.com/DariusCorvus/DariusCorvus/main/assets/surrealdb-nvim-showcase-1.png"/>
</p>

## Requirements

- [curl](https://curl.se)
- [jq](https://stedolan.github.io/jq/)

The binarys `curl` and `jq` need to be on path.

## Features
- automatic buffer keymaps on buffers with the extensions `*.sql`, `*.surql` or `*.sdb`
- automatic syntac highlighting on buffers with the extensions `*.sql`, `*.surql` or `*.sdb`
- execute the current buffer
	- Hit `<SPACE>5` in normal mode or execute `:SurrealDBRun buf` or `:SurrealDBRun buffer`
- execute the line under the cursor
	- Hit `<SPACE>5l` in normal mode or execute  `:SurrealDBRun ln` or ``:SurrealDBRun line`
- execute the visual selected text of the current buffer
	- Hit `<SPACE>5` in visual mode.
- highlights the last executed query
- shows a virtual status text at the right of the executed query
- opens a buffer with the surrealdb response and reuses this buffer for all executed querys
- possibility to create a scratchpad to write your querys on the fly
- displays the response formatted thanks to jq

>[!note] 
>The hotkeys are only available by default in buffers with the extensions `*.sql`, `*.surql` or `*.sdb` 
>look into the `config` section to learn about the possible configurations for this plugin.

# Commands
|Command|Description|Parameter|
|---|---|---|
|`:SurrealDBRun`|Runs the current buffer content, line under the cursor or selection | `buf`, `buffer`, `ln`, `line`, `sel`, `selection`|
|`:SurrealDBConnection`|Changes the certain variables of the used connection | `env`, `user`, `pass`, `host`, `ns`, `db`, `all`|
|`:SurrealDBScratch`|Creates a buffer that acts as a scratchpad for your querys||


## Setup
The code block below shows how to load the plugin.

```lua
local surrealdb = require("surrealdb-nvim")

-- default config
surrealdb.setup{}

surrealdb.setup{connection = {host="localhost:8001/sql"}} -- updates the key:value pair `host` of the default config.
```

## Config
The config below is the default config for the surrealdb-nvim plugin.

```lua
config = {
	connection = {
		host = "localhost:8000/sql",
		ns = "test",
		db = "test",
		user = "root",
		pass = "root",
	},
	file = {
		extension = {"*.sdb", "*.surql", "*.sql"}
		run_on_safe = false,
		type = "sql",
	},
	keymaps = {
		{"n", "<leader>5", ":SurrealDBRun buf<CR>"},
		{"n", "<leader>5l", ":SurrealDBRun ln<CR>"},
		{"v", "<leader>5", ":<C-U>SurrealDBRun sel<CR>"},
	},
	output = {
		buf_name = "SurrealDB Response",
		split = "vertical",
		format_cmd = ":%!jq --indent 2",
	},
	scratchpad = {
		buf_name = "SurrealDB Scratchpad",
		split = "horizontal",
	},
}
```
