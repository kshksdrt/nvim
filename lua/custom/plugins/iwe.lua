return {
  'iwe-org/iwe',
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function(args)
        vim.lsp.start {
          name = 'iwes',
          cmd = { 'iwes' },
          root_dir = vim.fs.root(args.buf, { '.iwe' }),
          flags = {
            debounce_text_changes = 500,
          },
        }
      end,
    })
  end,
}
