-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      -- Setup toggleterm.nvim
      require('toggleterm').setup {
        -- size can be a number or function which is passed the current terminal
        size = 20,
        open_mapping = [[<c-`>]],
      }

      local Terminal = require('toggleterm.terminal').Terminal

      -- Setup a lazygit terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        dir = 'git_dir',
        direction = 'float',
        float_opts = {
          border = 'double',
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd 'startinsert!'
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function()
          vim.cmd 'startinsert!'
        end,
      }

      function Lazygit_toggle()
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>lua Lazygit_toggle()<CR>', { noremap = true, silent = true })

      -- Setup additional terminals
      local term1 = Terminal:new {
        cmd = 'bash',
        direction = 'float',
        count = 1,
      }

      local term2 = Terminal:new {
        cmd = 'bash',
        direction = 'vertical',
        size = 40,
        count = 2,
      }

      function _G.term1_toggle()
        term1:toggle()
      end

      function _G.term2_toggle()
        term2:toggle()
      end

      vim.api.nvim_set_keymap('n', '<leader>t1', '<cmd>lua _G.term1_toggle()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>t2', '<cmd>lua _G.term2_toggle()<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'Mofiqul/vscode.nvim',
    config = function()
      -- Lua:
      -- For dark theme (neovim's default)
      vim.o.background = 'dark'
      -- For light theme
      -- vim.o.background = 'light'

      local c = require('vscode.colors').get_colors()
      require('vscode').setup {
        transparent = true,
        italic_comments = false,

        -- Underline `@markup.link.*` variants
        underline_links = true,

        -- Disable nvim-tree background color
        disable_nvimtree_bg = true,

        -- Override highlight groups (see ./lua/vscode/theme.lua)
        group_overrides = {
          -- this supports the same val table as vim.api.nvim_set_hl
          -- use colors from this colorscheme by requiring vscode.colors!
          CursorLine = { bg = '#303030' },
        },
      }
      require('vscode').load()

      -- load the theme without affecting devicon colors.
      vim.cmd.colorscheme 'vscode'
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local bufferline = require 'bufferline'
      bufferline.setup {
        options = {
          style_preset = bufferline.style_preset.no_italic,
          indicator = {
            style = 'none',
          },
          separator_style = {},
        },
      }
    end,
  },
  {
    'ggandor/leap.nvim',
    version = '*',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>lj', '<Plug>(leap-forward-to)', { noremap = true, silent = true, desc = 'Leap forward' })
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>lk', '<Plug>(leap-backward-to)', { noremap = true, silent = true, desc = 'Leap backward' })
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    version = '*',
    config = function()
      require('scrollbar').setup {
        handle = {
          text = '  ',
          blend = 0,
          color = '#404040',
        },
      }
    end,
  },
  {
    'tpope/vim-fugitive',
    version = '*',
  },
  {
    'yutkat/confirm-quit.nvim',
    event = 'CmdlineEnter',
    opts = {},
  },
}
