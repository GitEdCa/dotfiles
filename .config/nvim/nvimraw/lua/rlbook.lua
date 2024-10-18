local M = {}
local bookmarks = {}

-- Function to save the current position and buffer as a sepecifc bookmark
function M.save_bookmark(index)
  if index < 1 or index > 3 then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  bookmarks[index] = { bufnr = bufnr, cursor = cursor }
end

-- Function to jump to a bookmark and update the current bookmark
function M.goto_bookmark(index)
  if bookmarks[index] then
    local bookmark = bookmarks[index]
    vim.api.nvim_set_current_buf(bookmark.bufnr)
    vim.api.nvim_win_set_cursor(0, bookmark.cursor)
  end
end

-- Autocommand to update bookmarks if the current buffer is a bookmark
vim.api.nvim_create_autocmd('BufLeave', {
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    for _, value in pairs(bookmarks) do
      if current_buf == value.bufnr then
	local cursor = vim.api.nvim_win_get_cursor(0)
	value.cursor = cursor
	break
      end
    end
  end
})

return M

