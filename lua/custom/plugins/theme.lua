return {
  -- Adds VS code's color scheme
  {
    'Mofiqul/vscode.nvim',
    config = function()
      -- Lua:
      -- For dark theme (neovim's default)
      vim.o.background = 'dark'
      -- For light theme
      -- vim.o.background = 'light'

      require('vscode').setup {
        transparent = false,
        italic_comments = false,

        -- Underline `@markup.link.*` variants
        underline_links = true,

        -- Disable nvim-tree background color
        -- disable_nvimtree_bg = true,

        -- Override highlight groups (see ./lua/vscode/theme.lua)
        group_overrides = {
          -- this supports the same val table as vim.api.nvim_set_hl
          -- use colors from this colorscheme by requiring vscode.colors!
          CursorLine = {
            bg = '#303030',
          },
        },
      }
      require('vscode').load()

      -- load the theme without affecting devicon colors.
      -- vim.cmd.colorscheme 'vscode'
    end,
  },
  {
    'no-clown-fiesta/no-clown-fiesta.nvim',
    config = function()
      -- Default options:
      require('no-clown-fiesta').setup {
        theme = 'dark', -- supported themes are: dark, dim, light
        transparent = false, -- Enable this to disable the bg color
        styles = {
          -- You can set any of the style values specified for `:h nvim_set_hl`
          comments = {},
          functions = {},
          keywords = {},
          lsp = {},
          match_paren = {},
          type = {},
          variables = {},
        },
      }

      -- vim.cmd.colorscheme 'no-clown-fiesta'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    config = function()
      -- Default options:
      require('kanagawa').setup {
        compile = false, -- enable compiling the colorscheme
        undercurl = false, -- enable undercurls
        commentStyle = {
          bold = false,
          italic = false,
        },
        functionStyle = {
          bold = false,
          italic = false,
        },
        keywordStyle = {
          bold = false,
          italic = false,
        },
        statementStyle = {
          bold = false,
          italic = false,
        },
        typeStyle = {
          bold = false,
          italic = false,
        },
        transparent = false, -- do not set background color
        dimInactive = true, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            CursorLine = { bg = '#1F1F28' },
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
          }
        end,
        theme = 'dragon', -- Load "wave" theme
        background = { -- map the value of 'background' option to a theme
          dark = 'dragon', -- try "dragon" !
          light = 'lotus',
        },
      }

      -- setup must be called before loading
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
}
