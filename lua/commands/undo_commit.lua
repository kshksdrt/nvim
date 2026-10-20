-- `:GitUndoCommit` / `<leader>hU` -- VS Code's "Git: Undo Last Commit".
--
-- Mirrors `git.undoCommit` in vscode/extensions/git/src/commands.ts:
--   * no commit at HEAD      -> warn and stop
--   * HEAD is a merge commit -> ask before undoing
--   * HEAD has a parent      -> `git reset --soft HEAD~` (changes stay staged)
--   * HEAD is a root commit  -> delete HEAD, then unstage everything
--   * finally the commit message is put back where the next commit is written
--     (VS Code fills its SCM input box). Here that means lazygit's preserved
--     draft (`<gitdir>/LAZYGIT_PENDING_COMMIT`, read when its commit panel
--     opens) and, for `:Git commit` / `git commit`, the next empty gitcommit
--     buffer.
--
-- Global rather than in gitsigns' on_attach (`lua/plugins/gitsigns.lua`) so it
-- also works from buffers gitsigns doesn't attach to (explorer, terminal, ...).

local title = 'Undo Last Commit'

---@param root string
---@param args string[]
---@return vim.SystemCompleted
local function git(root, args)
  return vim.system(vim.list_extend({ 'git', '-C', root }, args), { text = true }):wait()
end

--- Directory to resolve the repository from: the current file's directory,
--- or the cwd for special/unnamed buffers.
local function start_dir()
  local name = vim.api.nvim_buf_get_name(0)
  if vim.bo.buftype == '' and name ~= '' then
    local dir = vim.fs.dirname(name)
    if vim.fn.isdirectory(dir) == 1 then
      return dir
    end
  end
  return vim.fn.getcwd()
end

--- Restore `message` as the draft for the next commit in this repo.
---@param root string
---@param message string full commit message (`%B`)
local function restore_message(root, message)
  local summary, body = message:match '^([^\n]*)\n?(.*)$'
  body = vim.trim(body)

  -- lazygit's preservation format is summary and description joined by a
  -- single "\n" (see SplitPreservedCommitMessage in lazygit's commits_helper.go).
  local gitdir = vim.trim(git(root, { 'rev-parse', '--absolute-git-dir' }).stdout or '')
  if gitdir ~= '' then
    local preserved = body == '' and summary or summary .. '\n' .. body
    local f = io.open(vim.fs.joinpath(gitdir, 'LAZYGIT_PENDING_COMMIT'), 'w')
    if f then
      f:write(preserved)
      f:close()
    end
  end

  -- One-shot: prefill the next gitcommit buffer of this repo if its message is
  -- still empty (git's template is only comments/blank lines at that point).
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'gitcommit',
    once = true,
    group = vim.api.nvim_create_augroup('git_undo_commit_message', { clear = true }),
    callback = function(ev)
      local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
      for _, line in ipairs(lines) do
        if line ~= '' and not line:match '^#' then
          return
        end
      end
      vim.api.nvim_buf_set_lines(ev.buf, 0, 0, false, vim.split(vim.trim(message), '\n'))
    end,
  })
end

--- Undo HEAD. Run from `~/proj/src/main.lua`, it amounts to:
---
---   git -C ~/proj/src rev-parse --show-toplevel        # -> ~/proj (the root)
---   git -C ~/proj rev-list --parents -n 1 HEAD --      # -> `<sha> <parent>...`
---   # 2+ parents (merge): confirm() first
---   git -C ~/proj log -1 --format=%B HEAD              # message to restore
---
---   # HEAD has a parent:
---   git -C ~/proj reset --soft HEAD~
---   # HEAD is a root commit instead:
---   git -C ~/proj update-ref -d HEAD
---   git -C ~/proj rm -r --cached -q -- .
---
---   # restore_message():
---   git -C ~/proj rev-parse --absolute-git-dir         # -> ~/proj/.git
---   printf 'subject\nbody' > ~/proj/.git/LAZYGIT_PENDING_COMMIT
---
local function undo_commit()
  local top = git(start_dir(), { 'rev-parse', '--show-toplevel' })
  if top.code ~= 0 then
    vim.notify('Not inside a git repository.', vim.log.levels.WARN, { title = title })
    return
  end
  local root = vim.trim(top.stdout)

  -- `<sha> <parent>...`; fails when HEAD is unborn.
  local rev = git(root, { 'rev-list', '--parents', '-n', '1', 'HEAD', '--' })
  if rev.code ~= 0 then
    vim.notify("Can't undo because HEAD doesn't point to any commit.", vim.log.levels.WARN, { title = title })
    return
  end
  local parents = #vim.split(vim.trim(rev.stdout), ' ') - 1

  if parents > 1 then
    local choice = vim.fn.confirm('The last commit was a merge commit. Are you sure you want to undo it?', '&Undo merge commit\n&Cancel', 2, 'Warning')
    if choice ~= 1 then
      return
    end
  end

  local message = git(root, { 'log', '-1', '--format=%B', 'HEAD' }).stdout or ''
  local subject = message:match '^[^\n]*'

  local res
  if parents > 0 then
    res = git(root, { 'reset', '--soft', 'HEAD~' })
  else
    res = git(root, { 'update-ref', '-d', 'HEAD' })
    if res.code == 0 then
      res = git(root, { 'rm', '-r', '--cached', '-q', '--', '.' })
    end
  end
  if res.code ~= 0 then
    vim.notify(vim.trim(res.stderr or ''), vim.log.levels.ERROR, { title = title })
    return
  end

  restore_message(root, message)
  vim.cmd.checktime() -- let gitsigns & co. notice the moved HEAD right away
  vim.notify('Undid commit: ' .. subject, vim.log.levels.INFO, { title = title })
end

vim.api.nvim_create_user_command('GitUndoCommit', undo_commit, { desc = 'Undo the last git commit, keeping its changes staged (VS Code style)' })
vim.keymap.set('n', '<leader>hU', undo_commit, { desc = 'git [U]ndo last commit' })
