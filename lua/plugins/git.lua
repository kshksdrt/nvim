return {
  {
    'esmuellert/codediff.nvim',
    cmd = 'CodeDiff',
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
    },
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
