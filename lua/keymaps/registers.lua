vim.keymap.set({ 'n', 'v' }, '"', function()
  -- 1. Wait for the user to press the register key (e.g., 'a')
  local char_code = vim.fn.getchar()

  -- 2. If the user pressed ESC (code 27), cancel the action
  if char_code == 27 then
    return ''
  end

  -- 3. Convert the key code to a character
  local char = vim.fn.nr2char(char_code)

  -- 4. Send a notification
  vim.notify('Selected Register: ' .. char, vim.log.levels.INFO)

  -- 5. Return the full command so Neovim executes it (e.g., "a)
  return '"' .. char
end, { expr = true, desc = 'Notify on register selection' })
