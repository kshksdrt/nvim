return {
  -- {
  --   'github/copilot.vim',
  --   version = '*',
  --   lazy = true,
  -- },
  {
    {
      'folke/sidekick.nvim',
      opts = {
        cli = {},
      },
      keys = {
        {
          '<tab>',
          function()
            -- Jump to the next edit suggestion, or apply the one under the cursor.
            if not require('sidekick').nes_jump_or_apply() then
              return '<Tab>' -- nothing pending, act as a normal Tab
            end
          end,
          expr = true,
          desc = 'Goto/Apply Next Edit Suggestion',
        },
        {
          '<c-.>',
          function()
            require('sidekick.cli').toggle()
          end,
          desc = 'Sidekick Toggle',
          mode = { 'n', 't', 'i', 'x' },
        },
        {
          '<leader>aa',
          function()
            require('sidekick.cli').toggle()
          end,
          desc = 'Sidekick Toggle CLI',
        },
        {
          '<leader>as',
          function()
            require('sidekick.cli').select()
          end,
          -- Or to select only installed tools:
          -- require("sidekick.cli").select({ filter = { installed = true } })
          desc = 'Select CLI',
        },
        {
          '<leader>ad',
          function()
            require('sidekick.cli').close()
          end,
          desc = 'Detach a CLI Session',
        },
        {
          '<leader>at',
          function()
            require('sidekick.cli').send { msg = '{this}' }
          end,
          mode = { 'x', 'n' },
          desc = 'Send This',
        },
        {
          '<leader>af',
          function()
            require('sidekick.cli').send { msg = '{file}' }
          end,
          desc = 'Send File',
        },
        {
          '<leader>av',
          function()
            require('sidekick.cli').send { msg = '{selection}' }
          end,
          mode = { 'x' },
          desc = 'Send Visual Selection',
        },
        {
          '<leader>ap',
          function()
            require('sidekick.cli').prompt()
          end,
          mode = { 'n', 'x' },
          desc = 'Sidekick Select Prompt',
        },
        -- Open Claude directly, skipping the picker.
        {
          '<leader>ac',
          function()
            require('sidekick.cli').toggle { name = 'claude', focus = true }
          end,
          desc = 'Sidekick Toggle Claude',
        },
      },
    },
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-CR>',
          },
          layout = {
            position = 'right', -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = false,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = '<Right>',
            accept_word = false,
            accept_line = false,
            next = '<PageDown>',
            prev = '<PageUp>',
            dismiss = '<C-]>',
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ['.'] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      }

      vim.keymap.set(
        'n',
        '<leader>cp',
        require('copilot.suggestion').toggle_auto_trigger,
        { noremap = true, silent = true, desc = 'Toggle [G]ithub [C]opilot' }
      )
    end,
  },
}
