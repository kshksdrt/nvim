-- Git signs in the gutter, plus the hunk keymaps under <leader>h.
-- This is the only gitsigns spec; init.lua does not configure it.

return {
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gitsigns = require 'gitsigns'
      -- local colors = require('vscode.colors').get_colors()

      gitsigns.setup {
        signs = {
          add = {
            text = '┃',
          },
          change = {
            text = '┃',
          },
          delete = {
            text = '_',
          },
          topdelete = {
            text = '‾',
          },
          changedelete = {
            text = '~',
          },
          untracked = {
            text = '│',
          },
        },
        signs_staged = {
          add = {
            text = '┃',
          },
          change = {
            text = '┃',
          },
          delete = {
            text = '_',
          },
          topdelete = {
            text = '‾',
          },
          changedelete = {
            text = '~',
          },
          untracked = {
            text = '│',
          },
        },
        signs_staged_enable = true,
        on_attach = function(bufnr)
          -- vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = colors.vscGitAdded, bg = 'NONE', bold = false })
          -- vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = colors.vscGitModified, bg = 'NONE', bold = false })
          -- vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = colors.vscGitDeleted, bg = 'NONE', bold = false })
          -- vim.api.nvim_set_hl(0, 'GitSignsStagedAdd', { fg = colors.vscGitAdded, bg = 'NONE', bold = false })
          -- vim.api.nvim_set_hl(0, 'GitSignsStagedChange', { fg = colors.vscGitModified, bg = 'NONE', bold = false })
          -- vim.api.nvim_set_hl(0, 'GitSignsStagedDelete', { fg = colors.vscGitDeleted, bg = 'NONE', bold = false })

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          -- In a CodeDiff tab the working-tree pane is this same file buffer, so
          -- these buffer-local maps shadow CodeDiff's own ]c/[c there. Hand off to
          -- CodeDiff: it walks the hunks of the diff on screen and honours its
          -- cycle_* options (lua/plugins/git.lua) instead of 'wrapscan'.
          local in_codediff = function()
            return package.loaded['codediff'] ~= nil
              and require('codediff.ui.lifecycle').get_session(vim.api.nvim_get_current_tabpage()) ~= nil
          end

          map('n', ']c', function()
            if in_codediff() then
              require('codediff').next_hunk()
            elseif vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              gitsigns.nav_hunk 'next'
            end
          end, { desc = 'Jump to next git [c]hange' })

          map('n', '[c', function()
            if in_codediff() then
              require('codediff').prev_hunk()
            elseif vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gitsigns.nav_hunk 'prev'
            end
          end, { desc = 'Jump to previous git [c]hange' })

          -- Actions
          -- visual mode
          map('v', '<leader>hs', function()
            gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'git [s]tage hunk' })
          map('v', '<leader>hr', function()
            gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'git [r]eset hunk' })
          -- normal mode
          map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
          map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
          map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
          map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
          map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
          map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
          map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
          map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
          map('n', '<leader>hD', function()
            gitsigns.diffthis '@'
          end, { desc = 'git [D]iff against last commit' })
          -- Toggles
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
          map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
        end,
      }
    end,
  },
}
