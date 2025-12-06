return {
  'echasnovski/mini.icons',
  version = false,
  config = function()
    require('mini.icons').setup()
    -- This is the magic line. It makes other plugins think nvim-web-devicons is installed.
    require('mini.icons').mock_nvim_web_devicons()
  end,
}
