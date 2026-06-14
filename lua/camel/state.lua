local M = {}

local buf
local win

local x = 0
local y = 1

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
	})
	-- make transparency hl group
	vim.api.nvim_set_hl(0, "CamelTransparent", {bg = "NONE", ctermbg = "NONE"})
	-- remap normal to CamelTransparent
	vim.api.nvim_set_option_value("winhl", "Normal:CamelTransparent", {win = win})
	-- make buf transparent
	vim.api.nvim_set_option_value(
		"winblend",
		100,
		{ win = win }
	)
end

M.start_animation = function()
end

M.hide = function()
	buf = nil
	win = nil
end

return M

