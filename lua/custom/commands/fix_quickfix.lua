local M = {
  -- cursor_on_quickfix_list = false,
  -- cursor_on_location_list = false,
}

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'qf',
--   callback = function()
--     local is_quickfix = vim.fn.getwininfo(vim.fn.win_getid())[1].quickfix == 1
--     local is_loclist = vim.fn.getwininfo(vim.fn.win_getid())[1].loclist == 1
--
--     if is_quickfix then
--       M.cursor_on_quickfix_list = true
--       M.cursor_on_location_list = false
--
--       -- TODO: Enter to open quickfix list item
--     else
--       M.cursor_on_quickfix_list = false
--       if is_loclist then
--         M.cursor_on_location_list = true
--
--         -- TODO: Enter to open location list item
--       end
--     end
--   end,
-- })

-- local function get_qf_item_index()
--   -- Not in qf list
--   if M.cursor_on_quickfix_list == false then
--     return nil
--   end
--
--   -- Get current line number
--   local curr_line = vim.fn.line '.'
--
--   -- Get the qf list
--   local list = vim.fn.getqflist()
--   local total_lines = 0
--
--   -- Iterate and find the quickfix under our line
--   for i, item in ipairs(list) do
--     -- Get the text for this item
--     local text = item.text
--
--     -- Count how many lines this item takes
--     local item_lines = 1
--     if text then
--       -- Count newlines in the text plus any word-wrapped lines
--       item_lines = select(2, text:gsub('\n', '\n')) + 1
--       -- You might also need to account for word wrapping here
--       -- depending on your 'wrap' setting
--     end
--
--     total_lines = total_lines + item_lines
--
--     if curr_line <= total_lines then
--       return i
--     end
--   end
--   return nil
-- end

M.is_quickfix_list_open = function()
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      return true
    end
  end
  return false
end

M.is_location_list_open = function()
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.loclist == 1 and win.winnr == vim.fn.winnr() then
      return true
    end
  end
  return false
end

M.toggle_quickfix_list = function()
  if M.is_quickfix_list_open() == false then
    vim.cmd 'copen'
  else
    vim.cmd 'cclose'
  end
end

M.toggle_location_list = function()
  if M.is_location_list_open() == false then
    vim.cmd 'lopen'
  else
    vim.cmd 'lclose'
  end
end

-- Toggle quickfix and location lists
vim.keymap.set('n', '<leader>q', M.toggle_quickfix_list, {
  desc = 'Toggle quickfix list',
})
vim.keymap.set('n', '<leader>l', M.toggle_location_list, {
  desc = 'Toggle location list',
})
