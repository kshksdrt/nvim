-- C# via roslyn.nvim, which configures and enables the server itself. These are
-- plugin options only; server settings go through `vim.lsp.config('roslyn')`,
-- i.e. the `roslyn` entry in init.lua's `servers` table.
return {
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- Roslyn watches the workspace itself. This turns off Neovim's file watcher
      -- for this client (no `didChangeWatchedFiles` dynamic registration), and the
      -- server then uses its own in-process watcher. Neovim already does this on
      -- Linux; setting it here makes macOS/Windows behave the same way. Check it
      -- with `:checkhealth roslyn`.
      filewatching = 'roslyn',
    },
  },
}
