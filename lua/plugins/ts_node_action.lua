return {
  {
    'ckolkey/ts-node-action',
    opts = {},
    config = function()
      local ts_node_action = require 'ts-node-action'
      ts_node_action.setup {}
      vim.keymap.set('n', '<leader>ts', ts_node_action.node_action, { desc = '[T]ree-[S]itter node' })
    end,
  },
  {
    'Wansmer/treesj',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    }, -- if you install parsers with `nvim-treesitter`
    config = function()
      local treesj = require 'treesj'
      treesj.setup {
        use_default_keymaps = false,
      }
      vim.keymap.set('n', '<leader>sj', require('treesj').toggle, { desc = '[S]plit or [J]oin code-block' })
    end,
  },
}
