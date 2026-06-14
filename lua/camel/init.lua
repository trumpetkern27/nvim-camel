local config = {
	color = "#C19A6B"
}
local M = {}

local state = require("camel.state")
local art = require("camel.art")

function M.start()
	state.create_window(art.camel)
	state.start_animation(art.frames)
end

function M.setup(opts)
	opts = vim.tbl_deep_extend("force", config, opts or {})
	state.init(opts)
end

function M.destroy()
	state.destroy()
end

return M
