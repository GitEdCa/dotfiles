local M = {}

local state = {
	floating = {
		buf = -1,
		win = -1,
	}
}

M.job_id = 0

local function create_floating_window(opts)
  opts = opts or {}
  -- Get the current screen dimensions
  local screen_width = vim.o.columns
  local screen_height = vim.o.lines

  -- Default width and height to 80% of screen size
  width_pct = width_pct or 0.8
  height_pct = height_pct or 0.8

  -- Calculate window dimensions based on the percentages
  local win_width = math.floor(screen_width * width_pct)
  local win_height = math.floor(screen_height * height_pct)

  -- Calculate the window's top-left position to center it
  local row = math.floor((screen_height - win_height) / 2)
  local col = math.floor((screen_width - win_width) / 2)

  -- Create a floating window
  local win_config = {
    relative = 'editor',  -- The window is relative to the editor
    width = win_width,    -- The width of the window
    height = win_height,  -- The height of the window
    row = row,            -- The starting row (top)
    col = col,            -- The starting column (left)
    style = 'minimal',    -- Remove borders and title
    border = 'rounded',   -- Use rounded borders
  }

  -- Create the window (you can use any buffer, or create a new one)
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
	  buf = opts.buf
  else
	  buf = vim.api.nvim_create_buf(false, true)  -- Create a new buffer
  end

  local win = vim.api.nvim_open_win(buf, true, win_config)  -- Open the window with the created buffer

  return { buf = buf, win = win } -- Return the buffer ID in case you want to manipulate it later
end

M.toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = create_floating_window({buf = state.floating.buf})
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
			M.job_id = vim.bo.channel
		end
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

vim.api.nvim_create_user_command("FloatTerm", M.toggle_terminal, {})

return M
