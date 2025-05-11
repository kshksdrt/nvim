-- gets the git history of the visual selection
vim.keymap.set('v', '<leader>l', ":<c-u>exe ':term git log -L' line(\"'<\").','.line(\"'>\").':'.expand('%')<CR>", { noremap = true })
