local snacks = require 'snacks'

-- Configure snacks.scroll
local scrolling_configured = false
local function configure_snacks_scroll()
  ---@type snacks.Config
  local opts = {
    scroll = {
      animate = {
        duration = { step = 15, total = 250 },
        easing = 'inCubic',
        fps = 60,
      },
      spamming = 10, -- threshold for spamming detection
      -- what buffers to animate
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= 'terminal'
      end,
    },
  }

  snacks.setup(opts)
end

-- Configure tab transitions
local tab_transition_enabled = false

-- Commands implementations
local function presentation_mode_on()
  -- Enable scroll animations for presentations
  if scrolling_configured == false then
    configure_snacks_scroll()
    scrolling_configured = true
  end
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
