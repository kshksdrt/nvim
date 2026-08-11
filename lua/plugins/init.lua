-- Small plugin specs that don't need a file of their own. Every *.lua in this
-- directory is auto-imported by `{ import = 'plugins' }` in init.lua.
return {
  -- Makes ; and , repeat the last motion. Mostly used to repeat ]c between git hunks.
  {
    'mawkler/demicolon.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {},
  },
  -- Git wrapper
  {
    'tpope/vim-fugitive',
  },
  -- Disabled: VS Code style buffer tabs with unsaved-change indicators.
  -- {
  --   'akinsho/bufferline.nvim',
  --   version = '*',
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
  -- Jump anywhere on screen with a two-character search.
  {
    url = 'https://codeberg.org/andyg/leap.nvim',
    version = '*',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>j', function()
        require('leap').leap { forward = true }
      end, { noremap = true, silent = true, desc = 'Leap forward' })
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>k', function()
        require('leap').leap { backward = true }
      end, { noremap = true, silent = true, desc = 'Leap forward' })
      require('leap').opts.preview_filter = function()
        return false
      end
    end,
  },
  -- Add, change and delete surrounding pairs. Owns the surround keys; mini.surround
  -- is set up with empty mappings in init.lua so the two don't collide.
  {
    'kylechui/nvim-surround',
    version = '*', -- Pinned for stability; drop for `main`
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
  -- Confirmation prompt on quit.
  {
    'yutkat/confirm-quit.nvim',
    event = 'CmdlineEnter',
    opts = {},
  },
  -- Generates doc annotations for the item under the cursor.
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
          auto_resize_height = true,
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
                ret = false -- too big to preview
              elseif bufname:match '^fugitive://' then
                ret = false -- fugitive buffers have no real file
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
    event = 'VeryLazy', -- `LspAttach` also works
    priority = 1000, -- must load first
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
  -- Swap delimited items, e.g. function parameters.
  {
    'machakann/vim-swap',
  },
  -- Nicer rendering for help files.
  {
    'OXY2DEV/helpview.nvim',
    lazy = false, -- upstream's recommendation; `ft = 'help'` also works
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  -- Disabled: continue.nvim.
  -- {
  --   'niba/continue.nvim',
  --   lazy = false,
  --   config = true,
  --
  --   ---@module "continue"
  --   ---@type Continue.Config
  --   opts = {},
  -- },
}
