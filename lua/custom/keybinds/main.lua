-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Disable arrows, enter, backspace and delete keys in normal mode
vim.keymap.set('n', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<Right>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<CR>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<BS>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<Del>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<PageUp>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<PageDown>', '<Nop>', { noremap = true, silent = true })

-- My custom text objects
--  Gives you text objects for the contents of current buffer.
vim.api.nvim_set_keymap('x', 'ie', ':<C-u>normal! ggVG<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 'ie', ':<C-u>normal! ggVG<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', 'ae', ':<C-u>normal! ggVG<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 'ae', ':<C-u>normal! ggVG<CR>', { noremap = true, silent = true })

-- Navigation
vim.keymap.set('n', '<C-i>', '<C-o>', { noremap = true, silent = true, desc = 'Jump to older position in jumplist' })
vim.keymap.set('n', '<C-o>', '<C-i>', { noremap = true, silent = true, desc = 'Jump to newer position in jumplist' })

-- Move to previous/next buffer
local execute_bprevious = function()
  local count = vim.v.count1
  vim.cmd(count .. 'bprevious')
end
local execute_bnext = function()
  local count = vim.v.count1
  vim.cmd(count .. 'bnext')
end
vim.keymap.set('n', '<C-h>', execute_bprevious, { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', execute_bnext, { noremap = true, silent = true })

vim.keymap.set('n', '<C-M>', execute_bnext, { noremap = true, silent = true })
vim.keymap.set('n', '<C-,>', execute_bprevious, { noremap = true, silent = true })

-- Close all buffers
vim.keymap.set('n', 'z/', ':bufdo bd!<CR>', { noremap = true, silent = true, desc = 'Delete all buffers' })

-- Copy cursor location
vim.keymap.set('n', '<leader>cc', function()
  local file = vim.fn.expand '%:p'
  local line = vim.fn.line '.'
  local loc = '+' .. line .. ' ' .. file
  vim.fn.setreg('+', loc) -- system clipboard
end, { desc = 'Copy [C]ursor [C]ommand' })

vim.keymap.set('n', '<leader>cl', function()
  local loc = vim.fn.expand '%:p' .. ':' .. vim.fn.line '.'
  vim.fn.setreg('+', loc) -- use "+" for system clipboard end, { desc = "Copy full path:line to clipboard" })
end, { desc = 'Copy [C]ursor [L]ocation' })
