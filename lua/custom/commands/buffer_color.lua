local M = {}

function M.setup()
  -- Create a dedicated autocommand group
  local group = vim.api.nvim_create_augroup('DynamicBufferHighlight', { clear = true })

  -- Define the autocommand for BufEnter
  vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    pattern = '*', -- Trigger for all buffers
    callback = function()
      -- Get the filename part of the current buffer
      local buffer_name = vim.fn.expand '%:t'

      -- Check if the external command exists and is executable
      if vim.fn.executable 'string_utils' == 0 then
        vim.notify('string_utils command not found in your PATH.', vim.log.levels.ERROR)
        return
      end

      -- Construct the command, escaping the buffer name
      local command = 'string_utils --invoke=color-hex-light-bg ' .. vim.fn.shellescape(buffer_name)

      local function trim(s)
        -- ^%s* : Matches zero or more whitespace characters at the beginning of the string.
        -- (.-) : Captures the shortest possible sequence of any characters (non-greedy). This is the actual content we want to keep.
        -- %s*$ : Matches zero or more whitespace characters at the end of the string.
        -- "%1" : Replaces the entire matched string with the first captured group (the content).
        return string.gsub(s, '^%s*(.-)%s*$', '%1')
      end

      -- Run the command and capture output
      local hex_color = trim(vim.fn.system(command))

      -- Basic validation: Check if it looks like a hex color code
      -- if not hex_color:match '^#[0-9a-fA-F]{6}$' then
      --   vim.notify("string_utils returned an invalid hex color format: '" .. hex_color .. "' for buffer '" .. buffer_name .. "'", vim.log.levels.WARN)
      --   return
      -- end

      local success, err = pcall(vim.api.nvim_set_hl, 0, 'MiniTabLineModifiedCurrent', {
        fg = 'black',
        bg = hex_color,
      })
      -- If the call failed, show a notification with the error
      if not success then
        vim.notify('Failed to set MiniTabLineModifiedCurrent highlight: ' .. tostring(err), vim.log.levels.ERROR)
      end

      local success2, err2 = pcall(vim.api.nvim_set_hl, 0, 'MiniTabLineCurrent', {
        fg = 'black',
        bg = hex_color,
      })
      if not success2 then
        vim.notify('Failed to set MiniTabLineCurrent highlight: ' .. tostring(err2), vim.log.levels.ERROR)
      end

      -- For `bufferline.nvim`
      -- `0` is the global namespace ID
      -- Use pcall (protected call) for safety in case nvim_set_hl fails
      -- local success, err = pcall(vim.api.nvim_set_hl, 0, 'BufferLineSeparator', {
      --   fg = '#5b5b5b',
      --   bg = 'NONE',
      -- })
      -- if not success then
      --   vim.notify('Failed to set BufferLineSeparator highlight: ' .. tostring(err), vim.log.levels.ERROR)
      -- end
      -- local success1, err1 = pcall(vim.api.nvim_set_hl, 0, 'BufferLineBackground', {
      --   fg = '#5b5b5b',
      -- })
      -- if not success1 then
      --   vim.notify('Failed to set BufferLineBackground highlight: ' .. tostring(err1), vim.log.levels.ERROR)
      -- end
      -- local success2, err2 = pcall(vim.api.nvim_set_hl, 0, 'BufferLineBufferSelected', {
      --   bg = hex_color,
      --   bold = true,
      --   fg = 'black',
      -- })
      -- if not success2 then
      --   vim.notify('Failed to set BufferLineBuffer highlight: ' .. tostring(err2), vim.log.levels.ERROR)
      -- end
    end,
  })

  -- Optional: Notify user that setup is complete on Neovim start
  -- vim.notify("Dynamic BufferLine highlight setup complete.", vim.log.levels.INFO)
end

return M
