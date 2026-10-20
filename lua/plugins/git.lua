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

      -- The working-tree side of a diff is the real file buffer, which may also be
      -- open in other tabs. 'modifiable' is buffer-local, so it is only cleared
      -- while the cursor sits in a CodeDiff pane, and restored on leaving it.
      -- Revision buffers are already read-only; the conflict result pane is not an
      -- original/modified pane, so merges stay editable.
      local locked = {} ---@type table<integer, true>
      local lifecycle = require 'codediff.ui.lifecycle'
      local sync_lock = function()
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)
        local original_win, modified_win = lifecycle.get_windows(vim.api.nvim_get_current_tabpage())
        local lock = (win == original_win or win == modified_win) and vim.bo[buf].buftype == ''

        for b in pairs(locked) do
          if b ~= buf or not lock then
            if vim.api.nvim_buf_is_valid(b) then
              vim.bo[b].modifiable = true
            end
            locked[b] = nil
          end
        end
        if lock and vim.bo[buf].modifiable then
          vim.bo[buf].modifiable = false
          locked[buf] = true
        end
      end

      local group = vim.api.nvim_create_augroup('codediff-readonly-files', { clear = true })
      vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, { group = group, callback = sync_lock })
      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = { 'CodeDiffOpen', 'CodeDiffFileSelect', 'CodeDiffClose' },
        callback = function()
          vim.schedule(sync_lock)
        end,
      })
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
