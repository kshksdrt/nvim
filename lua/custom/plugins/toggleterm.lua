return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    -- Setup toggleterm.nvim
    require('toggleterm').setup {
      -- size can be a number or function which is passed the current terminal
      size = 20,
      open_mapping = [[<c-`>]],
    }
    local Terminal = require('toggleterm.terminal').Terminal
    -- Setup a lazygit terminal
    local lazygit = Terminal:new {
      cmd = 'lazygit',
      dir = 'git_dir',
      direction = 'float',
      float_opts = {
        border = 'single',
      },
      -- function to run on opening the terminal
      on_open = function(term)
        vim.cmd 'startinsert!'
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
      end,
      -- function to run on closing the terminal
      on_close = function()
        vim.cmd 'startinsert!'
      end,
    }
    function Lazygit_toggle()
      lazygit:toggle()
    end
    vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>lua Lazygit_toggle()<CR>', { noremap = true, silent = true, desc = 'Open LazyGit' })
    -- Setup additional terminals
    local term1 = Terminal:new {
      direction = 'float',
      count = 1,
    }
    local term2 = Terminal:new {
      direction = 'vertical',
      size = 40,
      count = 2,
    }
    function _G.term1_toggle()
      term1:toggle()
    end
    function _G.term2_toggle()
      term2:toggle()
    end
    vim.api.nvim_set_keymap('n', '<leader>t1', '<cmd>lua _G.term1_toggle()<CR>', { noremap = true, silent = true, desc = 'Open Terminal 1' })
    vim.api.nvim_set_keymap('n', '<leader>t2', '<cmd>lua _G.term2_toggle()<CR>', { noremap = true, silent = true, desc = 'Open Terminal 2' })
  end,
}
