--  ____  _  ____    _____  _   _    _    _   _  _  _____
-- | __ )(_)/ ___|  |_   _|| | | |  / \  | \ | || |/ / __|
-- |  _ \| | |  _     | |  | |_| | / _ \ |  \| || ' /\__ \
-- | |_) | | |_| |    | |  |  _  |/ ___ \| |\  || . \ ___/
-- |____/|_|\____|    |_|  |_| |_/_/   \_\_| \_||_|\_\____|
--
-- to vimichael: https://github.com/vimichael/my-nvim-config

local M = {}

local function floating_window_configuration()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local function mid_point(outer, inner)
    return (outer - inner) / 2
  end

  return {
    relative = 'editor',
    width = width,
    height = height,
    col = mid_point(vim.o.columns, width),
    row = mid_point(vim.o.lines, height),
    border = 'single',
  }
end

local function open_floating_file(filepath)
  local function expand_path(path)
    if path:sub(1, 1) == '~' then
      return os.getenv 'HOME' .. path:sub(2)
    end
    return path
  end

  local path = expand_path(filepath)

  -- If file does not exist
  if vim.fn.filereadable(path) == 0 then
    vim.notify('Could not find' .. ' ' .. path, vim.log.levels.ERROR)
    return
  end

  -- Look for an existing buffer with this file
  local buf = vim.fn.bufnr(path, true)

  -- If the buffer doesn't exist, create one and edit the file
  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(buf, path)
    vim.api.nvim_buf_call(buf, function()
      vim.cmd('edit ' .. vim.fn.fnameescape(path))
    end)
  end

  local win = vim.api.nvim_open_win(buf, true, floating_window_configuration())
  vim.cmd 'setlocal nospell'

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = function()
      -- Check if the buffer has unsaved changes
      if vim.api.nvim_get_option_value('modified', { buf = buf }) then
        vim.notify('This file has unsaved changes.', vim.log.levels.WARN)
      else
        vim.api.nvim_win_close(0, true)
      end
    end,
  })

  vim.api.nvim_create_autocmd('VimResized', {
    callback = function()
      vim.api.nvim_win_set_config(win, floating_window_configuration())
    end,
    once = false,
  })
end

M.setup = function()
  vim.api.nvim_create_user_command('MyNotes', function()
    open_floating_file '~/Documents/StickyNotes.md'
  end, {})
  vim.keymap.set('n', '<leader>n', ':MyNotes<CR>', { silent = true })
end

return M
