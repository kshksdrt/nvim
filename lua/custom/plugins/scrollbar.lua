return {
  'petertriho/nvim-scrollbar',
  version = '*',
  config = function()
    require('scrollbar').setup {
      handle = {
        text = ' ',
        blend = 0,
        color = '#404040',
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        handle = true,
        search = false, -- Requires hlslens
        ale = false, -- Requires ALE
      },
      marks = {
        GitAdd = {
          text = '│',
          priority = 7,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil, -- cterm
          highlight = 'GitSignsAdd',
        },
        GitChange = {
          text = '│',
          priority = 7,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil, -- cterm
          highlight = 'GitSignsChange',
        },
        GitDelete = {
          text = '│',
          priority = 7,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil, -- cterm
          highlight = 'GitSignsDelete',
        },
      },
    }
  end,
}
