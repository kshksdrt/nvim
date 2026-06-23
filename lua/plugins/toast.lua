return {
  -- Slide-in toast showing the buffer name on every BufEnter (local plugin)
  {
    'kshksdrt/animated-toast-nvim',
    event = 'VeryLazy',
    config = function()
      require('animated-toast-nvim').setup {}
    end,
  },
}
