-- Window navigation, resizing and the pop-out float.
-- Leader keys are set once in init.lua, before plugins load.

local function keymap_set(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Window navigation. The arrow keys are freed up for this in keymaps/main.lua,
-- which maps them to <Nop> in normal mode.
keymap_set('n', '<Left>', '<C-w>h', { desc = 'Switch to window on the left' })
keymap_set('n', '<Down>', '<C-w>j', { desc = 'Switch to window below' })
keymap_set('n', '<Up>', '<C-w>k', { desc = 'Switch to window above' })
keymap_set('n', '<Right>', '<C-w>l', { desc = 'Switch to window on the right' })

-- Window resizing with <leader>r + hjkl, following the movement keys:
-- h/l narrow and widen, j/k shorten and heighten.
keymap_set('n', '<leader>rh', ':vertical resize -1<CR>', { desc = 'Decrease window width by 1' })
keymap_set('n', '<leader>rl', ':vertical resize +1<CR>', { desc = 'Increase window width by 1' })
keymap_set('n', '<leader>rj', ':resize -1<CR>', { desc = 'Decrease window height by 1' })
keymap_set('n', '<leader>rk', ':resize +1<CR>', { desc = 'Increase window height by 1' })

-- Show the current buffer's text in a centered float. The float gets a scratch
-- copy, not the buffer itself, so edits made there are thrown away on close.
function PopOutWindow()
  local original_buf = vim.api.nvim_get_current_buf()
  local content = vim.api.nvim_buf_get_lines(original_buf, 0, -1, false)
  local filetype = vim.api.nvim_buf_get_option(original_buf, 'filetype')

  local popup_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, content)
  vim.api.nvim_buf_set_option(popup_buf, 'filetype', filetype)

  local width = math.floor(vim.o.columns * 0.75)
  local height = math.floor(vim.o.lines * 0.75)
  local top = math.floor((vim.o.lines - height) / 2)
  local left = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(popup_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = top,
    col = left,
    style = 'minimal',
    border = 'rounded',
  })

  vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<Esc>', '', {
    noremap = true,
    silent = true,
    callback = function()
      vim.api.nvim_win_close(win, true)
    end,
  })
end

vim.api.nvim_create_user_command('PopOutWindow', PopOutWindow, {})

vim.keymap.set('n', '<Leader>w', '<Cmd>PopOutWindow<CR>', {
  silent = true,
  desc = 'Pop out current [W]indow',
})
