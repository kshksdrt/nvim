-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree buffers',
  keys = {
    { '-', ':Neotree buffers<CR>', desc = '[T]oggle [B]uffer list', silent = true },
  },
  config = function()
    vim.cmd [[highlight NeoTreeIndentMarker guifg=#3f3f3f]]
    vim.cmd [[highlight NeoTreeCursorLine guifg=#ffffff guibg=#082f5d]]
    require('neo-tree').setup {
      close_if_last_window = true,
      default_component_configs = {
        indent = {
          indent_size = 1,
        },
        modified = {
          symbol = '',
        },
        name = {
          use_git_status_colors = false,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = {
            added = '',
            modified = '',
            deleted = '',
            renamed = '',
            untracked = '',
            ignored = '',
            unstaged = '',
            staged = '',
            conflict = '',
          },
        },
        file_size = {
          enabled = false,
        },
        type = {
          enabled = false,
        },
        last_modified = {
          enabled = false,
        },
        created = {
          enabled = false,
        },
        symlink_target = {
          enabled = false,
        },
      },
      window = {
        width = 30,
      },
      buffers = {
        enabled = true,
        use_linenumbers = true,
        sort_function = function(a, b)
          -- Sort by buffer number (order of opening)
          return a.bufnr < b.bufnr
        end,
        window = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            visible = true,
          },
          follow_current_file = {
            enabled = true,
          },
          position = 'right',
          mappings = {
            ['-'] = 'close_window',
          },
        },
      },
      filesystem = {
        enabled = false,
        use_linenumbers = true,
        window = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            visible = true,
          },
          follow_current_file = {
            enabled = true,
          },
          position = 'right',
          mappings = {
            ['<esc>'] = 'close_window',
            ['<leader>f'] = 'close_window',
          },
        },
      },
    }
  end,
}
