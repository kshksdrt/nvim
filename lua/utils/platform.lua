-- Small OS helpers, shared by plugins/debug.lua and commands/sticky_notes_float.lua.

local M = {}

M.is_windows = function()
  return vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1
end

--- Run a shell command, printing it first.
--- @param cmd string The command to execute
--- @return boolean wasSuccessful Whether the command succeeded
M.run_command = function(cmd)
  print('🚀 Executing: ' .. cmd)

  local ok, _, __ = os.execute(cmd)
  return ok and true or false
  -- if not ok or code ~= 0 then
  --   print(code .. 'Error executing command: ' .. cmd)
  --   return false
  -- else
  --   print('Successfully executed command: ' .. cmd)
  --   return true
  -- end
end

--- POSIX only. `ls -A` skips '.' and '..'; errors are silenced, and a failed
--- command counts as empty.
M.is_dir_empty = function(path)
  local handle = io.popen('ls -A ' .. path .. ' 2>/dev/null')
  if not handle then
    return true
  end

  -- Any output at all means the directory has entries.
  local first_item = handle:read '*l'
  handle:close()
  return first_item == nil
end

--- Whether a path is a directory, via a shell command.
--- @param path string The file system path to check
--- @return boolean isDirectory
M.is_dir = function(path)
  -- The directory separator gives away the platform.
  local is_windows = package.config:sub(1, 1) == '\\'

  local command
  if is_windows then
    -- Only directories have a "NUL" device file inside them.
    command = 'if exist "' .. path .. '\\NUL" (exit 0) else (exit 1)'
  else
    command = 'test -d "' .. path .. '"'
  end

  -- os.execute reports success for exit code 0.
  return os.execute(command)
end

M.get_home_dir = function()
  if os.getenv 'HOME' then
    return os.getenv 'HOME'
  else
    return os.getenv 'USERPROFILE'
  end
end

return M
