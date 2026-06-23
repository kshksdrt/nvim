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
vim.keymap.set('n', 'zs', '<Nop>', { noremap = true, silent = true })

-- My custom text objects
--  Gives you text objects for the contents of current buffer.
vim.api.nvim_set_keymap('x', 'ie', ':<C-u>normal! ggVG<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 'ie', ':<C-u>normal! ggVG<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', 'ae', ':<C-u>normal! ggVG<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 'ae', ':<C-u>normal! ggVG<CR>', { noremap = true, silent = true })

-- Navigation
vim.keymap.set('n', '<C-i>', '<C-o>', { noremap = true, silent = true, desc = 'Jump to older position in jumplist' }) -- Conflicts with tmux
vim.keymap.set('n', '<C-o>', '<C-i>', { noremap = true, silent = true, desc = 'Jump to newer position in jumplist' }) -- Conflicts with tmux
vim.keymap.set('n', '<C-c>', '<C-o>', { noremap = true, silent = true, desc = 'Jump to older position in jumplist' }) -- Does not conflict with tmux
vim.keymap.set('n', '<C-v>', '<C-i>', { noremap = true, silent = true, desc = 'Jump to newer position in jumplist' }) -- Does not conflict with tmux

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

-- Move to previous/next tab
vim.keymap.set('n', 'H', '<cmd>tabprev<cr>', { noremap = true, silent = true })
vim.keymap.set('n', 'L', '<cmd>tabnext<cr>', { noremap = true, silent = true })

-- Buffer management
--
-- Buffers are GLOBAL across every tab page (a tab is just a window layout), so a
-- plain `:bd`/`:bdelete` of a buffer shown in a window -- the current split OR a
-- window on another tab -- closes that window and scrambles the layout. folke's
-- Snacks.bufdelete (already loaded; see lua/plugins/snacks.lua) avoids this: it
-- finds every window displaying the buffer (across ALL tabpages, via
-- win_findbuf), swaps in the alternate/most-recently-used buffer, then deletes --
-- so the window survives and no tab gets corrupted. It also prompts to save if
-- the buffer is modified.
-- Source: ~/.local/share/nvim/lazy/snacks.nvim/lua/snacks/bufdelete.lua
vim.keymap.set('n', 'zq', function()
  Snacks.bufdelete() -- delete the current buffer
end, { noremap = true, silent = true, desc = 'Delete current buffer (keep layout)' })
vim.keymap.set('n', 'z;', function()
  Snacks.bufdelete.other() -- delete every buffer except the current one
end, { noremap = true, silent = true, desc = 'Delete other buffers (keep layout)' })
vim.keymap.set('n', 'z/', function()
  Snacks.bufdelete.all() -- delete all buffers
end, { noremap = true, silent = true, desc = 'Delete all buffers (keep layout)' })

-- Route the muscle-memory `:bd[!]` / `:bdelete[!]` through the same safe delete,
-- so even a typed command stops closing windows and corrupting other tabs.
-- `Bdelete` is the layout-preserving wrapper (bang -> force, optional buffer
-- id/name arg). The abbreviations only rewrite the bare command (guarded by an
-- exact `==# 'bd'` match), so `:bd 3` / `:bd!` still expand -- to `Bdelete 3` /
-- `Bdelete!` -- and pass their arg/bang through, while a stray `bd` mid-command
-- (e.g. `:g/x/bd`) is left untouched.
vim.api.nvim_create_user_command('Bdelete', function(o)
  local opts = { force = o.bang }
  if o.args ~= '' then
    opts.buf = tonumber(o.args) -- numeric buffer id, or...
    opts.file = opts.buf == nil and o.args or nil -- ...a buffer name
  end
  Snacks.bufdelete(opts)
end, { bang = true, nargs = '?', complete = 'buffer', desc = 'Delete buffer without disrupting window layout' })
vim.cmd [[cnoreabbrev <expr> bd (getcmdtype() ==# ':' && getcmdline() ==# 'bd') ? 'Bdelete' : 'bd']]
vim.cmd [[cnoreabbrev <expr> bdelete (getcmdtype() ==# ':' && getcmdline() ==# 'bdelete') ? 'Bdelete' : 'bdelete']]

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

-- Zen mode
vim.keymap.set('n', 'ze', ':ZenMode<CR>', { noremap = true, silent = true, desc = 'ToggleZen mode' })
