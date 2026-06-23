return {
  'folke/zen-mode.nvim',
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    window = {
      width = 88,
      options = {
        wrap = true,
        linebreak = true,
        breakindent = true,
      },
    },
    options = {
      enabled = true,
      ruler = true, -- disables the ruler text in the cmd line area
      showcmd = true, -- disables the command in the last line of the screen
      -- Keep the statusline visible in zen mode so the "Unsaved: N" indicator
      -- stays in view. 3 = global statusline (shown); 0 would hide it entirely.
      -- Pinned here so it works even if the global 'laststatus' is ever not 3.
      laststatus = 3,
    },
  },
}
