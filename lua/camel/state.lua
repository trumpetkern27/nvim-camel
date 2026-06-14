local M = {}

local buf
local win

local x = 0
local y = 5
local color

local dx = 1

local timer
local current_frame = 1


M.init = function(opts)
	color = opts.color
end

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
		col = vim.o.columns - 25, -- x pos
		width = 25,
		height = #art,
		style = "minimal", -- removes bonus junk (e.g. line no, status col, signs, etc.)
	})
	-- make transparency hl group
	vim.api.nvim_set_hl(0, "CamelColour", {fg = color, bg = "NONE", ctermbg = "NONE"})
	-- remap normal to CamelTransparent
	vim.api.nvim_set_option_value("winhl", "Normal:CamelColour", {win = win})
	-- make buf transparent
	vim.api.nvim_set_option_value(
		"winblend",
		100,
		{ win = win }
	)
end

M.start_animation = function(frames)
	timer = vim.uv.new_timer()
	timer:start(0, 150, vim.schedule_wrap(function()
		if not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_buf_is_valid(buf) then
			timer:stop()
			timer:close()
			return
		end

		vim.api.nvim_buf_set_lines(buf, 0, -1, false, frames[current_frame])
		current_frame = (current_frame % #frames) + 1
		-- make transparency hl group
		vim.api.nvim_set_hl(0, "CamelColour", {fg = color, bg = "NONE", ctermbg = "NONE"})
		-- remap normal to CamelTransparent
		vim.api.nvim_set_option_value("winhl", "Normal:CamelColour", {win = win})
		-- make buf transparent
		vim.api.nvim_set_option_value(
			"winblend",
			100,
			{ win = win }
		)
	end))
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

