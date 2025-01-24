return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = {
    picker = {},
  },
  keys = {
    -- Main pickers
    {
      '<leader>sf',
      function()
        require('snacks').picker.files()
      end,
      desc = 'Search Files',
    },
    {
      '<leader>sg',
      function()
        require('snacks').picker.grep()
      end,
      desc = 'Search by Grep',
    },
    {
      '<leader>sw',
      function()
        require('snacks').picker.grep_word()
      end,
      desc = 'Search Word',
    },
    {
      '<leader>sb',
      function()
        require('snacks').picker.buffers()
      end,
      desc = 'Search Buffers',
    },
    {
      '<leader>sh',
      function()
        require('snacks').picker.help()
      end,
      desc = 'Search Help',
    },
    {
      '<leader>sd',
      function()
        require('snacks').picker.diagnostics()
      end,
      desc = 'Search Diagnostics',
    },

    -- LSP-related searches
    {
      'gr',
      function()
        require('snacks').picker.lsp_references()
      end,
      desc = 'Search References',
    },
    {
      'gd',
      function()
        require('snacks').picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'gI',
      function()
        require('snacks').picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      'gy',
      function()
        require('snacks').picker.lsp_type_definitions()
      end,
      desc = 'Goto Type Definition',
    },
    {
      '<leader>ss',
      function()
        require('snacks').picker.lsp_symbols()
      end,
      desc = 'Search Symbols',
    },

    -- Git pickers
    -- {
    --   '<leader>gc',
    --   function()
    --     require('snacks').picker.git_commits()
    --   end,
    --   desc = 'Git Commits',
    -- },
    -- {
    --   '<leader>gs',
    --   function()
    --     require('snacks').picker.git_status()
    --   end,
    --   desc = 'Git Status',
    -- },
    -- {
    --   '<leader>gb',
    --   function()
    --     require('snacks').picker.git_branches()
    --   end,
    --   desc = 'Git Branches',
    -- },

    -- Advanced searches
    {
      '<leader>sr',
      function()
        require('snacks').picker.recent()
      end,
      desc = 'Recent Files',
    },
    {
      '<leader>sk',
      function()
        require('snacks').picker.keymaps()
      end,
      desc = 'Search Keymaps',
    },
    {
      '<leader>sm',
      function()
        require('snacks').picker.marks()
      end,
      desc = 'Search Marks',
    },
    {
      '<leader>sR',
      function()
        require('snacks').picker.registers()
      end,
      desc = 'Search Registers',
    },
    {
      '<leader>sc',
      function()
        require('snacks').picker.command_history()
      end,
      desc = 'Command History',
    },

    -- Project navigation
    {
      '<leader>sp',
      function()
        require('snacks').picker.projects()
      end,
      desc = 'Search Projects',
    },
    {
      '<leader>sz',
      function()
        require('snacks').picker.zoxide()
      end,
      desc = 'Search Zoxide',
    },

    -- Configuration
    {
      '<leader>sC',
      function()
        require('snacks').picker.colorschemes()
      end,
      desc = 'Colorschemes',
    },
    {
      '<leader>fn',
      function()
        require('snacks').picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = 'Search Neovim Config',
    },
  },
}
