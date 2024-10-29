return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    version = '3.8.2',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
    config = function()
      local ibl = require 'ibl'
      local hooks = require 'ibl.hooks'

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'IblIndent', {
          fg = '#2B2B2B',
          nocombine = false,
        })
      end)

      ibl.setup {
        indent = {
          char = '│',
          tab_char = '│',
        },
        scope = {
          -- Configures "indent_blankline" to not underline the start and end of a scope
          show_start = false,
          show_end = false,
        },
      }
    end,
  },
}
