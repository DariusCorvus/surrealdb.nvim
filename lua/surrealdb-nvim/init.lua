local default = require("lua.surrealdb-nvim.default")
local config = require("lua.surrealdb-nvim.config")

---setup to overwrite the predefined defaults.
---@param opts? table
local function setup(opts)
	if opts ~= nil then
		config.update_config(opts)
	end
	require("lua.surrealdb-nvim.command")
end

return { setup = setup, config = config, default = default }
