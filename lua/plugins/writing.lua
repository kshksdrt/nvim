return {
  -- List management
  {
    'bngarren/checkmate.nvim',
    ft = 'markdown',
    config = function()
      local map = function(keys, func, desc, mode)
        mode = mode or { 'n', 'x' }
        vim.keymap.set(mode, keys, func, { desc = '[M]arkdown list: ' .. desc })
      end

      local cm = require 'checkmate'
      cm.setup {
        files = {
          '*/**/*.md',
        },
        keys = false,
      }
      map('<leader>mt', cm.toggle, '[T]oggle checkbox', 'n')
      map('<leader>mn', cm.create, '[N]ew item')
      map('<leader>mr', cm.remove_all_metadata, '[R]emove all metadata')
    end,
  },
}
