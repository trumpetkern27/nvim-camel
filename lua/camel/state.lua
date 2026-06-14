local M = {}

local buf
local win

local x = 0
local y = 1
local colour = "#c19a6b"

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
	vim.api.nvim_set_hl(0, "CamelColour", {fg = colour, bg = "NONE", ctermbg = "NONE"})
	-- remap normal to CamelTransparent
	vim.api.nvim_set_option_value("winhl", "Normal:CamelColour", {win = win})
	-- make buf transparent
	vim.api.nvim_set_option_value(
		"winblend",
		100,
		{ win = win }
	)
end

M.start_animation = function()
end

M.destroy = function()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true) -- close the window
	end
	if buf and vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_buf_delete(buf, { force = true })
	end
	win = nil
	buf = nil
end

return M

