return {
  -- Improve markdown rendering
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    config = function()
      local md = require 'render-markdown'
      md.setup {
        code = {
          border = 'thin',
          inline_pad = 1,
        },
        bullet = {
          enabled = false,
        },
        heading = {
          enabled = false,
        },
        pipe_table = {
          style = 'normal',
        },

        completions = {
          blink = {
            enabled = true,
          },
          lsp = {
            enabled = true,
          },
        },
      }
    end,
  },
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
