-- This sets the leader key to the space bar.
-- You can change this to another key if you prefer.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Helper function for setting keymaps
local function keymap_set(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- =============================================================================
-- Window Navigation
-- =============================================================================
-- Use arrow keys to navigate between windows in normal mode.
-- <C-w>h/j/k/l is the standard Vim command for window navigation.
keymap_set('n', '<Left>', '<C-w>h', { desc = 'Switch to window on the left' })
keymap_set('n', '<Down>', '<C-w>j', { desc = 'Switch to window below' })
keymap_set('n', '<Up>', '<C-w>k', { desc = 'Switch to window above' })
keymap_set('n', '<Right>', '<C-w>l', { desc = 'Switch to window on the right' })

-- =============================================================================
-- Window Resizing
-- =============================================================================
-- Use <leader>r + h/j/k/l to resize windows.
-- This mapping is more intuitive, following the standard hjkl movement keys.
-- rh: 'h' is left, so it makes the window narrower.
-- rl: 'l' is right, so it makes the window wider.
-- rj: 'j' is down, so it makes the window shorter.
-- rk: 'k' is up, so it makes the window taller.

-- Resize horizontally
keymap_set('n', '<leader>rh', ':vertical resize -1<CR>', { desc = 'Decrease window width by 1' })
keymap_set('n', '<leader>rl', ':vertical resize +1<CR>', { desc = 'Increase window width by 1' })

-- Resize vertically
keymap_set('n', '<leader>rj', ':resize -1<CR>', { desc = 'Decrease window height by 1' })
keymap_set('n', '<leader>rk', ':resize +1<CR>', { desc = 'Increase window height by 1' })

function PopOutWindow()
  -- 1. Get info from the current buffer
  local original_buf = vim.api.nvim_get_current_buf()
  local content = vim.api.nvim_buf_get_lines(original_buf, 0, -1, false)
  local filetype = vim.api.nvim_buf_get_option(original_buf, 'filetype')

  -- 2. Create a new, temporary buffer for the popup window
  local popup_buf = vim.api.nvim_create_buf(false, true)

  -- 3. Set the content and filetype of the new popup buffer
  vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, content)
  vim.api.nvim_buf_set_option(popup_buf, 'filetype', filetype)

  -- Calculate dimensions and position
  local width = math.floor(vim.o.columns * 0.75)
  local height = math.floor(vim.o.lines * 0.75)
  local top = math.floor((vim.o.lines - height) / 2)
  local left = math.floor((vim.o.columns - width) / 2)

  -- 4. Open the popup with the new buffer
  local win = vim.api.nvim_open_win(popup_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = top,
    col = left,
    style = 'minimal',
    border = 'rounded',
  })

  -- 5. Map <Esc> to conditionally close the window
  vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<Esc>', '', {
    noremap = true,
    silent = true,
    callback = function()
      vim.api.nvim_win_close(win, true)
    end,
  })
end

-- Create a command to call the function
vim.api.nvim_create_user_command('PopOutWindow', PopOutWindow, {})

-- Map <Leader>o to call the new command
vim.keymap.set('n', '<Leader>w', '<Cmd>PopOutWindow<CR>', {
  silent = true,
  desc = 'Pop out current [W]indow',
})
