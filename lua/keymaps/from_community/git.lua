-- Git history of the visually selected lines.
vim.keymap.set('v', '<leader>l', ":<c-u>exe ':term git log -L' line(\"'<\").','.line(\"'>\").':'.expand('%')<CR>", { noremap = true })
