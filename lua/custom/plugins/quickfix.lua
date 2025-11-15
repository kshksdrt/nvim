return {
  'blanktiger/aqf.nvim',
  config = function()
    local aqf = require 'aqf'
    aqf.setup {
      vim.keymap.set('n', '<leader>e', function()
        aqf.edit_curr_qf()
      end, {
        noremap = true,
        desc = '[E]dit Quick-fix list',
      }),
    }
  end,
}
