return {
  'lewis6991/satellite.nvim',
  version = '*',
  config = function()
    -- Create an autocommand to force the highlight color and immediately trigger the autocommand.
    -- This runs every time you load a colorscheme to prevent it from being cleared.
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = function()
        vim.api.nvim_set_hl(0, 'ScrollView', {
          fg = '#424242',
          bg = '#d3d3d3',
          force = true,
        })
      end,
    })
    vim.api.nvim_exec_autocmds('ColorScheme', {})

    require('satellite').setup {
      current_only = false,
      winblend = 50,
      zindex = 40,
      excluded_filetypes = {
        'cmp_docs',
        'cmp_menu',
        'noice',
        'prompt',
        'TelescopePrompt',
        'snacks_input',
        'alpha',
        'dashboard',
      },
      width = 2,
      handlers = {
        cursor = {
          enable = true,
          symbols = { '⎺', '⎻', '⎼', '⎽' },
        },
        search = { enable = true },
        diagnostic = {
          enable = true,
          signs = { '-', '=', '≡' },
          min_severity = vim.diagnostic.severity.HINT,
        },
        gitsigns = {
          enable = true,
          signs = {
            add = '│',
            change = '│',
            delete = '-',
          },
        },
        marks = {
          enable = true,
          show_builtins = false,
          key = 'm',
        },
        quickfix = {
          signs = { '-', '=', '≡' },
        },
      },
    }
  end,
}

-- return {
--   'petertriho/nvim-scrollbar',
--   version = '*',
--   config = function()
--     require('scrollbar').setup {
--       handle = {
--         text = ' ',
--         blend = 0,
--         color = '#404040',
--       },
--       handlers = {
--         cursor = true,
--         diagnostic = true,
--         gitsigns = true, -- Requires gitsigns
--         handle = true,
--         search = false, -- Requires hlslens
--         ale = false, -- Requires ALE
--       },
--       marks = {
--         GitAdd = {
--           text = '│',
--           priority = 7,
--           gui = nil,
--           color = nil,
--           cterm = nil,
--           color_nr = nil, -- cterm
--           highlight = 'GitSignsAdd',
--         },
--         GitChange = {
--           text = '│',
--           priority = 7,
--           gui = nil,
--           color = nil,
--           cterm = nil,
--           color_nr = nil, -- cterm
--           highlight = 'GitSignsChange',
--         },
--         GitDelete = {
--           text = '│',
--           priority = 7,
--           gui = nil,
--           color = nil,
--           cterm = nil,
--           color_nr = nil, -- cterm
--           highlight = 'GitSignsDelete',
--         },
--       },
--       excluded_filetypes = {
--         'cmp_docs',
--         'cmp_menu',
--         'noice',
--         'prompt',
--         'TelescopePrompt',
--         'snacks_input',
--       },
--     }
--   end,
-- }
