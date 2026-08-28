-- CodeDiff and Diffview each show a revision in a virtual buffer (`codediff://`,
-- `diffview://`) and the working tree in the *real* file buffer. Both plugins
-- already keep LSP off their virtual buffers, but the real side is an ordinary
-- file buffer, so walking an explorer attaches -- and can spawn -- a language
-- server per file.
--
-- Only buffers a diff view *loads* are marked. Diffing a file that is already
-- open reuses its buffer, which fires no BufReadPre, so its client is untouched:
-- nothing is ever detached.
local function block_lsp_in_diff_buffers()
  local diff_plugins = { 'codediff.nvim', 'diffview.nvim' }

  -- Both plugins read files through `:edit`/`bufload()` from Lua, so the plugin
  -- is still on the stack when BufReadPre fires. Asking them which tabpage they
  -- own would not work: both load their first file before registering the tab.
  local function called_from_diff_plugin()
    for level = 2, 40 do
      local info = debug.getinfo(level, 'S')
      if not info then
        return false
      end
      for _, plugin in ipairs(diff_plugins) do
        if info.source:find(plugin, 1, true) then
          return true
        end
      end
    end
    return false
  end

  local group = vim.api.nvim_create_augroup('diff-view-no-lsp', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    group = group,
    desc = 'Mark buffers loaded by CodeDiff/Diffview so no LSP starts for them',
    callback = function(event)
      if called_from_diff_plugin() then
        vim.b[event.buf].diff_view_buffer = true
        vim.t.diff_view_tab = true
      end
    end,
  })

  -- The mark is buffer-local and outlives the diff, so drop it the first time the
  -- buffer surfaces outside a diff tab and let `vim.lsp.enable` have another go.
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = group,
    desc = 'Re-enable LSP once a diff-loaded buffer is opened normally',
    callback = function(event)
      if vim.b[event.buf].diff_view_buffer and not vim.t.diff_view_tab then
        vim.b[event.buf].diff_view_buffer = nil
        pcall(vim.cmd, 'doautocmd <nomodeline> nvim.lsp.enable FileType')
      end
    end,
  })

  -- `vim.lsp.enable`'s FileType handler funnels into `vim.lsp.start`, and may do
  -- so from a `vim.schedule` when a config resolves `root_dir` asynchronously --
  -- hence the buffer mark above rather than a check at this point.
  local lsp_start = vim.lsp.start
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.start = function(config, opts)
    local bufnr = opts and opts.bufnr or 0
    if bufnr == 0 then
      bufnr = vim.api.nvim_get_current_buf()
    end
    if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr].diff_view_buffer then
      return nil
    end
    return lsp_start(config, opts)
  end
end

return {
  {
    'esmuellert/codediff.nvim',
    -- The Cycling* commands are listed so lazy loads the plugin (running config
    -- below) before dispatching to the real commands it defines.
    cmd = { 'CodeDiff', 'CodeDiffCyclingReset', 'CodeDiffCyclingEnable' },
    -- Installed at startup: the guard has to be in place before either plugin loads.
    init = block_lsp_in_diff_buffers,
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
