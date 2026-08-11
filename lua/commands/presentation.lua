-- `:PresentationMode{On,Off}` -- visual effects for screen sharing.
-- Stub for now: the commands exist and track state, but the effect itself
-- (fading tab switches through vimade) is not wired up yet.

local tab_transition_enabled = false

local function presentation_mode_on()
  if tab_transition_enabled == false then
    -- TODO: Enable tab transitions
  end
  tab_transition_enabled = true
end

local function presentation_mode_off()
  if tab_transition_enabled == true then
    -- TODO: Disable tab transitions
  end
  tab_transition_enabled = false
end

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

-- Off by default.
presentation_mode_off()
