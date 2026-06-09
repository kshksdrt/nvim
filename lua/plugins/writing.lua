return {
  -- Improve markdown rendering
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
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
  -- Viewing
  {
    'aspeddro/pandoc.nvim',
    config = function()
      require('pandoc').setup()

      vim.api.nvim_create_user_command('PandocPreview', function()
        if vim.bo.filetype ~= 'markdown' then
          vim.notify('PandocPreview only works for markdown files', vim.log.levels.WARN)
          return
        end

        local config = require('pandoc.config').get()
        local bin = config.default.bin or 'pandoc'
        local input = vim.api.nvim_buf_get_name(0)
        if input == '' then
          vim.notify('Buffer must be saved to a file first', vim.log.levels.ERROR)
          return
        end
        local output = vim.fn.tempname() .. '.html'

        -- Save buffer before rendering
        vim.cmd 'update'

        vim.fn.jobstart({ bin, input, '--standalone', '--output', output }, {
          on_exit = function(_, code)
            if code == 0 then
              vim.notify('Pandoc: HTML render complete. Opening...', vim.log.levels.INFO)
              vim.ui.open(output)
            else
              vim.notify('Pandoc: Rendering failed', vim.log.levels.ERROR)
            end
          end,
        })
      end, { desc = 'Render markdown to HTML and open in browser' })

      vim.api.nvim_create_user_command('PandocToDoc', function()
        if vim.bo.filetype ~= 'markdown' then
          vim.notify('PandocToDoc only works for markdown files', vim.log.levels.WARN)
          return
        end

        local input = vim.api.nvim_buf_get_name(0)
        if input == '' then
          vim.notify('Buffer must be saved to a file first', vim.log.levels.ERROR)
          return
        end

        local filename = vim.fn.fnamemodify(input, ':t:r')
        local output_dir = vim.fn.expand '~/Documents/'
        local output = output_dir .. filename .. '.html'

        -- Save buffer before rendering
        vim.cmd 'update'

        local config = require('pandoc.config').get()
        local bin = config.default.bin or 'pandoc'

        vim.fn.jobstart({ bin, input, '--standalone', '--output', output }, {
          on_exit = function(_, code)
            if code == 0 then
              vim.notify('Pandoc: Exported to ' .. output, vim.log.levels.INFO)
            else
              vim.notify('Pandoc: Export failed', vim.log.levels.ERROR)
            end
          end,
        })
      end, { desc = 'Export markdown to ~/Documents/ as HTML' })
    end,
  },
}
