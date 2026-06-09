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
      -- you may turn on/off statusline in zen mode by setting 'laststatus'
      -- statusline will be shown only if 'laststatus' == 3
      laststatus = 3, -- turn off the statusline in zen mode
    },
  },
}
