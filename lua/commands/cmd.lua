vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = '*',
  callback = function()
    -- <Esc> normally closes the command-line window; keep it open instead.
    vim.keymap.set('n', '<Esc>', '<Nop>', { buffer = true })
  end,
})
