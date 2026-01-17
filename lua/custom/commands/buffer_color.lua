local M = {}

-- Controls how much white is mixed into the generated color.
-- 0.0 = Raw, dark colors
-- 0.5 = Balanced pastel
-- 0.9 = Very pale/subtle tint
local lightening_factor = 0.4

--- Generate a deterministic hex color from a string
local function generate_color(str)
  local hash = 0
  for i = 1, #str do
    -- Use modulo to prevent overflow on long paths
    hash = (string.byte(str, i) + ((hash * 32) - hash)) % 0x7FFFFFFF
  end

  -- Generate raw RGB values from the hash
  local r = (hash % 0xFF)
  local g = (math.floor(hash / 0xFF) % 0xFF)
  local b = (math.floor(hash / 0xFFFF) % 0xFF)

  -- Mix the raw color with white (255) based on the lightening factor
  -- Formula: result = (color * (1 - factor)) + (white * factor)
  local r_light = math.floor(r * (1 - lightening_factor) + 255 * lightening_factor)
  local g_light = math.floor(g * (1 - lightening_factor) + 255 * lightening_factor)
  local b_light = math.floor(b * (1 - lightening_factor) + 255 * lightening_factor)

  return string.format('#%02x%02x%02x', r_light, g_light, b_light)
end

function M.setup()
  local group = vim.api.nvim_create_augroup('DynamicBufferHighlight', { clear = true })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    pattern = '*',
    callback = function()
      local full_path = vim.api.nvim_buf_get_name(0)
      if full_path == '' then
        return
      end

      local hex_color = generate_color(full_path)

      vim.api.nvim_set_hl(0, 'MiniTabLineModifiedCurrent', { fg = 'black', bg = hex_color })
      vim.api.nvim_set_hl(0, 'MiniTabLineCurrent', { fg = 'black', bg = hex_color })
    end,
  })
end

return M
