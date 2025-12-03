return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = {
    dashboard = {
      -- preset = {
      --   -- This preset automatically adds the "Restore Session" section
      --   -- if persistence.nvim is installed
      --   keys = {
      --     { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
      --     -- ... other keys
      --   },
      -- },
      sections = {
        -- { section = "header" }, -- <--- I commented this out to remove the logo/text
        {
          section = 'keys',
          gap = 1,
          padding = 1,
        },
        -- Shows your keymaps
        -- { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        -- { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function()
            return vim.fn.isdirectory '.git' == 1 or vim.fn.filereadable(vim.fn.getcwd() .. '/.git') == 1
          end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        {
          section = 'startup',
        },
      },
    },
    explorer = {
      enabled = true,
      replace_netrw = true,
      trash = true,
    },
    picker = {
      layout = {
        -- This applies to the preset layouts (like 'default', 'vscode', 'ivy')
        layout = {
          box = 'horizontal',
          row = -1,
          width = 0,
          height = 0.6,
          border = 'none', -- Root border
          {
            box = 'vertical',
            border = 'none',
            {
              win = 'input',
              height = 1,
              title = '{title} {live}',
              title_pos = 'center',
              border = 'single',
            },
            {
              win = 'list',
              border = 'none',
            },
          },
          {
            win = 'preview',
            title = '{preview}',
            border = 'single',
            width = 0.5,
          },
        },
      },
      sources = {
        explorer = {
          auto_close = true,
          ignored = true,
          hidden = true,
          -- focus = 'input',
          -- start_insert = true,
          prompt = '  ',
          layout = {
            layout = {
              -- Define the vertical layout explicitly
              box = 'vertical',
              position = 'right',
              width = 40,
              -- The input window (search bar) with no border
              {
                win = 'input',
                height = 1,
                border = 'bottom',
              },
              -- The file list window with no border
              {
                win = 'list',
                border = 'none',
              },
            },
          },
          win = {
            list = {
              wo = {
                number = false,
                relativenumber = false,
              },
            },
          },
          follow_file = true,
        },
      },
      config = function()
        vim.api.nvim_set_hl(0, 'NonText', {
          fg = '#8F9491',
        })
      end,
    },
  },
  keys = {
    {
      '\\',
      function()
        Snacks.explorer()
      end,
      desc = 'Open Explorer',
    },
    {
      '<leader>g',
      function(opts)
        Snacks.lazygit.open(opts)
      end,
      desc = '[G]it: lazygit',
    },
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
