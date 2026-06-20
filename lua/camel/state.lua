local M = {}

-- window
local buf
local win

-- opts
local right
local top
local color
local ticks

-- state vars
local timer = nil
local current_frame = 1
local steady = false

-- art
local art = require("camel.art")
local start = art.frames_start_from_walk
local frames = art.frames
local end_frames = art.frames_end
local camel = art.camel

-- helper to color the window
local color_window = function()
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

-- helper to stop timer
local stop_timer = function()
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
end

-- helper to check if valid window / buffer
local valid_win_buf = function()
	return (win and vim.api.nvim_win_is_valid(win))
		and (buf and vim.api.nvim_buf_is_valid(buf))
end

-- initialize colours
M.init = function(opts)
	color = opts.color
	right = opts.right
	top = opts.top
	ticks = opts.ticks
end

-- create the window
M.create_window = function()
	M.destroy() -- attempt to destroy so no duplicate windows

	-- create buffer

	buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(
		buf,
		0, -- start line
		-1, -- end line
		false, -- strict indexing
		camel -- lines -- camel
	)

	-- create window
	win = vim.api.nvim_open_win(buf, false, {
		relative = "editor", -- relative to
		row = top, -- vertical position === top
		col = right, -- x pos
		width = 25,
		height = #camel,
		style = "minimal", -- removes bonus junk (e.g. line no, status col, signs, etc.)
	})

	-- color the window
	color_window()
end

-- start walking
M.start_animation = function()
	timer = vim.uv.new_timer()
	-- start the timer
	timer:start(0, ticks, vim.schedule_wrap(function()
		-- ensure window & buffer are valid
		if not valid_win_buf() then
			stop_timer()
			return
		end

		-- go from the stable -> walking first, then loop walk
		if not steady then
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, start[current_frame])
			current_frame = current_frame + 1
			if current_frame > #start then
				current_frame = 1
				steady = true
			end
		else
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, frames[current_frame])
			current_frame = (current_frame % #frames) + 1
		end

		color_window()
	end))
end

-- stops the animation smoothly
M.stop_animation = function()
	if timer then
		stop_timer()
		local end_idx = 1
		local stopping = true
		-- reset timer for stop
		timer = vim.uv.new_timer()
		-- stop gracefully
		timer:start(0, ticks, vim.schedule_wrap(function()
			-- check if window valid
			if not valid_win_buf() then
				stop_timer()
				return
			end

			-- finish walking cycle
			if stopping then
				-- the current_frame first is the next to be drawn
				-- so if current_frame == 2 then 1 was the last drawn
				if current_frame ~= 2 then
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, frames[current_frame])
					current_frame = (current_frame % #frames) + 1
					color_window()
					return
				end

				stopping = false
			end

			-- end animation loop
			if end_idx <= #end_frames then
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, end_frames[end_idx])
				end_idx = end_idx + 1
				color_window()
			else
				stop_timer()
			end
		end))
	end
end

-- destroys the camel
M.destroy = function()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true) -- close the window
	end
	if buf and vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_buf_delete(buf, { force = true })
	end
	if timer then
		timer = nil
	end
	win = nil
	buf = nil
end

return M
