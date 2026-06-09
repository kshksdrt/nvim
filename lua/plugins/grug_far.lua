return {
  'MagicDuck/grug-far.nvim',
  config = function()
    local grug_far = require 'grug-far'
    grug_far.setup {
      -- options, see Configuration section below
      -- there are no required options atm
      -- engine = 'ripgrep' is default, but 'astgrep' can be specified
    }

    vim.keymap.set('n', '<leader>S', grug_far.open, {
      desc = 'Search and Replace (Grug far)',
    })
  end,
}
