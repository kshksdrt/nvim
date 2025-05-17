--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.


    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

if vim.g.neovide then
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0

  vim.g.neovide_refresh_rate = 60

  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_antialiasing = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_animate_in_insert_mode = false

  vim.g.neovide_hide_mouse_when_typing = true
end

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!

vim.o.relativenumber = true

-- Disable line wrap
vim.opt.wrap = false

-- Line visibility
-- Map gz to toggle line wrap
vim.keymap.set('n', 'gz', ':set wrap!<CR>', { noremap = true, silent = true, desc = 'Toggle line wrapping' })
vim.opt.scrolloff = 10

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Don't redraw while executing macros
vim.opt.lazyredraw = true

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = {
  tab = '· ',
  trail = '·',
  nbsp = '␣',
}

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Debloat nvim
-- Disable netrw at the very start of init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable built-in directory browser
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.isdirectory(vim.fn.expand '%') == 1 then
      vim.cmd 'bd'
    end
  end,
})

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Quickfix list navigation
vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz', { desc = 'Go to the next quickfix item' })
vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz', { desc = 'Go to the previous quickfix item' })

-- Teminal tools
vim.keymap.set('n', '<leader>x', ':exe "!" . getline(".")<CR>', { noremap = true, silent = false, desc = 'Execute current line in shell' })
vim.keymap.set('n', '<leader>cd', function()
  vim.fn.setreg('+', vim.fn.getcwd())
  print 'Current directory copied to clipboard'
end, { noremap = true, silent = true, desc = 'Copy workspace directory' })
vim.keymap.set('v', '<leader>y', function()
  local start_line, end_line = vim.fn.line "'<", vim.fn.line "'>"
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})
  local executed, errors = 0, 0

  for i, line in ipairs(lines) do
    if line:match '%S' then -- Check if line is not just whitespace
      local success, error_msg = pcall(vim.cmd, line)
      if success then
        executed = executed + 1
      else
        errors = errors + 1
        print(string.format('Error on line %d: %s', start_line + i - 1, error_msg))
      end
    end
  end

  print(string.format('Executed %d command(s), encountered %d error(s)', executed, errors))
