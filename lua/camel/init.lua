local M = {}

local state = require("camel.state")
local art = require("camel.art")

function M.start()
	state.create_window(art.camel)
	state.start_animation()
end

function M.setup(opts)
end

return M
