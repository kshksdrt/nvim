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
  cmd = 'Neotree',
  keys = {
    { '<leader>f', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  config = function()
    vim.cmd [[highlight NeoTreeIndentMarker guifg=#3f3f3f]]
    require('neo-tree').setup {
      close_if_last_window = true,
      filesystem = {
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
            ['<esc>'] = 'close_window', -- Close the tree with Escape key
            ['\\'] = 'close_window',
          },
        },
      },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function()
            -- auto close
            require('neo-tree').close_all()
          end,
        },
      },
    }
  end,
}
