-- Neovim config (kshksdrt)
-- init.lua holds options, base keymaps and the lazy.nvim bootstrap.
-- Everything else lives under lua/{plugins,keymaps,commands,utils}/.

-- Leader keys. Must be set before plugins load, or they bind the old leader.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Gates nerd-font glyphs throughout the config.
vim.g.have_nerd_font = true

local platform_utils = require 'utils.platform'
if platform_utils.is_windows() then
  vim.opt.shell = 'pwsh'
  vim.opt.shellcmdflag = '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
else
  vim.opt.shell = 'fish'
end

if vim.g.neovide then
  vim.opt.title = true
  vim.opt.titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' - Neovide'

  vim.opt.linespace = 2

  -- Skia's defaults (0.0/0.5) thicken glyph stems; these match Alacritty's rendering
  vim.g.neovide_text_gamma = 0.9
  vim.g.neovide_text_contrast = 0.1

  vim.g.neovide_progress_bar_enabled = true
  vim.g.neovide_progress_bar_height = 5.0
  vim.g.neovide_progress_bar_animation_speed = 200.0
  vim.g.neovide_progress_bar_hide_delay = 0.2

  -- vim.g.neovide_scroll_animation_length = 0.2 -- Default is good enough
  vim.g.neovide_cursor_animation_length = 0 -- Cursor position animation
  vim.g.neovide_position_animation_length = 0 -- Window position animation

  vim.g.neovide_refresh_rate = 144

  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_antialiasing = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_animate_in_insert_mode = false

  vim.g.neovide_hide_mouse_when_typing = true

  vim.g.neovide_floating_blur_amount_x = 0
  vim.g.neovide_floating_blur_amount_y = 0

  vim.g.neovide_floating_shadow = false
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 0

  vim.g.neovide_opacity = 1
  vim.g.neovide_normal_opacity = 1
end

-- Options. See `:help option-list`.

vim.o.number = true
vim.o.relativenumber = false

vim.opt.wrap = false
vim.keymap.set('n', 'gz', ':set wrap!<CR>', { noremap = true, silent = true, desc = 'Toggle line wrapping' })

-- Keep 10 lines of context above and below the cursor.
vim.opt.scrolloff = 10

vim.o.mouse = 'a'

-- The mode already shows in the statusline.
vim.o.showmode = false

-- Overridden further down: mini.tabline forces showtabline=2 and renders the
-- breadcrumb there. Left at 0 as the fallback if that block ever goes away.
vim.o.showtabline = 0

-- One global statusline instead of one per split. mini.statusline handles this
-- and always renders the focused window's section.
vim.o.laststatus = 3

-- Share the OS clipboard. Deferred, because setting it costs startup time.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.o.undofile = true

-- Case-insensitive search, unless the pattern has a capital or \C.
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Don't redraw while executing macros.
vim.opt.lazyredraw = true

vim.o.splitright = true
vim.o.splitbelow = true

-- Show whitespace.
vim.o.list = true
vim.opt.listchars = {
  tab = '· ',
  trail = '·',
  nbsp = '␣',
}

-- Live preview of :s substitutions in a split.
vim.o.inccommand = 'split'
vim.o.cursorline = true

-- Disable netrw; snacks.explorer replaces it (lua/plugins/snacks.lua).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Opening a directory would leave an empty directory buffer behind. Close it.
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.isdirectory(vim.fn.expand '%') == 1 then
      vim.cmd 'bd'
    end
  end,
})

-- Prompt to save instead of failing, on `:q` with unsaved changes.
vim.o.confirm = true

-- Base keymaps. The rest live under lua/keymaps/.

-- Clear search highlight.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic [Q]uickfix list' })

-- Easier to reach than the built-in <C-\><C-n>. Some terminals swallow it.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Quickfix list navigation
vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz', { desc = 'Go to the next quickfix item' })
vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz', { desc = 'Go to the previous quickfix item' })

-- Shell tools
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

