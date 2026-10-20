return {
  {
    'esmuellert/codediff.nvim',
    -- The Cycling* commands are listed so lazy loads the plugin (running config
    -- below) before dispatching to the real commands it defines.
    cmd = { 'CodeDiff', 'CodeDiffCyclingReset', 'CodeDiffCyclingEnable' },
    opts = {
      keymaps = {
        view = {
          next_file = '<Tab>',
          prev_file = '<S-Tab>',
        },
      },
      explorer = {
        file_filter = {
          ignore = {
            '.git/**',
            '.jj/**',
            '*.pdf',
            '*.png',
            '*.jpg',
            '*.jpeg',
            '*.gif',
            '*.bmp',
            '*.webp',
            '*.tiff',
            '*.heic',
            '*.avif',
            '*.ico',
            '*.svg',
          },
        },
      },
      diff = {
        cycle_next_hunk = false,
        cycle_next_file = false,
        cycle_hunks_across_files = false,
      },
    },
    config = function(_, opts)
      require('codediff').setup(opts)

      local cycling_keys = { 'cycle_next_hunk', 'cycle_next_file', 'cycle_hunks_across_files' }
      local set_cycling = function(value)
        local diff_opts = require('codediff.config').options.diff
        for _, key in ipairs(cycling_keys) do
          if value == nil then
            diff_opts[key] = opts.diff[key]
          else
            diff_opts[key] = value
          end
        end
      end

      vim.api.nvim_create_user_command('CodeDiffCyclingReset', function()
        set_cycling(nil)
      end, { desc = 'Restore CodeDiff hunk/file cycling to configured defaults' })
      vim.api.nvim_create_user_command('CodeDiffCyclingEnable', function()
        set_cycling(true)
      end, { desc = 'Enable all CodeDiff hunk/file cycling' })
    end,
  },
  {

    'dlyongemallo/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
        use_icons = true,
        view = {
          default = { layout = 'diff1_inline' },
          merge_tool = { layout = 'diff3_horizontal' },
        },
        file_panel = {
          listing_style = 'tree',
          win_config = { position = 'left', width = 35 }, -- Use "auto" to fit content
        },
        hooks = {}, -- See :h diffview-config-hooks
        keymaps = {}, -- See :h diffview-config-keymaps
      }
    end,
  },
}
