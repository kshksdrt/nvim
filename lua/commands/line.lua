-- `:Line` -- open a VS Code style location spec (`path:line:col`).
--
-- The inverse of the `<leader>cl` "Copy [C]ursor [L]ocation" keymap in
-- `lua/keymaps/main.lua`, so a location yanked out of Neovim (or out of VS
-- Code, a stack trace, a linter, a `grep -n` line) can be pasted straight back:
--
--   :Line /home/me/project/init.lua:42:7
--   :Line lua/plugins/git.lua:55
--   :Line ~/notes.md:3
--
-- The trailing `:line` / `:line:col` are both optional; without them this is
-- just `:edit`. `:Line!` forwards the bang to `:edit!` (abandon local changes).

--- Split a location spec into its path / line / column parts.
--- Parsed from the right so Windows drive letters (`C:\src\init.lua:42`) and
--- any other colons inside the path survive intact.
---@param spec string
---@return string path, integer? line, integer? col
local function parse_location(spec)
  local path = vim.trim(spec):gsub('^"(.*)"$', '%1'):gsub("^'(.*)'$", '%1')

  local p, l, c = path:match '^(.*):(%d+):(%d+)$'
  if p then
    return p, tonumber(l), tonumber(c)
  end

  p, l = path:match '^(.*):(%d+)$'
  if p then
    return p, tonumber(l), nil
  end

  return path, nil, nil
end

vim.api.nvim_create_user_command('Line', function(o)
  -- `nargs = '+'` rather than `1` so paths containing spaces work whether or
  -- not the user escaped them; `fargs` strips the escapes, the join restores
  -- the literal spaces.
  local path, line, col = parse_location(table.concat(o.fargs, ' '))
  if path == '' then
    vim.notify('Line: no file path in argument', vim.log.levels.ERROR)
    return
  end

  vim.cmd.edit { args = { vim.fn.fnameescape(vim.fn.expand(path)) }, bang = o.bang }

  if line then
    -- Clamp: a stale location may point past the end of the file, and
    -- nvim_win_set_cursor throws on an out-of-range row.
    line = math.min(math.max(line, 1), vim.api.nvim_buf_line_count(0))
    local last_col = #(vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1] or '')
    vim.api.nvim_win_set_cursor(0, { line, math.min(math.max((col or 1) - 1, 0), last_col) })
  end
end, {
  nargs = '+',
  bang = true,
  complete = 'file',
  desc = 'Edit a VS Code style location (path:line:col)',
})
