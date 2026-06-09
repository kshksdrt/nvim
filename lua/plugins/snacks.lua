return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = function()
    -- Toggle the profiler
    Snacks.toggle.profiler():map '<leader>sx'
    -- Toggle the profiler highlights
    Snacks.toggle.profiler_highlights():map '<leader>sy'

    return {
      notifier = {
        enabled = true,
        style = 'compact',

        -- "false" makes the list grow from the bottom up
        top_down = false,

        -- Optional: Add a small margin so it doesn't touch the statusline
        margin = {
          bottom = 1,
          right = 1,
        },
      },
      input = {
        enabled = true,
        icon = '',
        win = {
          relative = 'cursor',
          border = 'single',
          input = {
            keys = {
              -- This ensures specific key handling for the input window
              n_esc = { '<Esc>', { 'cmp_close', 'cancel' }, mode = 'n', desc = 'Close Input' },
              i_esc = { '<Esc>', { 'cmp_close', 'cancel' }, mode = 'i', desc = 'Close Input' },
            },
          },
        },
      },
      dashboard = {
        -- preset = {
        --   -- This preset automatically adds the "Restore Session" section
        --   -- if persistence.nvim is installed
        --   keys = {
        --     { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
        --     -- ... other keys
        --   },
        -- },
        sections = {
          -- { section = "header" }, -- <--- I commented this out to remove the logo/text
          {
            section = 'keys',
            gap = 1,
            padding = 1,
          },
          {
            pane = 2,
            icon = ' ',
            title = 'Recent Files',
            section = 'recent_files',
            indent = 2,
            padding = 1,
          },
          -- { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
          {
            section = 'startup',
          },
        },
      },
      explorer = {
        enabled = true,
        replace_netrw = true,
        trash = true,
      },
      picker = {
        actions = {
          -- <c-q>: send to quickfix list, but with a readable title
          qflist = function(picker)
            -- Build a name from the source + whatever you typed, captured
            -- BEFORE the default action runs (it closes the picker).
            local src = (picker.opts and picker.opts.source) or 'picker'
            local title = src:gsub('^%l', string.upper) -- "grep" -> "Grep"

            local f = (picker.input and picker.input.filter) or {}
            local search = (f.search and f.search ~= '' and f.search) or f.pattern
            if search and search ~= '' then
              title = ('%s: %s'):format(title, search)
            end

            -- Let snacks build + open the qf list (correct item formatting).
            Snacks.picker.actions.qflist(picker)

            -- Relabel just the title of the list snacks just created.
            -- 'a' with a `what` dict updates the current list's title and
            -- context(data structure of context should match the context value to the lsp setqflist instance)
            -- without touching its items.
            vim.fn.setqflist({}, 'a', { title = title, context = { time = os.time() } })
          end,
        },
        layout = {
          -- This applies to the preset layouts (like 'default', 'vscode', 'ivy')
          layout = {
            box = 'horizontal',
            row = -1,
            width = 0,
            height = 0.6,
            border = 'none', -- Root border
            {
              box = 'vertical',
              border = 'none',
              {
                win = 'input',
                height = 1,
                title = '{title} {live}',
                title_pos = 'center',
                border = 'single',
              },
              {
                win = 'list',
                border = 'none',
              },
            },
            {
              win = 'preview',
              title = '{preview}',
              border = 'single',
              width = 0.5,
            },
          },
        },
        sources = {
          select = {
            layout = {
              -- "cursor" positions it relative to the current cursor position
              relative = 'cursor',
              width = 80,
              min_width = 80,

              -- Optional: Minimalist border styling
              layout = {
                box = 'vertical',
                backdrop = false, -- Removes the dark background dimming
                width = 80,
                min_width = 80,
                height = 0.4,
                { win = 'input', height = 1, border = 'single' },
                { win = 'list', border = 'single' },
              },
            },
            win = {
              input = {
                keys = { ['<Esc>'] = 'close' },
              },
            },
          },
          explorer = {
            auto_close = true,
            ignored = true,
            hidden = true,
            -- focus = 'input',
            -- start_insert = true,
            prompt = '  ',
            layout = {
              layout = {
                -- Define the vertical layout explicitly
                box = 'vertical',
                position = 'right',
                width = 40,
                -- The input window (search bar) with no border
                {
                  win = 'input',
                  height = 1,
                  border = 'bottom',
                },
                -- The file list window with no border
                {
                  win = 'list',
                  border = 'none',
                },
              },
            },
            win = {
              list = {
                wo = {
                  number = false,
                  relativenumber = false,
                },
              },
            },
            follow_file = true,
          },
          sources = {
            grep = {
              cmd = 'rg',
            },
          },
          notifications = {
            win = {
              input = {
                keys = {},
              },
              list = {
                wo = {
                  wrap = true,
                },
              },
            },
          },
        },
        config = function()
          vim.api.nvim_set_hl(0, 'NonText', {
            fg = '#8F9491',
          })

          -- Short labels for the category prefix. Keys are matched case-insensitively
          -- against the part of the title before the ':'. All values are < 10 chars.
          local CONCISE = {
            -- LSP (from your lsp_qf helper)
            references = 'refs',
            definitions = 'def',
            implementations = 'impl',
            ['type definitions'] = 'typedef',
            declarations = 'decl',
            -- Common snacks sources (from <c-q>)
            grep = 'grep',
            grep_word = 'grepword',
            buffers = 'buf',
            diagnostics = 'diag',
            files = 'files',
            recent = 'recent',
            git_files = 'gitfiles',
            git_status = 'gitstat',
            git_log = 'gitlog',
            lines = 'lines',
            marks = 'marks',
            jumps = 'jumps',
            keymaps = 'keymaps',
            commands = 'cmds',
            help = 'help',
            man = 'man',
            symbols = 'symbols',
            lsp_symbols = 'symbols',
            todo = 'todo',
            spelling = 'spell',
            undo = 'undo',
            loclist = 'loclist',
            qflist = 'qflist',
          }

          local DATE_W = 16 -- width of "%Y-%m-%d %H:%M"
          local PREFIX_W = 8 -- prefix column width (< 10)

          -- Split a title into (concise prefix, remainder).
          local function split_title(title)
            local head, tail = title:match '^([^:]+):%s*(.*)$'
            if head then
              return CONCISE[head:lower()] or head:lower():sub(1, PREFIX_W), tail
            end
            -- No colon: a bare category word gets abbreviated; anything else
            -- (fallback filenames, "(untitled)") shows in full in the rest column.
            local key = title:lower()
            if CONCISE[key] then
              return CONCISE[key], ''
            end
            return '', title
          end

          -- Preview: dump the contents of the highlighted quickfix list.
          local function qf_preview(ctx)
            local qf = vim.fn.getqflist { nr = ctx.item.nr, items = 0 }
            local lines = {}
            for _, e in ipairs(qf.items) do
              local name = e.bufnr > 0 and vim.fn.bufname(e.bufnr) or ''
              name = name ~= '' and vim.fn.fnamemodify(name, ':~:.') or '[No file]'
              local text = (e.text or ''):gsub('^%s+', '')
              lines[#lines + 1] = ('%s|%d col %d| %s'):format(name, e.lnum or 0, e.col or 0, text)
            end
            if #lines == 0 then
              lines = { '(empty list)' }
            end
            ctx.preview:set_lines(lines)
            ctx.preview:set_title(ctx.item.title)
            ctx.preview:highlight { ft = 'qf' }
            return true
          end

          vim.keymap.set('n', '<leader>sQ', function()
            local function qf_time(context)
              if type(context) == 'table' and context.time then
                return os.date('%Y-%m-%d %H:%M', context.time)
              end
            end

            local count = vim.fn.getqflist({ nr = '$' }).nr
            local items = {}
            for nr = count, 1, -1 do -- newest first
              local info = vim.fn.getqflist { nr = nr, title = 0, size = 0, items = 0, context = 0 }
              local title = info.title
              if not title or title == '' or title == ':setqflist()' then
                local first = info.items[1]
                if first and first.bufnr > 0 then
                  title = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(first.bufnr), ':t')
                else
                  title = '(untitled)'
                end
              end
              local prefix, rest = split_title(title)
              table.insert(items, {
                idx = #items + 1,
                nr = nr,
                title = title, -- full title: used for matching + preview
                prefix = prefix,
                rest = rest,
                size = info.size,
                when = qf_time(info.context),
                text = title, -- what the fuzzy matcher searches
              })
            end

            Snacks.picker {
              title = 'QF History',
              items = items,
              preview = qf_preview,
              format = function(item)
                local date = item.when or string.rep(' ', DATE_W)
                local prefix = item.prefix .. string.rep(' ', PREFIX_W - #item.prefix)
                local ret = {
                  { date, 'Comment' },
                  { '  ' },
                  { prefix, 'Identifier' },
                  { '  ' },
                }
                if item.rest ~= '' then
                  ret[#ret + 1] = { item.rest, 'Title' }
                end
                ret[#ret + 1] = { ('  (%d)'):format(item.size), 'Comment' }
                return ret
              end,
              confirm = function(picker, item)
                picker:close()
                vim.cmd(item.nr .. 'chistory')
                vim.cmd 'botright copen'
              end,
            }
          end, { desc = 'Quickfix History (newest first)' })
        end,
      },
    }
  end,
  keys = {
    {
      '<leader>su',
      function()
        Snacks.profiler.scratch()
      end,
      desc = 'Profiler Scratch Bufer',
    },
    {
      '\\',
      function()
        Snacks.explorer()
      end,
      desc = 'Open Explorer',
    },
    {
      '<leader>g',
      function(opts)
        Snacks.lazygit.open(opts)
      end,
      desc = '[G]it: lazygit',
    },
    {
      'gld',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'Goto Definition',
    },
    {
      'glD',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = 'Goto Declaration',
    },
    {
      'glr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = 'References',
    },
    {
      'glI',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = 'Goto Implementation',
    },
    {
      'gly',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = 'Goto T[y]pe Definition',
    },
    {
      'glai',
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = 'C[a]lls Incoming',
    },
    {
      'glao',
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = 'C[a]lls Outgoing',
    },
    -- Main pickers
    {
      '<leader>.',
      function()
        require('snacks').scratch()
      end,
      desc = 'Open scratch buffer',
    },
    {
      '<leader>ss',
      function()
        require('snacks').scratch.select()
      end,
      desc = 'Select scratch',
    },
    {
      '<leader>sf',
      function()
        require('snacks').picker.files()
      end,
      desc = 'Search Files',
    },
    {
      '<leader>sg',
      function()
        require('snacks').picker.grep()
      end,
      desc = 'Search by Grep',
    },
    {
      '<leader>sw',
      function()
        require('snacks').picker.grep_word()
      end,
      desc = 'Search Word',
    },
    {
      '-',
      function()
        require('snacks').picker.buffers()
      end,
      desc = 'Search Buffers',
    },
    {
      '<leader>sH',
      function()
        require('snacks').picker.highlights()
      end,
      desc = 'Search Highlight',
    },
    {
      '<leader>sh',
      function()
        require('snacks').picker.help()
      end,
      desc = 'Search Help',
    },
    {
      '<leader>sd',
      function()
        require('snacks').picker.diagnostics()
      end,
      desc = 'Search Diagnostics',
    },
    {
      '<leader>st',
      function()
        Snacks.picker.grep { search = [[\b(TODO|FIXME|HACK|NOTE)\b]], live = false }
      end,
      desc = 'Search Todo Comments',
    },
    {
      'gr',
      function()
        require('snacks').picker.lsp_references()
      end,
      desc = '[G]oto [R]eferences',
    },
    {
      'gd',
      function()
        require('snacks').picker.lsp_definitions()
      end,
      desc = '[G]oto [D]efinitions',
    },
    {
      'gI',
      function()
        require('snacks').picker.lsp_implementations()
      end,
      desc = '[G]oto [I]mplementations',
    },
    {
      'gy',
      function()
        require('snacks').picker.lsp_type_definitions()
      end,
      desc = '[G]oto Type Definition',
    },
    {
      '<leader>ds',
      function()
        require('snacks').picker.lsp_symbols()
      end,
      desc = '[Document] [S]ymbols',
    },
    {
      '<leader>#',
      function()
        require('snacks').picker.lsp_workspace_symbols()
      end,
      desc = 'Workspace Symbols',
    },
    {
      'gh',
      function()
        require('snacks').picker.git_diff()
      end,
      desc = 'Git diff',
    },
    {
      'gm',
      function()
        require('snacks').picker.marks()
      end,
      desc = '[G]oto [M]arks',
    },
    {
      'gj',
      function()
        require('snacks').picker.jumps()
      end,
      desc = '[G]oto [J]umps',
    },
    {
      'gu',
      function()
        require('snacks').picker.undo()
      end,
      desc = '[G]oto [U]ndo browser',
    },
    -- Advanced searches
    {
      '<leader>s.',
      function()
        require('snacks').picker.recent()
      end,
      desc = 'Recent Files',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>sk',
      function()
        require('snacks').picker.keymaps()
      end,
      desc = 'Search Keymaps',
    },
    {
      '<leader>sm',
      function()
        require('snacks').picker.marks()
      end,
      desc = 'Search Marks',
    },
    {
      '<leader>sR',
      function()
        require('snacks').picker.registers()
      end,
      desc = 'Search Registers',
    },
    {
      '<leader>sc',
      function()
        require('snacks').picker.command_history()
      end,
      desc = 'Command History',
    },
    -- Project navigation
    {
      '<leader>sp',
      function()
        require('snacks').picker.projects()
      end,
      desc = 'Search Projects',
    },
    {
      '<leader>sz',
      function()
        require('snacks').picker.zoxide()
      end,
      desc = 'Search Zoxide',
    },

    -- Configuration
    {
      '<leader>sC',
      function()
        require('snacks').picker.colorschemes()
      end,
      desc = 'Colorschemes',
    },
    {
      '<leader>fn',
      function()
        require('snacks').picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = 'Search Neovim Config',
    },
  },
}
