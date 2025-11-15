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
      sync_root_with_cwd = true,
      git = {
        ignore = false,
      },
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
        vim.api.nvim_buf_set_keymap(0, 'n', '\\', ':lua require("nvim-tree.api").tree.close()<CR>', { noremap = true, silent = true })
      end,
    })
  end,
}
