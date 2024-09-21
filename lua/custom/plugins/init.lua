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
  -- Claims to be lighter-weight and improve how fzf performance
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('fzf-lua').setup {}
    end,
  },
  -- Practice best practices
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  -- Adds quick terminals
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
          border = 'single',
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

      vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>lua Lazygit_toggle()<CR>', { noremap = true, silent = true, desc = 'Open LazyGit' })

      -- Setup additional terminals
      local term1 = Terminal:new {
        direction = 'float',
        count = 1,
      }

      local term2 = Terminal:new {
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

      vim.api.nvim_set_keymap('n', '<leader>t1', '<cmd>lua _G.term1_toggle()<CR>', { noremap = true, silent = true, desc = 'Open Terminal 1' })
      vim.api.nvim_set_keymap('n', '<leader>t2', '<cmd>lua _G.term2_toggle()<CR>', { noremap = true, silent = true, desc = 'Open Terminal 2' })
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
  -- To switch between buffers easily
  {
    'leath-dub/snipe.nvim',
    keys = {
      {
        'gh',
        function()
          require('snipe').open_buffer_menu()
        end,
        desc = 'Open Snipe buffer menu',
      },
    },
    opts = {},
  },
  -- To display buffers like tabs with indicators for unsaved changes
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
  -- To enable fast vertical motions
  {
    'ggandor/leap.nvim',
    version = '*',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>lj', '<Plug>(leap-forward-to)', { noremap = true, silent = true, desc = 'Leap forward' })
      vim.keymap.set({ 'n', 'x', 'o' }, '<leader>lk', '<Plug>(leap-backward-to)', { noremap = true, silent = true, desc = 'Leap backward' })
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
  -- Scrollbar for all buffers
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
  -- Improve markdown rendering
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
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
}
