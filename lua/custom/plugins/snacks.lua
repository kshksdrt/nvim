return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = {
    picker = {
      config = function()
        vim.api.nvim_set_hl(0, 'NonText', {
          fg = '#8F9491',
        })
      end,
    },
  },
  keys = {
    {
      'gld',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'glD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = 'Goto Declaration',
    },
    {
      'glr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'glI',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      'gly',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'Goto T[y]pe Definition',
    },
    {
      'glai',
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = 'C[a]lls Incoming',
    },
    {
      'glao',
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = 'C[a]lls Outgoing',
    },
    -- Main pickers
    {
      '<leader>.',
      function()
        require('snacks').scratch()
      end,
      desc = 'Open scratch buffer',
    },
    {
      '<leader>ss',
      function()
        require('snacks').scratch.select()
      end,
      desc = 'Select scratch',
    },
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
      '-',
      function()
        require('snacks').picker.buffers()
      end,
      desc = 'Search Buffers',
    },
    {
      '<leader>sH',
      function()
        require('snacks').picker.highlights()
      end,
      desc = 'Search Highlight',
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
    {
      'gr',
      function()
        require('snacks').picker.lsp_references()
      end,
      desc = '[G]oto [R]eferences',
    },
    {
      'gd',
      function()
        require('snacks').picker.lsp_definitions()
      end,
      desc = '[G]oto [D]efinitions',
    },
    {
      'gI',
      function()
        require('snacks').picker.lsp_implementations()
      end,
      desc = '[G]oto [I]mplementations',
    },
    {
      'gy',
      function()
        require('snacks').picker.lsp_type_definitions()
      end,
      desc = '[G]oto Type Definition',
    },
    {
      '<leader>ds',
      function()
        require('snacks').picker.lsp_symbols()
      end,
      desc = '[Document] [S]ymbols',
    },
    {
      '<leader>#',
      function()
        require('snacks').picker.lsp_workspace_symbols()
      end,
      desc = 'Workspace Symbols',
    },
    {
      'gh',
      function()
        require('snacks').picker.git_diff()
      end,
      desc = 'Git diff',
    },
    {
      'gm',
      function()
        require('snacks').picker.marks()
      end,
      desc = '[G]oto [M]arks',
    },
    {
      'gj',
      function()
        require('snacks').picker.jumps()
      end,
      desc = '[G]oto [J]umps',
    },
    {
      'gu',
      function()
        require('snacks').picker.undo()
      end,
      desc = '[G]oto [U]ndo browser',
    },
    -- Advanced searches
    {
      '<leader>s.',
      function()
        require('snacks').picker.recent()
      end,
      desc = 'Recent Files',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
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
