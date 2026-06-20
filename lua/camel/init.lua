local config = {
	color = "#C19A6B",
	right = vim.o.columns - 25,
	top = 5,
	ticks = 150,
}
local M = {}

local state = require("camel.state")

-- show the camel
function M.show()
	state.create_window()
end

-- start the animation
function M.start()
	state.create_window()
	state.start_animation()
end

-- stop the animation
function M.stop()
	state.stop_animation()
end

-- setup
function M.setup(opts)
	opts = vim.tbl_deep_extend("force", config, opts or {})
	state.init(opts)
end

-- kill the camel
function M.destroy()
	state.destroy()
end

return M
