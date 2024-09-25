return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
    config = function()
      require('ibl').setup {
        indent = {
          char = '·',
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
