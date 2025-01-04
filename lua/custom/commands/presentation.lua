local snacks = require 'snacks'

-- Configure tab transitions
local tab_transition_enabled = false

-- Commands implementations
local function presentation_mode_on()
  -- Enable scroll animations for presentations
  if snacks.scroll.enabled == false then
    snacks.scroll.enable()
  end

  -- Communicate tab switching by full fade transition using vimade.
  if tab_transition_enabled == false then
    -- TODO: Enable tab transitions
  end
  tab_transition_enabled = true
end

local function presentation_mode_off()
  -- Disable scroll animations for presentations
  if snacks.scroll.enabled == true then
    snacks.scroll.disable()
  end

  -- Communicate tab switching by full fade transition using vimade.
  if tab_transition_enabled == true then
    -- TODO: Disable tab transitions
  end
  tab_transition_enabled = false
end

-- Commands
vim.api.nvim_create_user_command('PresentationModeOn', presentation_mode_on, {
  desc = 'Enable visual effects for visibility',
  bang = true,
  nargs = '*',
})

vim.api.nvim_create_user_command('PresentationModeOff', presentation_mode_off, {
  desc = 'Disable visual effects for visibility',
  bang = true,
  nargs = '*',
})

-- Default: Off
presentation_mode_off()