-- Off: many terminals either collide with these or can't send them distinctly.
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Briefly highlight yanked text.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('yank-highlight', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Bootstrap lazy.nvim. See https://github.com/folke/lazy.nvim
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

-- Plugins. `:Lazy` for status, `:Lazy update` to update.
require('lazy').setup({
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  { -- Popup listing the keybinds that can follow what you've typed.
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      -- Milliseconds before the popup opens. Independent of 'timeoutlen'.
      delay = 500,
      preset = 'helix',
      icons = {
        mappings = vim.g.have_nerd_font,
        separator = '',
        -- Empty table = which-key's own nerd-font icons. The fallback spells the keys out.
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

  -- LSP
  {
    -- Teaches lua_ls about the Neovim API, runtime and installed plugins.
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
    -- Main LSP configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Installs servers and tools. Must load before anything that depends on it.
      {
        'mason-org/mason.nvim',
        version = '^1.0.0',
        opts = {
          registries = {
            'github:mason-org/mason-registry',
            'github:Crashdummyy/mason-registry',
          },
        },
      },
      -- No `mason-lspconfig` on purpose. Servers are enabled through `vim.lsp` at
      -- the end of this block, and mason-tool-installer gets real Mason package
      -- names, so its lspconfig-name <-> package-name table is not needed.
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
        'saghen/blink.cmp',
        branch = 'v1',
        lazy = false,
        dependencies = {
          'rafamadriz/friendly-snippets', -- optional: provides snippets for the snippet source
          'xzbdmw/colorful-menu.nvim',
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
          keymap = {
            -- Other presets: 'super-tab', 'enter'. See `:h blink-cmp-config-keymap`.
            preset = 'default',
          },

          completion = {
            menu = {
              auto_show = true,
              draw = {
                -- No label_description column: colorful-menu folds it into label.
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

            documentation = {
              auto_show = true,
              auto_show_delay_ms = 500,
              window = {
                border = 'single',
              },
            },
          },

          sources = {
            default = { 'snippets', 'lsp', 'path', 'buffer' },

            providers = {
              cmdline = {
                min_keyword_length = function(ctx)
                  -- Only complete a bare command name once 3 characters are typed.
                  if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then
                    return 3
                  end
                  return 0
                end,
              },
            },
          },

          cmdline = {
            keymap = {
              preset = 'inherit',
            },
            completion = {
              menu = {
                auto_show = true,
                min_keyword_length = 3,
              },
            },
          },

          appearance = {
            -- 'mono' for Nerd Font Mono, 'normal' for Nerd Font. Aligns icon spacing.
            nerd_font_variant = 'mono',
          },

          signature = {
            enabled = true,
            window = {
              border = 'single',
            },
          },
        },
        -- Lets other specs append to enabled_providers instead of redefining it.
        opts_extend = {
          'sources.completion.enabled_providers',
        },
      },

      -- LSP progress notifications.
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function(_, opts)
      -- Runs once per client, every time a server attaches to a buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          -- Buffer-local mapping helper: sets mode, buffer and description for us.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Wrap an LSP "locations" method so its results land in a named quickfix
          -- list. The symbol is captured before the async request returns and baked
          -- into the title, so `:chistory` and the Snacks history picker read
          -- "References: my_function" rather than a bare "References".
          --
          --   needs_context = true  -> references(context, opts)
          --   needs_context = false -> definition/implementation/type_definition(opts)
          local function lsp_qf(label, fn, needs_context)
            return function()
              local symbol = vim.fn.expand '<cword>'

              -- Show a statusline indicator while the request is in flight; the
              -- LSP-activity section of mini.statusline's content() renders it.
              -- The token guards against a request that never completes: it can
              -- neither linger nor clear a newer request's indicator.
              _G.LspActivityToken = (_G.LspActivityToken or 0) + 1
              local token = _G.LspActivityToken
              _G.LspActivity = label
              vim.cmd 'redrawstatus'
              local function clear_activity()
                if _G.LspActivityToken == token then
                  _G.LspActivity = nil
                  vim.cmd 'redrawstatus'
                end
              end
              vim.defer_fn(clear_activity, 15000) -- safety net if the server never responds

              local opts = {
                on_list = function(t)
                  clear_activity()
                  -- ' ' (space) action pushes a NEW list onto the stack -> history.
                  vim.fn.setqflist({}, ' ', {
                    title = ('%s: %s'):format(label, symbol),
                    items = t.items,
                    context = { time = os.time(), lsp = t.context },
                  })
                  if #t.items == 1 then
                    vim.cmd.cfirst() -- jump straight to a lone result
                  else
                    vim.cmd 'botright copen'
                  end
                end,
              }
              if needs_context then
                fn(nil, opts)
              else
                fn(opts)
              end
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local Methods = vim.lsp.protocol.Methods

          -- Bind only if the attaching client implements the method. LspAttach fires
          -- once per client, so the real server still installs these when it arrives.
          -- Without the guard, copilot.lua's client (started on InsertEnter, often
          -- first in a large TS project) claimed `gd` and warned that definition was
          -- unsupported until the TS server caught up.
          local function map_if(method, keys, func, desc, mode)
            if client and client:supports_method(method, event.buf) then
              map(keys, func, desc, mode)
            end
          end

          -- Goto navigation, overriding the built-in gr* defaults with versions
          -- that produce titled quickfix lists.
          map_if(Methods.textDocument_definition, 'gd', lsp_qf('Definitions', vim.lsp.buf.definition, false), '[G]oto [D]efinition')
          map_if(Methods.textDocument_references, 'grr', lsp_qf('References', vim.lsp.buf.references, true), '[G]oto [R]eferences')
          map_if(Methods.textDocument_implementation, 'gri', lsp_qf('Implementations', vim.lsp.buf.implementation, false), '[G]oto [I]mplementation')
          map_if(Methods.textDocument_typeDefinition, 'grt', lsp_qf('Type Definitions', vim.lsp.buf.type_definition, false), '[G]oto [T]ype Definition')

          -- Rename the symbol under your cursor (most servers do this across files).
          map_if(Methods.textDocument_rename, '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame Symbol')
          map_if(Methods.textDocument_rename, '<F2>', vim.lsp.buf.rename, 'Rename Symbol')

          -- Code action. Cursor usually needs to be on an error/suggestion.
          map_if(Methods.textDocument_codeAction, '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- Declaration, not definition. In C this lands in the header.
          map_if(Methods.textDocument_declaration, 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Disabled: highlight other references to the word under the cursor once
          -- it rests there, and clear them when it moves. See `:help CursorHold`.
          -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          --   local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          --     buffer = event.buf,
          --     group = highlight_augroup,
          --     callback = vim.lsp.buf.document_highlight,
          --   })
          --
          --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          --     buffer = event.buf,
          --     group = highlight_augroup,
          --     callback = vim.lsp.buf.clear_references,
          --   })
          --
          --   vim.api.nvim_create_autocmd('LspDetach', {
          --     group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
          --     callback = function(event2)
          --       vim.lsp.buf.clear_references()
          --       vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
          --     end,
          --   })
          -- end

          -- Toggle inlay hints where the server supports them.
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Signature
      vim.keymap.set('i', '<C-s>', function()
        vim.lsp.buf.signature_help {
          border = 'single',
          max_height = 25,
          max_width = 120,
        }
      end, {
        desc = 'Show signature help',
      })

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

      vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover {
          border = 'single',
          max_height = 25,
          max_width = 120,
        }
      end, {
        desc = 'Hover documentation',
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

      -- Also exports `$MASON`, which the vue plugin path below relies on.
      require('mason').setup()

      -- Ships inside the `vue-language-server` Mason package. Loaded into `ts_ls`
      -- below as a tsserver plugin, so `vue_ls` can run in hybrid mode.
      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vim.fn.expand '$MASON/packages/vue-language-server/node_modules/@vue/language-server',
        languages = { 'vue' },
        configNamespace = 'typescript',
      }

      -- Filetypes owned by whichever JS/TS server is selected. `vue` is absent on
      -- purpose: it always belongs to `ts_ls`, never `tsgo`. The `:TsServer` toggle
      -- at the end of this block reassigns this list, so keep it the only copy.
      local ts_filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }

      -- Keys are lspconfig server names (`:help lspconfig-all`). Everything listed
      -- here is configured and enabled at the bottom of this block. Mason package
      -- names are a separate namespace, handled by mason-tool-installer below --
      -- formatters and linters belong there, not here.
      local servers = {
        -- C/C++/ObjC/CUDA, using the *system* clangd rather than a Mason copy so it
        -- shares the resource dir and GCC headers the local compiler uses. A Mason
        -- clangd on an older LLVM drifts from those and invents errors in system
        -- headers. Hence no `clangd` under mason-tool-installer below.
        -- Root markers, utf-8 offset negotiation and the `:LspClangd*` commands all
        -- come from nvim-lspconfig's `lsp/clangd.lua`.
        clangd = {
          -- The only flag that differs from clangd 22's defaults. Background indexing,
          -- clang-tidy, iwyu header insertion, detailed completion and `.clangd`
          -- reading are already on; repeating them here would only rot.
          -- `memory` trades RAM for faster reparses; drop it if a big C++ tree gets heavy.
          cmd = { 'clangd', '--pch-storage=memory' },
          init_options = {
            -- Only for files with no `compile_commands.json` entry: scratch files,
            -- single-file programs, headers outside the build. Language-neutral,
            -- since this server also owns C++ and a `-std=` would break one of the
            -- two. Per-project flags belong in `.clangd` / `compile_flags.txt`.
            fallbackFlags = { '-Wall', '-Wextra' },
          },
        },

        gopls = {
          cmd = { 'gopls' },
        },

        -- pyright = {},

        -- rust_analyzer = {},

        -- TypeScript 7 (`typescript-go`), the Go port of tsserver, and the default
        -- owner of `ts_filetypes`. Coverage is still partial and it cannot load
        -- tsserver plugins, which is why `ts_ls` below stays around for Vue.
        -- Defaults come from nvim-lspconfig's `lsp/tsgo.lua`.
        tsgo = { filetypes = ts_filetypes },

        -- Always owns Vue, as the carrier of `@vue/typescript-plugin`. `vue_ls` runs
        -- in hybrid mode: it owns the template/style blocks and forwards
        -- `tsserver/request` to the attached TS client, and only `ts_ls` can load
        -- that plugin. The forwarding handler ships with nvim-lspconfig, so no
        -- `on_init` here. Also takes `ts_filetypes` when `:TsServer` picks it.
        -- See https://github.com/vuejs/language-tools/wiki/Neovim
        ts_ls = {
          filetypes = { 'vue' },
          init_options = {
            plugins = { vue_plugin },
          },
          on_attach = function(client, bufnr)
            -- vue_ls supplies semantic tokens for .vue files, so let it win there and
            -- keep them elsewhere. Read the filetype from `bufnr`, not the current
            -- buffer: `:TsServer` re-attaches buffers that may not be focused.
            local caps = client.server_capabilities
            if caps.semanticTokensProvider then
              caps.semanticTokensProvider.full = vim.bo[bufnr].filetype ~= 'vue'
            end
            -- Formatting and highlighting come from conform.nvim (prettier) and treesitter.
            caps.documentFormattingProvider = nil
            caps.documentHighlightProvider = nil
          end,
        },

        vue_ls = {},

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- Uncomment to silence lua_ls's noisy `missing-fields` warnings.
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        -- Configured and enabled by roslyn.nvim itself; this only layers on settings.
        -- NOTE: duplicated by the `opts` in lua/plugins/lsps.lua. Change both, or drop one.
        roslyn = {
          ['csharp|formatting'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            indent_style = 'space',
            indent_size = 4,
            tab_width = 4,
          },
          ['csharp|code_style'] = {
            formatting = {
              indent_style = 'space',
              indent_size = 4,
            },
          },
          ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = false,
          },
        },

        markdown_oxide = {},

        rust_analyzer = {
          settings = {
            checkOnSave = true,
            check = {
              command = 'check',
              extraArgs = { '--jobs=2' },
            },
            cargo = {
              buildScripts = {
                enable = false,
              },
            },
            procMacro = {
              enable = true,
            },
          },
        },

        tinymist = {
          settings = {
            formatterMode = 'typstyle',
            exportPdf = 'never',
          },
        },
      }

      -- Mason package names; browse them with `:Mason`. Spelled out rather than
      -- derived from `servers`, because the two namespaces don't line up: `ts_ls`
      -- ships as `typescript-language-server`, and formatters have no server entry
      -- at all. A translation table goes stale; real package names cannot.
      require('mason-tool-installer').setup {
        ensure_installed = {
          -- Language servers. `clangd` is absent on purpose -- it comes from the
          -- system clang install; see its entry in `servers` above.
          'gopls',
          'lua-language-server',
          'markdown-oxide',
          'roslyn',
          'rust-analyzer',
          'tinymist',
          'tsgo', -- TypeScript 7 / @typescript/native-preview
          'typescript-language-server', -- `ts_ls`, Vue only
          'vue-language-server',
          -- Formatters
          'csharpier',
          'prettier',
          'prettierd',
          'stylua',
        },
      }

      -- `servers` is the single source of truth for what runs: exactly what is listed
      -- there gets enabled, nothing else. The old mason-lspconfig handler instead
      -- started whatever happened to be installed in Mason.
      for name, server in pairs(servers) do
        server.capabilities = require('blink.cmp').get_lsp_capabilities(server.capabilities)
        vim.lsp.config(name, server)
      end
      vim.lsp.enable(vim.tbl_keys(servers))

      -- `:TsServer [tsgo|ts_ls]` picks the server for `ts_filetypes`. No argument
      -- toggles; naming the current one restarts it. Vue always stays with `ts_ls`.
      local ts_selected = 'tsgo' -- owner of `ts_filetypes` right now

      local function select_ts_server(name)
        ts_selected = name

        -- Stop both servers' clients, remembering where they were so we can re-attach.
        local buffers, stopping = {}, {}
        for _, client in ipairs(vim.lsp.get_clients()) do
          if client.name == 'tsgo' or client.name == 'ts_ls' then
            for buf in pairs(client.attached_buffers) do
              buffers[buf] = true
            end
            client:stop()
            stopping[#stopping + 1] = client
          end
        end

        if name == 'tsgo' then
          vim.lsp.config('ts_ls', { filetypes = { 'vue' } })
          vim.lsp.enable 'tsgo'
        else
          vim.lsp.enable('tsgo', false)
          vim.lsp.config('ts_ls', { filetypes = vim.list_extend({ 'vue' }, ts_filetypes) })
        end

        -- Re-attach only once the old clients are fully down. Firing FileType while
        -- one is still shutting down hands the buffer back to the dying client.
        local timer = assert(vim.uv.new_timer())
        timer:start(
          100,
          100,
          vim.schedule_wrap(function()
            for _, client in ipairs(stopping) do
              if not client:is_stopped() then
                return
              end
            end
            timer:close()
            for buf in pairs(buffers) do
              if vim.api.nvim_buf_is_loaded(buf) then
                vim.api.nvim_exec_autocmds('FileType', { buffer = buf, modeline = false })
              end
            end
            vim.notify('JS/TS language server: ' .. name)
          end)
        )
      end

      vim.api.nvim_create_user_command('TsServer', function(opts)
        select_ts_server(opts.args ~= '' and opts.args or (ts_selected == 'tsgo' and 'ts_ls' or 'tsgo'))
      end, {
        nargs = '?',
        desc = 'Switch the JS/TS language server between tsgo and ts_ls (restarts if already selected)',
        complete = function()
          return { 'tsgo', 'ts_ls' }
        end,
      })
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>tF',
        function()
          if vim.g.disable_autoformat then
            vim.cmd 'FormatEnable'
            vim.notify 'Enabled autoformat globally'
          else
            vim.cmd 'FormatDisable'
            vim.notify 'Disabled autoformat globally'
          end
        end,
        desc = '[T]oggle [F]ormatting globally',
      },
      {
        '<leader>tf',
        function()
          if vim.b.disable_autoformat then
            vim.cmd 'FormatEnable'
            vim.notify 'Enabled autoformat for current buffer'
          else
            vim.cmd 'FormatDisable!'
            vim.notify 'Disabled autoformat for current buffer'
          end
        end,
        desc = '[T]oggle [F]ormatting for current buffer',
      },
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
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Skip format-on-save for languages with no well-standardized style. `c` is
        -- deliberately not in this list: clangd formats it with its embedded
        -- clang-format, honouring the project's `.clang-format` and falling back to
        -- LLVM style. Nothing in `formatters_by_ft` claims `c`, so it goes through
        -- the `lsp_format = 'fallback'` below.
        local disable_filetypes = { cpp = true }
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
    config = function(_, opts)
      require('conform').setup(opts)

      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          vim.b.disable_autoformat = true -- `:FormatDisable!` -- this buffer only
        else
          vim.g.disable_autoformat = true -- `:FormatDisable` -- globally
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })

      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
    end,
  },

  { -- Colorscheme. Loads first (priority), then kanagawa in lua/plugins/theme.lua
    -- loads later and wins; this is the fallback if that spec ever goes away.
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }

      -- Other styles: tokyonight-storm, -moon, -day.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    version = '*',
    dependencies = {
      'kshksdrt/mini-tabline-colorizer',
    },
    config = function()
      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }

      -- Around/inside textobjects: `va)`, `yinq`, `ci'`.
      require('mini.ai').setup { n_lines = 500 }

      -- Every mapping is cleared: nvim-surround (lua/plugins/init.lua) owns the
      -- surround keys instead.
      require('mini.surround').setup {
        mappings = {
          add = '',
          delete = '',
          find = '',
          find_left = '',
          highlight = '',
          replace = '',
          update_n_lines = '',
        },
      }

      -- Statusline. Sections are assembled in the content function further down.
      local statusline = require 'mini.statusline'

      -- Shared bg for every MiniStatuslineBreadcrumb* group.
      local BREADCRUMB_BG = '#2d2d2d'

      -- fg source per breadcrumb kind: treesitter capture first, else base syntax group.
      --stylua: ignore
      local BREADCRUMB_KIND_HL_SOURCES = {
        Function    = { '@function', 'Function' },
        Method      = { '@function.method', 'Function' },
        Constructor = { '@constructor', 'Special' },
        Class       = { '@type', 'Type' },
        Struct      = { '@type', 'Type' },
        Interface   = { '@type', 'Type' },
        Enum        = { '@type', 'Type' },
        Module      = { '@module', 'Include' },
        Field       = { '@property', 'Identifier' },
        Property    = { '@property', 'Identifier' },
        Variable    = { '@variable', 'Identifier' },
        Constant    = { '@constant', 'Constant' },
      }

      -- 1. Colors
      local function set_statusline_highlights()
        vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { bg = '#a8a8a8', fg = '#000000' })
        vim.api.nvim_set_hl(0, 'MiniStatuslineBody', { bg = '#444444', fg = '#ffffff' })
        vim.api.nvim_set_hl(0, 'MiniStatuslineUnsaved', { bg = '#d6bd7c', fg = '#000000' })
        vim.api.nvim_set_hl(0, 'MiniStatuslineLspActivity', { bg = '#00af00', fg = '#000000', bold = true })
        vim.api.nvim_set_hl(0, 'MiniStatuslineQuickfix', { bg = '#5fafd7', fg = '#000000' })
        -- Muted red on the body bg, so the error count reads as a quiet annotation
        -- rather than an alert block like the Unsaved/LspActivity sections.
        vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnosticError', { bg = '#444444', fg = '#af8787' })
        -- The filepath splits into dim dir + bright filename on one shared bg, so
        -- the segment stays continuous. Built by file_path_segment() below.
        vim.api.nvim_set_hl(0, 'MiniStatuslinePath', { bg = '#444444', fg = '#bcbcbc' })
        vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { bg = '#444444', fg = '#ffffff', bold = true })

        -- MiniStatuslineBreadcrumbFile (the tabline filename chip) is owned by
        -- mini-tabline-colorizer, which sets its per-buffer bg + contrast fg.
        vim.api.nvim_set_hl(0, 'MiniStatuslineBreadcrumbSep', { bg = BREADCRUMB_BG, fg = '#7a7a7a' })
        for kind, sources in pairs(BREADCRUMB_KIND_HL_SOURCES) do
          local fg
          for _, group in ipairs(sources) do
            fg = vim.api.nvim_get_hl(0, { name = group, link = false }).fg
            if fg then
              break
            end
          end
          vim.api.nvim_set_hl(0, 'MiniStatuslineBreadcrumb' .. kind, {
            bg = BREADCRUMB_BG,
            fg = fg and string.format('#%06x', fg),
          })
        end
      end

      set_statusline_highlights()

      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = set_statusline_highlights,
      })

      -- 2. Unsaved count
      local unsaved_count = 0

      local function update_unsaved_count()
        local count = 0
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
            if vim.bo[bufnr].modified then
              count = count + 1
            end
          end
        end
        unsaved_count = count
      end

      local group = vim.api.nvim_create_augroup('MiniStatuslineUnsaved', { clear = true })
      -- 'modified' is watched through OptionSet: Neovim removed BufModifiedSet (see
      -- `:h deprecated.txt`). OptionSet matches the option name via `pattern`, so it
      -- can't share the '*' pattern of the buffer events below.
      vim.api.nvim_create_autocmd('OptionSet', {
        group = group,
        pattern = 'modified',
        callback = update_unsaved_count,
      })
      -- BufDelete fires before the buffer leaves the list, so an inline recount
      -- still counts it. Defer to the next tick, when the list has settled, and
      -- coalesce the burst a bulk delete produces (Snacks.bufdelete.all() fires one
      -- per buffer). Nothing else redraws the widget, hence the redrawstatus.
      local recount_pending = false
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufDelete' }, {
        group = group,
        callback = function()
          if recount_pending then
            return
          end
          recount_pending = true
          vim.schedule(function()
            recount_pending = false
            update_unsaved_count()
            vim.cmd.redrawstatus { bang = true }
          end)
        end,
      })
      update_unsaved_count()

      -- Maps a treesitter node type to a blink.cmp kind_icons key by substring.
      --stylua: ignore
      local ts_type_blink_kinds = {
        { 'class',       'Class' },
        { 'struct',      'Struct' },
        { 'interface',   'Interface' },
        { 'enum',        'Enum' },
        { 'namespace',   'Module' },
        { 'module',      'Module' },
        { 'impl',        'Struct' },
        { 'constructor', 'Constructor' },
        { 'method',      'Method' },
        { 'function',    'Function' },
        { 'field',       'Field' },
        { 'property',    'Property' },
        { 'variable',    'Variable' },
        { 'constant',    'Constant' },
      }

      local function blink_kind_for_node_type(node_type)
        for _, pair in ipairs(ts_type_blink_kinds) do
          if node_type:find(pair[1], 1, true) then
            return pair[2]
          end
        end
        return nil
      end

      -- nf-fa-caret_right, falling back to a plain '^' without a nerd font.
      local ts_breadcrumb_caret = vim.g.have_nerd_font and '\u{f0da}' or '^'

      -- Breadcrumb: filename + the cursor's enclosing symbols, as one raw
      -- pre-highlighted string (combine_groups() would double-pad the groups).
      -- Returns nil for unnamed buffers; the caller falls back to the cwd.
      local function ts_breadcrumb()
        local bufnr = vim.api.nvim_get_current_buf()
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname == '' then
          return nil
        end
        local filename = vim.fn.fnamemodify(bufname, ':t')

        -- mini-tabline-colorizer owns the chip's colors (see its setup below), so
        -- only the glyph is taken from mini.icons; its filetype color is discarded.
        local file_icon = require('mini.icons').get('file', filename)
        local segments = {
          { hl = 'MiniStatuslineBreadcrumbFile', icon = file_icon, name = filename },
        }

        local parser = vim.treesitter.get_parser(bufnr)
        if parser then
          parser:parse() -- cheap no-op if the tree is already up to date

          -- Live config, so a future kind_icons change stays in sync.
          local kind_icons = require('blink.cmp.config').appearance.kind_icons

          local node = vim.treesitter.get_node()
          local ts_segments = {}
          while node do
            local name_node = node:field('name')[1]
            if name_node then
              local kind = blink_kind_for_node_type(node:type())
              table.insert(ts_segments, 1, {
                hl = kind and ('MiniStatuslineBreadcrumb' .. kind) or 'MiniStatuslineBreadcrumbSep',
                icon = kind and kind_icons[kind],
                name = vim.treesitter.get_node_text(name_node, 0),
              })
            end
            node = node:parent()
          end
          for _, seg in ipairs(ts_segments) do
            table.insert(segments, seg)
          end
        end

        -- Truncate symbols past 24 chars, except the last 2 (the innermost, most
        -- relevant scopes). The filename chip (segment 1) always shows in full.
        for i = 2, #segments - 2 do
          local name = segments[i].name
          if #name > 24 then
            segments[i].name = name:sub(1, 23) .. '…'
          end
        end

        -- Leading space goes right after each %#Group# switch, not before.
        local chunks = {}
        for i, seg in ipairs(segments) do
          if i > 1 then
            table.insert(chunks, '%#MiniStatuslineBreadcrumbSep# ' .. ts_breadcrumb_caret)
          end
          local text = (seg.icon and vim.g.have_nerd_font) and (seg.icon .. ' ' .. seg.name) or seg.name
          local chunk = '%#' .. seg.hl .. '# ' .. text
          -- The filename chip is the only segment with its own bg, so it needs a
          -- trailing space to match its leading one and read as a pill.
          if i == 1 then
            chunk = chunk .. ' '
          end
          table.insert(chunks, chunk)
        end
        return table.concat(chunks) .. ' '
      end

      -- Filename + cwd-relative path as one raw highlighted string: bright filename,
      -- dim path, both on the body bg. Deliberately plain, with no per-buffer tint --
      -- the colorful breadcrumb drives the tabline instead (see the block below).
      -- Path bg == body bg, so the trailing group bleeds harmlessly across '%='.
      local function file_path_segment()
        local bufpath = vim.api.nvim_buf_get_name(0)
        if bufpath == '' then
          return '%#MiniStatuslineBody# [No Name] '
        end
        local label = vim.fn.fnamemodify(bufpath, ':t')
        -- ':.' is cwd-relative; paths outside the cwd stay absolute.
        local shown_path = vim.fn.fnamemodify(bufpath, ':.')
        return string.format('%%#MiniStatuslineFilename# %s %%#MiniStatuslinePath#%s ', label, shown_path)
      end

      -- 3. Statusline config
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local git = MiniStatusline.section_git { trunc_width = 75, bold = false }

            local location = MiniStatusline.section_location { trunc_width = 75 }

            local position_group = file_path_segment()

            local status_line_widget_groups = {
              { hl = 'MiniStatuslineDevinfo', strings = { git } },
              position_group,
              '%=',
              { hl = 'MiniStatuslineLocation', strings = { location } },
            }

            -- Error count for the current buffer. Reuses the gutter sign's glyph
            -- (see vim.diagnostic.config above) minus its saturated color, so the
            -- two read as related. Hidden when there are no errors.
            local error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            if error_count > 0 then
              local error_icon = vim.g.have_nerd_font and '' or 'E'
              table.insert(status_line_widget_groups, #status_line_widget_groups, {
                hl = 'MiniStatuslineDiagnosticError',
                strings = { string.format(' %s %d ', error_icon, error_count) },
              })
            end

            -- Quickfix position, e.g. "QF: 2 of 14". idx/size come from the list's
            -- own cursor, which :cnext/:cprev/:cc maintain whether or not the
            -- quickfix window is open. Hidden when the list is empty.
            local qf_info = vim.fn.getqflist { idx = 0, size = 0 }
            if qf_info.size > 0 then
              table.insert(status_line_widget_groups, #status_line_widget_groups, {
                hl = 'MiniStatuslineQuickfix',
                strings = { string.format('QF: %d of %d', qf_info.idx, qf_info.size) },
              })
            end

            -- Tabpage indicator, only meaningful past one tabpage. tabpagenr() is
            -- cheap enough to read live. No "Tab" label: the color below is the cue.
            local n_tabpages = vim.fn.tabpagenr '$'
            if n_tabpages > 1 then
              -- Position 1: leftmost, before the git branch section.
              table.insert(status_line_widget_groups, 1, {
                -- Reuse mini.tabline's own tabpage highlight so the color matches it.
                hl = 'MiniTablineTabpagesection',
                strings = { string.format(' %d/%d ', vim.fn.tabpagenr(), n_tabpages) },
              })
            end

            -- Shown while an async goto/references request is in flight.
            -- _G.LspActivity is set and cleared by lsp_qf() (see LspAttach above)
            -- and holds the label, e.g. "References".
            if _G.LspActivity then
              table.insert(status_line_widget_groups, {
                hl = 'MiniStatuslineLspActivity',
                strings = { string.format(' LSP processing... (%s) ', _G.LspActivity:lower()) },
              })
            end

            if unsaved_count > 0 then
              table.insert(status_line_widget_groups, {
                hl = 'MiniStatuslineUnsaved',
                strings = { string.format(' Unsaved: %d ', unsaved_count) },
              })
            end

            return MiniStatusline.combine_groups(status_line_widget_groups)
          end,
        },
      }

      -- Cursor location as LINE:COLUMN.
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- The tabline shows ts_breadcrumb() instead of the buffer list; the
      -- statusline took over the filename + path. setup() still runs for its
      -- highlight groups, its ColorScheme refresh and showtabline=2.
      -- To drop the tabline, delete this block and leave 'showtabline' at 0.
      require('mini.tabline').setup()
      _G.MiniTablineBreadcrumb = function()
        -- Unnamed buffers fall back to the cwd name. ts_breadcrumb() leaves its
        -- last highlight group open, so it fills the rest of the bar.
        return ts_breadcrumb() or ('%#MiniStatuslinePath# ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t'))
      end
      vim.o.tabline = '%!v:lua.MiniTablineBreadcrumb()'

      -- The breadcrumb tracks the cursor, but the tabline (unlike the statusline)
      -- isn't redrawn on cursor movement, so ask for it. Same per-move cost the
      -- statusline paid while it hosted the breadcrumb.
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = vim.api.nvim_create_augroup('BreadcrumbTablineRedraw', { clear = true }),
        callback = function()
          vim.cmd 'redrawtabline'
        end,
      })

      -- Tint the tabline's filename chip per buffer: bg hashed from the buffer
      -- path, fg auto-contrast. The only group this owns; ts_breadcrumb() no
      -- longer sets MiniStatuslineBreadcrumbFile itself.
      require('mini-tabline-colorizer').setup {
        saturation = 0.6,
        brightness = 0.4,
        colored_groups = {
          'MiniStatuslineBreadcrumbFile',
        },
        linked_groups = {},
        flash_ms = 150,
      }
    end,
  },

  {
    'saghen/blink.indent',
    --- @module 'blink.indent'
    --- @type blink.indent.Config
    config = function()
      local indent = require 'blink-indent'
      indent.setup {
        blocked = {
          -- default: 'terminal', 'quickfix', 'nofile', 'prompt'
          buftypes = { include_defaults = true },
          -- default: 'lspinfo', 'packer', 'checkhealth',
          -- 'help', 'man', 'gitcommit', 'dashboard', ''
          filetypes = { include_defaults = true },
        },
        static = {
          enabled = true,
          char = '▎',
          priority = 1,
          -- Several highlights here would give rainbow-style guides:
          -- highlights = {
          --   'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow',
          --   'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan'
          -- },
          highlights = { 'BlinkIndent' },
        },
        scope = {
          enabled = true,
          char = '▎',
          priority = 1000,
          -- A single highlight (e.g. 'BlinkIndentScope') turns the rainbow off.
          -- Also available: BlinkIndentRed/Cyan/Yellow/Green.
          highlights = {
            'BlinkIndentCyan',
          },

          -- Underline the line above the current scope.
          underline = {
            enabled = false,
            -- Also available: BlinkIndentRed/Cyan/Yellow/GreenUnderline.
            highlights = {
              'BlinkIndentOrangeUnderline',
              'BlinkIndentVioletUnderline',
              'BlinkIndentBlueUnderline',
            },
          },
        },
      }

      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          vim.api.nvim_set_hl(0, 'BlinkIndent', {
            fg = '#2B2B2B',
            nocombine = false,
          })
        end,
      })
    end,
  },
  -- Imports every spec in lua/plugins/. Add a plugin by dropping a file there.
  { import = 'plugins' },
}, {
  ui = {
    -- Empty table = lazy.nvim's own nerd-font icons. The fallback is plain unicode.
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

require 'keymaps'

-- Name the quickfix buffer, so it reads as "Quick-fix" in buffer lists.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.api.nvim_buf_set_name(0, 'Quick-fix')
  end,
})

require 'commands.presentation'
require 'commands.fix_quickfix'
require 'commands.cmd'
require 'commands.markdown'
require 'commands.pandoc'
require 'commands.line'

local stickies = require 'commands.sticky_notes_float'
stickies.setup()

-- vim: ts=2 sts=2 sw=2 et
