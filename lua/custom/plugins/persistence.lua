return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
    pre_save = function()
      if package.loaded['snacks'] then
        local snacks = require 'snacks'
        snacks.picker.close()
      end
    end,
  },
}
