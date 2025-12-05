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
  -- Typst
  {
    'sylvanfranklin/omni-preview.nvim',
    dependencies = {
      -- Typst
      { 'chomosuke/typst-preview.nvim', lazy = true },
      -- CSV
      { 'hat0uma/csvview.nvim', lazy = true },
      -- Markdown
      { 'toppair/peek.nvim', lazy = true, build = 'deno task --quiet build:fast' },
    },
    config = function()
      require('omni-preview').setup()
      require('typst-preview').setup {
        app = 'browser',
        dependencies_bin = {
          ['websocat'] = nil,
        },
      }
      require('peek').setup {
        app = 'browser',
      }
      require('csvview').setup {
        view = {
          display = 'border',
        },
      }
    end,
  },
}
