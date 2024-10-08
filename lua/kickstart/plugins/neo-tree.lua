-- Nvim-tree is a Neovim plugin to browse the file system
return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        width = 30,
        side = 'right',
        relativenumber = true,
        adaptive_size = true,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    }
    -- Keybinding to open Nvim-tree and reveal current file
    vim.api.nvim_set_keymap('n', '\\', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
    -- Keybinding to close Nvim-tree with Escape key
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'NvimTree',
      callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':lua require("nvim-tree.api").tree.close()<CR>', { noremap = true, silent = true })
      end,
    })
  end,
}

-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- return {
--   'nvim-neo-tree/neo-tree.nvim',
--   branch = 'v3.x',
--   dependencies = {
--     'nvim-lua/plenary.nvim',
--     'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
--     'MunifTanjim/nui.nvim',
--   },
--   cmd = 'Neotree',
--   keys = {
--     { '<leader>f', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
--   },
--   config = function()
--     vim.cmd [[highlight NeoTreeIndentMarker guifg=#3f3f3f]]
--     require('neo-tree').setup {
--       close_if_last_window = true,
--       filesystem = {
--         use_linenumbers = true,
--         window = {
--           filtered_items = {
--             hide_dotfiles = false,
--             hide_gitignored = false,
--             visible = true,
--           },
--           follow_current_file = {
--             enabled = true,
--           },
--           position = 'right',
--           mappings = {
--             ['<esc>'] = 'close_window',
--             ['<leader>f'] = 'close_window',
--           },
--         },
--       },
--       event_handlers = {
--         {
--           event = 'file_opened',
--           handler = function()
--             -- auto close
--             require('neo-tree').close_all()
--           end,
--         },
--       },
--     }
--   end,
-- }
