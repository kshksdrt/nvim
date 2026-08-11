return {
  'MagicDuck/grug-far.nvim',
  config = function()
    local grug_far = require 'grug-far'
    -- All defaults. `engine = 'astgrep'` is the alternative to ripgrep.
    grug_far.setup {}

    vim.keymap.set('n', '<leader>S', grug_far.open, {
      desc = 'Search and Replace (Grug far)',
    })
  end,
}
