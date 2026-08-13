-- General keymaps. Window maps live in keymaps/window.lua, which rebinds the
-- arrow keys disabled here to window navigation.

-- Disable arrows, enter, backspace and delete in normal mode.
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

-- Sysstem clipboard
local function paste_system_clipboard()
  vim.api.nvim_paste(vim.fn.getreg '+', true, -1)
end
vim.keymap.set({ 'i', 'c', 't' }, '<C-v>', paste_system_clipboard, { silent = true, desc = 'Paste from system clipboard' })

-- Custom text objects: ie/ae select the whole buffer.
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

-- Buffer management.
--
-- Buffers are global across tabpages, so a plain `:bd` on a visible buffer closes
-- its window and scrambles the layout. Snacks.bufdelete swaps the alternate/MRU
-- buffer into every window showing it first, and prompts to save if modified.
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

-- Route muscle-memory `:bd[!]` / `:bdelete[!]` through the same safe delete.
-- The abbreviations rewrite only the bare command (the exact `==#` guard), so
-- `:bd 3` and `:bd!` still pass their arg and bang through, and a stray `bd`
-- mid-command (`:g/x/bd`) is left alone.
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
  vim.fn.setreg('+', loc) -- system clipboard; paste back with `:Line` (commands/line.lua)
end, { desc = 'Copy [C]ursor [L]ocation' })

-- Zen mode
vim.keymap.set('n', 'ze', ':ZenMode<CR>', { noremap = true, silent = true, desc = 'ToggleZen mode' })

-- Clear quickfix list
vim.keymap.set('n', '<leader>xc', function()
  vim.fn.setqflist {}
  -- setqflist() doesn't dirty the statusline, so the "QF: x of y" widget in
  -- init.lua would show a stale count until the next redraw.
  vim.cmd.redrawstatus { bang = true }
end, { desc = 'Clear quickfix list' })
