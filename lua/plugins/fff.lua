-- Mirrors snacks.lua's picker layout and keys under a `<leader>f` prefix, so
-- both pickers stay usable. Caveat: `<leader>f` alone is conform's format
-- buffer, which now waits out 'timeoutlen' before firing.
return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    -- downloads a prebuilt binary or falls back to cargo build
    require('fff.download').download_or_build_binary()
  end,
  -- for nixos:
  -- build = "nix run .#release",
  opts = {
    -- debug = { enabled = true, show_scores = true }, -- splits the preview pane
    prompt = ' ',
    title = 'Files',
    -- <Esc> to normal mode, again to close (fff's default closes from both).
    prompt_vim_mode = true,
    layout = {
      width = 1,
      height = 0.6,
      anchor = 'bottom',
      prompt_position = 'top',
      preview_position = 'right',
      preview_size = 0.5,
      border = 'single',
      -- Always horizontal, like snacks. Must be `false`; a `nil` key is absent
      -- from the table, so tbl_deep_extend would keep fff's default.
      flex = false,
    },
    -- These REPLACE fff's defaults, hence the repeated upstream keys. fff has no
    -- list-scroll action, so snacks' <C-b>/<C-f> also drive the preview.
    keymaps = {
      move_up = { '<Up>', '<C-p>', '<C-k>' },
      move_down = { '<Down>', '<C-n>', '<C-j>' },
      preview_scroll_up = { '<C-u>', '<C-b>' },
      preview_scroll_down = { '<C-d>', '<C-f>' },
    },
  },
  lazy = false, -- the plugin lazy-initialises itself
  keys = {
    {
      '<leader>ff',
      function()
        require('fff').find_files()
      end,
      desc = 'FFF: Search Files',
    },
    {
      '<leader>fg',
      function()
        require('fff').live_grep()
      end,
      desc = 'FFF: Search by Grep',
    },
    {
      '<leader>fw',
      function()
        require('fff').live_grep_under_cursor()
      end,
      mode = { 'n', 'x' },
      desc = 'FFF: Search Word',
    },
    {
      '<leader>fW',
      function()
        -- Trim wrapping punctuation so `("foo/bar.lua"),` searches `foo/bar.lua`.
        local word = vim.fn.expand('<cWORD>'):gsub('^%W+', ''):gsub('%W+$', '')
        require('fff').find_files { query = word }
      end,
      desc = 'FFF: Search Files for WORD under cursor',
    },
    {
      '<leader>fr',
      function()
        require('fff').resume()
      end,
      desc = 'FFF: Resume',
    },
    {
      '<leader>fn',
      function()
        require('fff').find_files_in_dir(vim.fn.stdpath 'config')
      end,
      desc = 'FFF: Search Neovim Config',
    },
  },
}
