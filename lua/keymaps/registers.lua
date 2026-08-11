-- Echo which register was picked after `"`, which is otherwise silent.
vim.keymap.set({ 'n', 'v' }, '"', function()
  local char_code = vim.fn.getchar()
  if char_code == 27 then
    return '' -- <Esc>: cancel
  end

  local char = vim.fn.nr2char(char_code)
  vim.notify('Selected Register: ' .. char, vim.log.levels.INFO)

  -- Returned as an expr mapping, so Neovim runs the real `"a` for us.
  return '"' .. char
end, { expr = true, desc = 'Notify on register selection' })
