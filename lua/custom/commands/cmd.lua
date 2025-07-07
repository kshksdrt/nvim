vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = '*',
  callback = function()
    -- Map <Esc> to do nothing in the command-line window
    vim.keymap.set('n', '<Esc>', '<Nop>', { buffer = true })
  end,
})
