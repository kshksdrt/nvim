-- lua/custom/plugins/copilot.lua
return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        accept = '<Right>', -- remap accept to right arrow
        auto_trigger = true,
        keymap = {
          accept = '<Right>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
    }
  end,
}
