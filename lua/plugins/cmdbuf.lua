return {
  'notomo/cmdbuf.nvim',
  keys = {
    {
      'q:',
      function()
        require('cmdbuf').split_open(vim.o.cmdwinheight)
      end,
      desc = 'Command buffer',
    },
    {
      '<C-f>',
      function()
        require('cmdbuf').split_open(vim.o.cmdwinheight, { line = vim.fn.getcmdline(), column = vim.fn.getcmdpos() })
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'n', true)
      end,
      mode = 'c',
      desc = 'Open command buffer from cmdline',
    },
  },
  config = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'CmdbufNew',
      callback = function()
        vim.bo.bufhidden = 'wipe'
        if vim.bo.filetype == 'vim' then
          vim.bo.filetype = 'vimcmd'
        end
        vim.keymap.set('n', 'q', '<Cmd>quit<CR>', { buffer = true, nowait = true })
        vim.keymap.set({ 'n', 'i' }, '<CR>', function()
          return require('cmdbuf').cmdline_expr()
        end, { buffer = true, expr = true })
      end,
    })
  end,
}
