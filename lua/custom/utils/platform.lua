local M = {}

M.is_windows = function()
  return vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1
end

--- A function to run a cmd
--- @param cmd string The command to execute
--- @return boolean wasSuccessful Whether the command was successfully executed
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

M.is_dir_empty = function(path)
  -- `ls -A` lists all entries except for '.' and '..'.
  -- `2>/dev/null` redirects any errors (like "directory not found") so they don't print.
  -- This command is for POSIX systems (Linux, macOS).
  local handle = io.popen('ls -A ' .. path .. ' 2>/dev/null')
  if not handle then
    return true
  end -- Treat command failure as "empty"

  -- Read the first line of output. If there is any output, the directory is not empty.
  local first_item = handle:read '*l'
  handle:close()
  return first_item == nil
end

--- Checks if a path is a directory using OS-specific shell commands.
-- @param path The file system path to check.
-- @return boolean True if the path is a directory, false otherwise.
M.is_dir = function(path)
  -- Check if we are on Windows by looking at the directory separator
  local is_windows = package.config:sub(1, 1) == '\\'

  local command
  if is_windows then
    -- On Windows, check for the existence of the "NUL" device file within the path.
    -- This trick reliably identifies directories.
    command = 'if exist "' .. path .. '\\NUL" (exit 0) else (exit 1)'
  else
    -- On POSIX systems (Linux, macOS), `test -d` is the standard way.
    command = 'test -d "' .. path .. '"'
  end

  -- os.execute returns a success status for exit code 0.
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