end, { noremap = true, silent = true, desc = 'Execute selected lines as commands' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 500,
      preset = 'helix',
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        separator = '',
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  -- { -- Fuzzy Finder (files, lsp, etc)
  --   'nvim-telescope/telescope.nvim',
  --   event = 'VimEnter',
  --   lazy = true,
  --   branch = '0.1.x',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     { -- If encountering errors, see telescope-fzf-native README for installation instructions
  --       'nvim-telescope/telescope-fzf-native.nvim',
  --
  --       -- `build` is used to run some command when the plugin is installed/updated.
  --       -- This is only run then, not every time Neovim starts up.
  --       build = 'make',
  --
  --       -- `cond` is a condition used to determine whether this plugin should be
  --       -- installed and loaded.
  --       cond = function()
  --         return vim.fn.executable 'make' == 1
  --       end,
  --     },
  --     { 'nvim-telescope/telescope-ui-select.nvim' },
  --   },
  --   config = function()
  --     -- Telescope is a fuzzy finder that comes with a lot of different things that
  --     -- it can fuzzy find! It's more than just a "file finder", it can search
  --     -- many different aspects of Neovim, your workspace, LSP, and more!
  --     --
  --     -- The easiest way to use Telescope, is to start by doing something like:
  --     --  :Telescope help_tags
  --     --
  --     -- After running this command, a window will open up and you're able to
  --     -- type in the prompt window. You'll see a list of `help_tags` options and
  --     -- a corresponding preview of the help.
  --     --
  --     -- Two important keymaps to use while in Telescope are:
  --     --  - Insert mode: <c-/>
  --     --  - Normal mode: ?
  --     --
  --     -- This opens a window that shows you all of the keymaps for the current
  --     -- Telescope picker. This is really useful to discover what Telescope can
  --     -- do as well as how to actually do it!
  --
  --     local function theme_wrapper(telescope_command)
  --       return function()
  --         telescope_command(require('telescope.themes').get_ivy())
  --       end
  --     end
  --
  --     -- [[ Configure Telescope ]]
  --     -- See `:help telescope` and `:help telescope.setup()`
  --     require('telescope').setup {
  --       -- You can put your default mappings / updates / etc. in here
  --       --  All the info you're looking for is in `:help telescope.setup()`
  --       --
  --       defaults = {
  --         borderchars = {
  --           prompt = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  --           results = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  --           preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  --         },
  --         -- Ignore these files and folders
  --         file_ignore_patterns = {
  --           'node_modules',
  --           '%.git/',
  --           '%.yarn/',
  --           '%.DS_Store',
  --           'dist',
  --           'build',
  --           -- Add any other patterns you want to ignore
  --         },
  --         vimgrep_arguments = {
  --           'rg',
  --           '--color=never',
  --           '--no-heading',
  --           '--with-filename',
  --           '--line-number',
  --           '--column',
  --           '--hidden',
  --           '--glob=!{.git/*,node_modules/*}',
  --         },
  --         mappings = {
  --           i = {
  --             ['<c-enter>'] = 'to_fuzzy_refine', -- Starts a new search among the currently shown buffers.
  --           },
  --           n = {
  --             ['d'] = 'delete_buffer',
  --             -- Copies the file path
  --             ['y'] = function(bufnr)
  --               local actions = require 'telescope.actions'
  --               local action_state = require 'telescope.actions.state'
  --               local selection = action_state.get_selected_entry()
  --               if selection then
  --                 local file_path = selection.value
  --                 if file_path == nil then
  --                   file_path = selection.filename or selection.path
  --                 end
  --                 if file_path then
  --                   vim.fn.setreg('+', file_path)
  --                   actions.close(bufnr)
  --                   vim.notify('Copied full path: ' .. file_path, vim.log.levels.INFO)
  --                 else
  --                   vim.notify('No file path found for the selection', vim.log.levels.WARN)
  --                 end
  --               end
  --             end,
  --           },
  --         },
  --       },
  --       pickers = {
  --         grep_string = {
  --           debounce = 1000,
  --           hidden = true,
  --           prompt_prefix = '  > ',
  --           disable_coordinates = true,
  --         },
  --         live_grep = {
  --           debounce = 1000,
  --           hidden = true,
  --           prompt_prefix = '  > ',
  --           disable_coordinates = true,
  --         },
  --         find_files = {
  --           find_command = {
  --             'rg',
  --             '--files',
  --             '--color',
  --             'never',
  --             '--hidden',
  --             '--follow',
  --             '--sortr=modified',
  --             '--glob=!{.git/*,node_modules/*}',
  --           },
  --           debounce = 350,
  --           hidden = true,
  --           prompt_prefix = '  > ',
  --           follow = true,
  --           path_display = { 'filename_first' },
  --         },
  --         -- Add more pickers as needed
  --       },
  --       extensions = {
  --         ['ui-select'] = {
  --           require('telescope.themes').get_ivy(),
  --         },
  --       },
  --     }
  --
  --     -- Enable Telescope extensions if they are installed
  --     local telescope = require 'telescope'
  --     pcall(telescope.load_extension, 'fzf')
  --     pcall(telescope.load_extension, 'ui-select')
  --     pcall(telescope.load_extension, 'smart_open')
  --
  --     -- See `:help telescope.builtin`
  --     local builtin = require 'telescope.builtin'
  --
  --     vim.keymap.set('n', '<leader>sh', theme_wrapper(builtin.help_tags), { desc = '[S]earch [H]elp' })
  --     vim.keymap.set('n', '<leader>sk', theme_wrapper(builtin.keymaps), { desc = '[S]earch [K]eymaps' })
  --     vim.keymap.set('n', '<leader>sf', theme_wrapper(builtin.find_files), { desc = '[S]earch [F]iles' })
  --     vim.keymap.set('n', '<leader>ss', theme_wrapper(builtin.builtin), { desc = '[S]earch [S]elect Telescope' })
  --     vim.keymap.set('n', '<leader>sw', theme_wrapper(builtin.grep_string), { desc = '[S]earch current [W]ord' })
  --     vim.keymap.set('n', '<leader>sg', theme_wrapper(builtin.live_grep), { desc = '[S]earch by [G]rep' })
  --     vim.keymap.set('n', '<leader>sd', theme_wrapper(builtin.diagnostics), { desc = '[S]earch [D]iagnostics' })
  --     vim.keymap.set('n', '<leader>sr', theme_wrapper(builtin.resume), { desc = '[S]earch [R]esume' })
  --     vim.keymap.set('n', '<leader>s.', theme_wrapper(builtin.oldfiles), { desc = '[S]earch Recent Files ("." for repeat)' })
  --     vim.keymap.set('n', '<leader>/', theme_wrapper(builtin.current_buffer_fuzzy_find), { desc = '[/] Fuzzily search in current buffer' })
  --     vim.keymap.set('n', 'gh', theme_wrapper(builtin.buffers), { desc = 'Search buffers' })
  --
  --     -- It's also possible to pass additional configuration options.
  --     --  See `:help telescope.builtin.live_grep()` for information about particular keys
  --     vim.keymap.set('n', '<leader>s/', function()
  --       theme_wrapper(builtin.live_grep {
  --         -- Slightly advanced example of overriding default behavior and theme
  --         grep_open_files = true,
  --         prompt_title = 'Live Grep in Open Files',
  --       })
  --     end, { desc = '[S]earch [/] in Open Files' })
  --
  --     -- Shortcut for searching your Neovim configuration files
  --     vim.keymap.set('n', '<leader>sn', function()
  --       theme_wrapper(builtin.find_files {
  --         -- Slightly advanced example of overriding default behavior and theme
  --         cwd = vim.fn.stdpath 'config',
  --       })
  --     end, { desc = '[S]earch [N]eovim files' })
  --   end,
  -- },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        'mason-org/mason.nvim',
        version = '^1.0.0',
        opts = {},
      },
      {
        'mason-org/mason-lspconfig.nvim',
        version = '^1.0.0',
      },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
        'saghen/blink.cmp',
        lazy = false, -- lazy loading handled internally
        -- optional: provides snippets for the snippet source
        dependencies = {
          'rafamadriz/friendly-snippets',
          'xzbdmw/colorful-menu.nvim',
        },

        -- use a release tag to download pre-built binaries
        version = 'v0.*',
        -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
          -- 'default' for mappings similar to built-in completion
          -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
          -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
          -- see the "default configuration" section below for full documentation on how to define
          -- your own keymap.
          keymap = {
            preset = 'default',
          },

          completion = {
            menu = {
              draw = {
                -- We don't need label_description now because label and label_description are already
                -- combined together in label by colorful-menu.nvim.
                columns = { { 'kind_icon' }, { 'label', gap = 1 } },
                components = {
                  label = {
                    text = function(ctx)
                      return require('colorful-menu').blink_components_text(ctx)
                    end,
                    highlight = function(ctx)
                      return require('colorful-menu').blink_components_highlight(ctx)
                    end,
                  },
                },
              },
            },
          },

          appearance = {
            -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono',
          },
          signature = {
            enabled = true,
            window = {
              border = 'rounded',
            },
          },
        },
        -- allows extending the enabled_providers array elsewhere in your config
        -- without having to redefining it
        opts_extend = { 'sources.completion.enabled_providers' },
      },

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function(_, opts)
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame Symbol')
          map('<F2>', vim.lsp.buf.rename, 'Rename Symbol')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Signature
      vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { desc = 'Show signature help' })

      -- Define a highlight group for the border color
      vim.api.nvim_set_hl(0, 'FloatBorderCustom', { fg = '#404040' })

      local border = {
        { '┌', 'FloatBorderCustom' },
        { '─', 'FloatBorderCustom' },
        { '┐', 'FloatBorderCustom' },
        { '│', 'FloatBorderCustom' },
        { '┘', 'FloatBorderCustom' },
        { '─', 'FloatBorderCustom' },
        { '└', 'FloatBorderCustom' },
        { '│', 'FloatBorderCustom' },
      }

      -- General diagnostic config
      vim.diagnostic.config {
        update_in_insert = false,
        signs = true,
        virtual_text = false,
        -- virtual_text = {
        --   source = 'if_many',
        --   spacing = 2,
        --   format = function(diagnostic)
        --     local diagnostic_message = {
        --       [vim.diagnostic.severity.ERROR] = diagnostic.message,
        --       [vim.diagnostic.severity.WARN] = diagnostic.message,
        --       [vim.diagnostic.severity.INFO] = diagnostic.message,
        --       [vim.diagnostic.severity.HINT] = diagnostic.message,
        --     }
        --     return diagnostic_message[diagnostic.severity]
        --   end,
        -- },
        underline = false,
        severity_sort = true,
        float = {
          border = border,
          style = 'minimal',
          source = 'always',
        },
      }

      -- LSP hover and floating window config
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = border,
      })

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = border,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config { signs = { text = diagnostic_signs } }
      end

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      require('mason').setup()
      local mason_registry = require 'mason-registry'

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- See `:help lspconfig-all` for a list of all the pre-configured LSPs

        -- clangd = {},

        gopls = {
          cmd = { 'gopls' },
        },

        -- pyright = {},

        -- rust_analyzer = {},

        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        --
        -- See https://github.com/pmizio/typescript-tools.nvim for more useful features
        ts_ls = {
          setup = {
            init_options = {
              plugins = {
                {
                  name = '@vue/typescript-plugin',
                  location = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server',
                  languages = { 'vue' },
                },
              },
            },
            filetypes = {
              'typescript',
              'javascript',
              'javascriptreact',
              'typescriptreact',
              'vue',
            },
          },
        },

        prettier = {},

        volar = {
          filetypes = {
            'typescript',
            'javascript',
            'javascriptreact',
            'typescriptreact',
            'vue',
          },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        },

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        csharp_ls = {},

        csharpier = {},

        markdown_oxide = {},

        rust_analyzer = {},
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'vue-language-server',
        'prettierd',
        'prettier',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = require('blink.cmp').get_lsp_capabilities(server.capabilities)

            -- For theming, see https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_after_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        ts = { 'prettierd', 'prettier', stop_after_first = true },
        js = { 'prettierd', 'prettier', stop_after_first = true },
        tsx = { 'prettierd', 'prettier', stop_after_first = true },
        jsx = { 'prettierd', 'prettier', stop_after_first = true },
        vue = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  -- { -- Autocompletion
  --   'hrsh7th/nvim-cmp',
  --   event = 'InsertEnter',
  --   dependencies = {
  --     -- Snippet Engine & its associated nvim-cmp source
  --     {
  --       'L3MON4D3/LuaSnip',
  --       build = (function()
  --         -- Build Step is needed for regex support in snippets.
  --         -- This step is not supported in many windows environments.
  --         -- Remove the below condition to re-enable on windows.
  --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --           return
  --         end
  --         return 'make install_jsregexp'
  --       end)(),
  --       dependencies = {
  --
  --     -- Adds other completion capabilities.
  --     --  nvim-cmp does not ship with all sources by default. They are split
  --     --  into multiple repos for maintenance purposes.
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-path',
  --     'hrsh7th/cmp-cmdline',
  --   },
  --   config = function()
  --     -- See `:help cmp`
  --     local cmp = require 'cmp'
  --     local luasnip = require 'luasnip'
  --     luasnip.config.setup {}
  --
  --     -- Set up keymaps for snippets
  --     vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  --       luasnip.jump(1)
  --     end, { silent = true })
  --     vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  --       luasnip.jump(-1)
  --     end, { silent = true })
  --
  --     -- Define icons based on whether nerd fonts are available
  --     local kind_icons = {}
  --
  --     if vim.g.have_nerd_font then
  --       kind_icons = {
  --         Text = '󰉿',
  --         Method = '󰆧',
  --         Function = '󰊕',
  --         Constructor = '',
  --         Field = '󰜢',
  --         Variable = '󰆦',
  --         Class = '󰠱',
  --         Interface = '',
  --         Module = '',
  --         Property = '󰜢',
  --         Unit = '󰑭',
  --         Value = '󰎠',
  --         Enum = '',
  --         Keyword = '󰌋',
  --         Snippet = '',
  --         Color = '󰏘',
  --         File = '󰈙',
  --         Reference = '󰈇',
  --         Folder = '󰉋',
  --         EnumMember = '',
  --         Constant = '󰏿',
  --         Struct = '󰙅',
  --         Event = '',
  --         Operator = '󰆕',
  --         TypeParameter = '',
  --       }
  --     else
  --       -- Fallback to simple ASCII icons
  --       kind_icons = {
  --         Text = 'x',
  --         Method = 'm',
  --         Function = 'f',
  --         Constructor = 'c',
  --         Field = '.',
  --         Variable = 'v',
  --         Class = 'C',
  --         Interface = 'I',
  --         Module = 'M',
  --         Property = 'p',
  --         Unit = 'U',
  --         Value = '=',
  --         Enum = 'E',
  --         Keyword = 'k',
  --         Snippet = 'S',
  --         Color = 'c',
  --         File = 'F',
  --         Reference = 'r',
  --         Folder = 'd',
  --         EnumMember = 'e',
  --         Constant = 'K',
  --         Struct = 'S',
  --         Event = '!',
  --         Operator = 'o',
  --         TypeParameter = 'T',
  --       }
  --     end
  --
  --     cmp.setup {
  --       performance = {
  --         confirm_resolve_timeout = 80,
  --         async_budget = 1,
  --         max_view_entries = 200,
  --         fetching_timeout = 1000,
  --         debounce = 200,
  --         throttle = 200,
  --       },
  --       window = {
  --         completion = cmp.config.window.bordered {
  --           border = 'single',
  --           winhighlight = 'Normal:Normal,FloatBorder:NvimCmpBorder,CursorLine:Visual,Search:None',
  --         },
  --         documentation = cmp.config.window.bordered {
  --           border = 'single',
  --           winhighlight = 'Normal:Normal,FloatBorder:NvimCmpBorder,CursorLine:Visual,Search:None',
  --         },
  --       },
  --       formatting = {
  --         format = function(entry, vim_item)
  --           -- Format: icon name [source] kind
  --           local icon = kind_icons[vim_item.kind]
  --           local kind = vim_item.kind
  --           local source = ({
  --             buffer = 'Buffer',
  --             nvim_lsp = 'LSP',
  --             luasnip = 'Snippet',
  --             nvim_lua = 'Lua',
  --             latex_symbols = 'LaTeX',
  --           })[entry.source.name]
  --
  --           -- Store the original completion text
  --           local completion_text = vim_item.abbr
  --
  --           -- Add some padding for better spacing
  --           vim_item.abbr = string.format('%s %s', icon, completion_text)
  --           vim_item.kind = kind
  --           vim_item.menu = string.format(' [%s]', source)
  --
  --           return vim_item
  --         end,
  --       },
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       completion = { completeopt = 'menu,menuone,noinsert' },
  --
  --       -- For an understanding of why these mappings were
  --       -- chosen, you will need to read `:help ins-completion`
  --       --
  --       -- No, but seriously. Please read `:help ins-completion`, it is really good!
  --       mapping = cmp.mapping.preset.insert {
  --         -- Select the [n]ext item
  --         ['<C-n>'] = cmp.mapping.select_next_item(),
  --         ['<Tab>'] = cmp.mapping.select_next_item(),
  --         ['<Down>'] = cmp.mapping.select_next_item(),
  --         -- Select the [p]revious item
  --         ['<C-p>'] = cmp.mapping.select_prev_item(),
  --         ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  --         ['<Up>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Scroll the documentation window [b]ack / [f]orward
  --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --
  --         -- Accept ([y]es) the completion.
  --         --  This will auto-import if your LSP supports it.
  --         --  This will expand snippets if the LSP sent a snippet.
  --         ['<C-y>'] = cmp.mapping.confirm { select = true },
  --
  --         -- Accepts the completion
  --         ['<Enter>'] = cmp.mapping.confirm { select = true },
  --
  --         -- If you prefer more traditional completion keymaps,
  --         -- you can uncomment the following lines
  --         --['<CR>'] = cmp.mapping.confirm { select = true },
  --         --['<Tab>'] = cmp.mapping.select_next_item(),
  --         --['<S-Tab>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Manually trigger a completion from nvim-cmp.
  --         --  Generally you don't need this, because nvim-cmp will display
  --         --  completions whenever it has completion options available.
  --         ['<C-Space>'] = cmp.mapping.complete {},
  --
  --         -- Think of <c-l> as moving to the right of your snippet expansion.
  --         --  So if you have a snippet that's like:
  --         --  function $name($args)
  --         --    $body
  --         --  end
  --         --
  --         -- <c-l> will move you to the right of each of the expansion locations.
  --         -- <c-h> is similar, except moving you backwards.
  --         ['<C-l>'] = cmp.mapping(function()
  --           if luasnip.expand_or_locally_jumpable() then
  --             luasnip.expand_or_jump()
  --           end
  --         end, { 'i', 's' }),
  --         ['<C-h>'] = cmp.mapping(function()
  --           if luasnip.locally_jumpable(-1) then
  --             luasnip.jump(-1)
  --           end
  --         end, { 'i', 's' }),
  --
  --         -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
  --         --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  --       },
  --       sources = {
  --         {
  --           name = 'lazydev',
  --           -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
  --           group_index = 0,
  --         },
  --         { name = 'nvim_lsp' },
  --         { name = 'luasnip' },
  --         { name = 'path' },
  --       },
  --     }
  --     vim.api.nvim_set_hl(0, 'NvimCmpBorder', { fg = '#404040' })
  --   end,
  -- },

  -- { -- You can easily change to a different colorscheme.
  --   -- Change the name of the colorscheme plugin below, and then
  --   -- change the command in the config to whatever the name of that colorscheme is.
  --   --
  --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   init = function()
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme 'tokyonight-night'

  --     -- You can configure highlights by doing something like:
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },
  -- { -- Autocompletion
  --   'saghen/blink.cmp',
  --   event = 'VimEnter',
  --   version = '1.*',
  --   dependencies = {
  --     -- Snippet Engine
  --     {
  --       'L3MON4D3/LuaSnip',
  --       version = '2.*',
  --       build = (function()
  --         -- Build Step is needed for regex support in snippets.
  --         -- This step is not supported in many windows environments.
  --         -- Remove the below condition to re-enable on windows.
  --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --           return
  --         end
  --         return 'make install_jsregexp'
  --       end)(),
  --       dependencies = {
  --         -- `friendly-snippets` contains a variety of premade snippets.
  --         --    See the README about individual language/framework/plugin snippets:
  --         --    https://github.com/rafamadriz/friendly-snippets
  --         -- {
  --         --   'rafamadriz/friendly-snippets',
  --         --   config = function()
  --         --     require('luasnip.loaders.from_vscode').lazy_load()
  --         --   end,
  --         -- },
  -- --         {
  -- --           'honza/vim-snippets',
  -- --           config = function()
  -- --             require('luasnip.loaders.from_snipmate').load {
  -- --               include = {
  -- --                 -- General-purpose
  -- --                 'go',
  -- --                 'cs',
  -- --                 'lua',
  -- --                 'typescript',
  -- --                 'javascript',
  -- --                 'sql',
  -- --
  -- --                 -- Writing
  -- --                 'markdown',
  -- --
  -- --                 -- Frontend web
  -- --                 'typescriptreact',
  -- --                 'vue',
  -- --                 'javascriptreact',
  -- --                 'scss',
  -- --
  -- --                 -- Shell scripting
  -- --                 'sh',
  -- --               },
  -- --             }
  -- --           end,
  -- --         },
  -- --     'saadparwaiz1/cmp_luasnip',
  --       },
  --       opts = {},
  --     },
  --     'folke/lazydev.nvim',
  --   },
  --   --- @module 'blink.cmp'
  --   --- @type blink.cmp.Config
  --   opts = {
  --     keymap = {
  --       -- 'default' (recommended) for mappings similar to built-in completions
  --       --   <c-y> to accept ([y]es) the completion.
  --       --    This will auto-import if your LSP supports it.
  --       --    This will expand snippets if the LSP sent a snippet.
  --       -- 'super-tab' for tab to accept
  --       -- 'enter' for enter to accept
  --       -- 'none' for no mappings
  --       --
  --       -- For an understanding of why the 'default' preset is recommended,
  --       -- you will need to read `:help ins-completion`
  --       --
  --       -- No, but seriously. Please read `:help ins-completion`, it is really good!
  --       --
  --       -- All presets have the following mappings:
  --       -- <tab>/<s-tab>: move to right/left of your snippet expansion
  --       -- <c-space>: Open menu or open docs if already open
  --       -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
  --       -- <c-e>: Hide menu
  --       -- <c-k>: Toggle signature help
  --       --
  --       -- See :h blink-cmp-config-keymap for defining your own keymap
  --       preset = 'default',
  --
  --       -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
  --       --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  --     },
  --
  --     appearance = {
  --       -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
  --       -- Adjusts spacing to ensure icons are aligned
  --       nerd_font_variant = 'mono',
  --     },
  --
  --     completion = {
  --       -- By default, you may press `<c-space>` to show the documentation.
  --       -- Optionally, set `auto_show = true` to show the documentation after a delay.
  --       documentation = { auto_show = false, auto_show_delay_ms = 500 },
  --     },
  --
  --     sources = {
  --       default = { 'lsp', 'path', 'snippets', 'lazydev' },
  --       providers = {
  --         lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
  --       },
  --     },
  --
  --     snippets = { preset = 'luasnip' },
  --
  --     -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
  --     -- which automatically downloads a prebuilt binary when enabled.
  --     --
  --     -- By default, we use the Lua implementation instead, but you may enable
  --     -- the rust implementation via `'prefer_rust_with_warning'`
  --     --
  --     -- See :h blink-cmp-config-fuzzy for more information
  --     fuzzy = { implementation = 'lua' },
  --
  --     -- Shows a signature help window while you type arguments for a function
  --     signature = { enabled = true },
  --   },
  -- },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin

      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local function get_mode()
              local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
              return string.upper(mode), mode_hl
            end

            -- Function to count unsaved buffers
            local function get_unsaved_buffers()
              local count = 0
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_get_option(buf, 'modified') then
                  count = count + 1
                end
              end
              return count
            end

            local git = MiniStatusline.section_git { trunc_width = 75, bold = false }

            vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { bg = '#858585', fg = '#000000' })
            vim.api.nvim_set_hl(0, 'MiniStatuslineBody', { bg = '#444444', fg = '#ffffff' })

            -- Add highlight group for unsaved buffers section
            vim.api.nvim_set_hl(0, 'MiniStatuslineUnsaved', { bg = '#d6bd7c', fg = '#000000' })

            -- Removed fileinfo section which contains the file size
            local location = MiniStatusline.section_location { trunc_width = 75 }
            local unsaved = get_unsaved_buffers()

            -- vim.api.nvim_buf_get_name(0) gets the full path of the current buffer (0 means current)
            -- vim.fn.fnamemodify(..., ':t') extracts the filename (tail) from the path
            local current_filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')

            -- Create groups array with main components
            local groups = {
              { hl = 'MiniStatuslineDevinfo', strings = { git } },
              { hl = 'MiniStatuslineBody', strings = { ' ' .. current_filename .. ' ' } },
              '%=',
              { hl = 'MiniStatuslineLocation', strings = { location } },
            }

            -- Only add unsaved buffers section if count is greater than 0
            if unsaved > 0 then
              table.insert(groups, { hl = 'MiniStatuslineUnsaved', strings = { string.format(' Unsaved: %d ', unsaved) } })
            end

            return MiniStatusline.combine_groups(groups)
          end,
        },
      }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      local MiniTabLine = require 'mini.tabline'
      local helper = MiniTabLine.helper

      MiniTabLine.config = {
        format = function(buf_id, label)
          local tabname = ''
          local separator = '|'
          if helper.get_icon == nil then
            tabname = string.format(' %s ', label)
          else
            tabname = string.format(' %s %s ', helper.get_icon(vim.api.nvim_buf_get_name(buf_id)), label)
          end
          return tabname .. separator
        end,
      }

      MiniTabLine.setup()
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'typescript',
        'javascript',
        'vue',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true

      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = '<PageUp>',
          scope_incremental = 'grc',
          node_decremental = '<PageDown>',
        },
      }

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },

  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

require 'custom.keybinds.init'

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.api.nvim_buf_set_name(0, 'Quick-fix')
  end,
})

require 'custom.commands.presentation'
require 'custom.commands.fix_quickfix'

local buffer_coloring = require 'custom.commands.buffer_color'
buffer_coloring.setup()
local stickies = require 'custom.commands.sticky_notes_float'
stickies.setup()
