-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Make some UI stuff pretty
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  -- Git wrapper
  {
    'tpope/vim-fugitive',
  },
  -- Claims to be lighter-weight and improve how fzf performance
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('fzf-lua').setup {}
    end,
  },
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
        disable_nvimtree_bg = true,

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
      vim.cmd.colorscheme 'vscode'
    end,
  },
  -- -- To display buffers like vscode tabs with indicators for unsaved changes
  -- {
  --   'akinsho/bufferline.nvim',
  --   version = '*',
  --   dependencies = 'nvim-tree/nvim-web-devicons',
  --   config = function()
  --     local bufferline = require 'bufferline'
  --     bufferline.setup {
  --       options = {
  --         color_icons = false,
  --         show_buffer_close_icons = false,
  --         style_preset = bufferline.style_preset.no_italic,
  --         indicator = {
  --           style = 'none',
  --         },
  --         separator_style = ' ',
  --       },
  --     }
  --   end,
  -- },
  -- Fast slanting motions
  {
    'ggandor/leap.nvim',
    version = '*',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>j', '<Plug>(leap-forward-to)', { noremap = true, silent = true, desc = 'Leap forward' })
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>k', '<Plug>(leap-backward-to)', { noremap = true, silent = true, desc = 'Leap backward' })
    end,
  },
  -- To operate on surrounding characters
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end,
  },
  -- Auto-close html tags
  {
    'windwp/nvim-ts-autotag',
    version = '*',
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true,
          enable_rename = false,
          enable_close_on_slash = true,
        },
      }
    end,
  },
  -- Confirmation for quiting
  {
    'yutkat/confirm-quit.nvim',
    event = 'CmdlineEnter',
    opts = {},
  },
  -- To easily add annotations in one command
  {
    'danymat/neogen',
    config = true,
    version = '*',
  },
  -- Context-aware commenting/uncommenting
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    version = '*',
    config = function()
      require('mini.comment').setup {
        options = {
          custom_commentstring = function()
            return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
          end,
        },
      }
    end,
  },
  -- Adds a better quickfix list UI
  {
    'kevinhwang91/nvim-bqf',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('bqf').setup {
        preview = {
          auto_preview = false,
          auto_enable = true,
          auto_resize_height = true, -- highly recommended enable
          preview = {
            win_height = 12,
            win_vheight = 12,
            delay_syntax = 80,
            border = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' },
            show_title = false,
            should_preview_cb = function(bufnr)
              local ret = true
              local bufname = vim.api.nvim_buf_get_name(bufnr)
              local fsize = vim.fn.getfsize(bufname)
              if fsize > 100 * 1024 then
                -- skip file size greater than 100k
                ret = false
              elseif bufname:match '^fugitive://' then
                -- skip fugitive buffer
                ret = false
              end
              return ret
            end,
          },
        },
      }
    end,
  },
  -- Enhances inline diagnostics
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy', -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup {
        preset = 'modern',
        options = {
          multilines = {
            enabled = true,
            always_show = true,
          },
          softwrap = 60,
        },
      }
    end,
  },
  -- Ability to swap delimited items such as function parameters
  {
    'machakann/vim-swap',
  },
  -- Enhance and improve styles of help files text rendering
  {
    'OXY2DEV/helpview.nvim',
    lazy = false, -- Recommended

    -- In case you still want to lazy load
    -- ft = "help",

    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'niba/continue.nvim',
    -- remember to set lazy as false
    lazy = false,
    -- call setup method or set config = true
    config = true,

    ---@module "continue"
    ---@type Continue.Config
    opts = {},
  },
}
