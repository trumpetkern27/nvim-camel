local M = {}

local buf
local win

local x = 0
local y = 5

local dx = 1

M.create_window = function(art)
	buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(
		buf,
		0, -- start line
		-1, -- end line
		false, -- strict indexing
		art -- lines
	)
	win = vim.api.nvim_open_win(buf, false, {
		relative = "editor", -- relative to
		row = y, -- vertical position === top
		col = vim.o.columns - 19, -- x pos
		width = 19,
		height = #art,
		style = "minimal", -- removes bonus junk (e.g. line no, status col, signs, etc.)
		zindex = 1,
	})
	vim.api.nvim_set_option_value(
		"winhl",
		"Normal:Normal",
		{ win = win }
	)
end

M.start_animation = function()
end

return M

