require 'custom.keybinds.from_community.git'

-- Keybinds from ThePrimeagen. See https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/remap.lua
-- vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
-- vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste over visually selected text without overwriting the register' })

-- From the Vim wiki: https://bit.ly/4eLAARp
-- Search and replace word under the cursor
vim.keymap.set('n', '<Leader>rw', [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = '[R]eplace [W]ord' })
