-- Git history of the visually selected lines.
vim.keymap.set('v', '<leader>l', ":<c-u>exe ':term git log -L' line(\"'<\").','.line(\"'>\").':'.expand('%')<CR>", { noremap = true })

-- Git log (1-line with stats)
local GIT_LOG_DEFAULT_COUNT = 100

local function show_git_log(count)
  local cmd = {
    'git',
    'log',
    '-n',
    tostring(count),
    '--numstat',
    '--pretty=format:COMMIT_START%x09%H%x09%ai%x09%s',
  }
  local lines = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 or #lines == 0 then
    vim.notify('No git history found', vim.log.levels.WARN)
    return
  end

  local formatted = {}
  local sha, timestamp, subject
  local files, ins, del = 0, 0, 0

  local function flush()
    if sha then
      local stats = string.format('[%df +%d -%d]', files, ins, del)
      table.insert(formatted, string.format('%s  %s  %-22s  %s', sha, timestamp, stats, subject))
    end
  end

  for _, line in ipairs(lines) do
    if vim.startswith(line, 'COMMIT_START\t') then
      flush()
      local parts = vim.split(line, '\t', { plain = true })
      sha = parts[2] or ''
      timestamp = parts[3] or ''
      subject = parts[4] or ''
      files, ins, del = 0, 0, 0
    elseif line ~= '' then
      local a, d, _ = line:match '^(%S+)%s+(%S+)%s+(.+)$'
      if a and d then
        files = files + 1
        ins = ins + (tonumber(a) or 0)
        del = del + (tonumber(d) or 0)
      end
    end
  end
  flush()

  vim.cmd 'new'
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = 'git'
  vim.wo.wrap = false

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)
  vim.bo[buf].modifiable = false

  vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, silent = true })
end

vim.keymap.set('n', '<leader>gl', function()
  vim.ui.input({ prompt = 'Number of commits (default ' .. GIT_LOG_DEFAULT_COUNT .. '): ' }, function(input)
    -- Cancelled, empty, non-numeric, non-integer or non-positive -> default.
    local n = tonumber(input)
    if not n or n < 1 or n ~= math.floor(n) then
      n = GIT_LOG_DEFAULT_COUNT
    end
    show_git_log(n)
  end)
end, { desc = 'Git log (1-line with stats)' })
