-- Live browser graph of how I navigate code. Nothing runs until :JumpGraphStart.
-- Loaded from the local checkout (not yet on GitHub); the core binary comes from
-- the local jumpgraph-core release build instead of being downloaded.
-- Once published: replace `dir` with 'kshksdrt/jumpgraph.nvim', drop `core.path`,
-- and add `build = function() require('jumpgraph.install').install { sync = true } end`.

return {
  'kshksdrt/jumpgraph.nvim',
  build = function()
    require('jumpgraph.install').install { sync = true }
  end,
  cmd = { 'JumpGraphStart', 'JumpGraphOpen', 'JumpGraphMode' },
  opts = {},
}
