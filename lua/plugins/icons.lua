return {
  'nvim-mini/mini.icons',
  version = false,
  config = function()
    require('mini.icons').setup()
    -- Plugins that expect nvim-web-devicons get mini.icons instead.
    require('mini.icons').mock_nvim_web_devicons()
  end,
}
