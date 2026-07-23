return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = true,
        },
        indent = { enable = true, disable = { 'ruby' } },
      }
      require('nvim-treesitter.install').prefer_git = false
      require('nvim-treesitter.install').compilers = { 'zig' }

      local parsers = {
        'bash',
        'c_sharp',
        'css',
        'diff',
        'editorconfig',
        'fish',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'rust',
        'scss',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'vue',
        'xml',
        'yaml',
      }

      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyDone',
        once = true,
        callback = function()
          require('nvim-treesitter').install(parsers)
        end,
      })

      vim.opt.foldmethod = 'manual'
      vim.opt.foldenable = false

      -- Node nav + incremental selection, hand-rolled since `main` dropped the `incremental_selection` module.
      local selection_stack = {}

      local function ranges_equal(a, b)
        local a1, a2, a3, a4 = a:range()
        local b1, b2, b3, b4 = b:range()
        return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
      end

      local function select_node(buf, node)
        local srow, scol, erow, ecol = node:range()
        srow, scol, erow = srow + 1, scol + 1, erow + 1
        if ecol == 0 then -- exclusive end col; 0 ⇒ node ends at line start, back up one line
          erow = erow - 1
          local line = vim.api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1] or ''
          ecol = math.max(#line, 1)
        end
        if vim.fn.mode():match('^[vV\022]') then
          vim.cmd('normal! \27')
        end
        vim.fn.setpos('.', { 0, srow, scol, 0 })
        vim.cmd('normal! v')
        vim.fn.setpos('.', { 0, erow, ecol, 0 })
      end

      local function start_selection(buf)
        local node = vim.treesitter.get_node()
        if not node then return nil end
        selection_stack[buf] = { node }
        return node
      end

      local function ts_selection(grow)
        local buf = vim.api.nvim_get_current_buf()
        local in_visual = vim.fn.mode():match('^[vV\022]') ~= nil
        local stack = selection_stack[buf]
        local node
        if not in_visual or not stack or #stack == 0 then
          node = start_selection(buf)
          if not node then return end
        elseif grow then
          local top = stack[#stack]
          local parent = top:parent()
          while parent and ranges_equal(parent, top) do
            parent = parent:parent() -- skip same-range ancestors
          end
          if parent then table.insert(stack, parent) end
          node = stack[#stack]
        else
          if #stack > 1 then table.remove(stack) end
          node = stack[#stack]
        end
        select_node(buf, node)
      end

      local function ts_init_selection()
        local buf = vim.api.nvim_get_current_buf()
        local node = start_selection(buf)
        if node then select_node(buf, node) end
      end

      local function goto_parent_node()
        local node = vim.treesitter.get_node()
        if not node then return end
        local crow, ccol = unpack(vim.api.nvim_win_get_cursor(0))
        crow = crow - 1
        local parent = node:parent()
        while parent do
          local prow, pcol = parent:start()
          if prow ~= crow or pcol ~= ccol then
            vim.api.nvim_win_set_cursor(0, { prow + 1, pcol })
            return
          end
          parent = parent:parent()
        end
      end

      vim.keymap.set('n', '<leader>^', goto_parent_node, { desc = 'Treesitter: go to parent node' })
      vim.keymap.set('n', 'gnn', ts_init_selection, { desc = 'Treesitter: start incremental selection' })
      vim.keymap.set('x', 'H', function() ts_selection(true) end, { desc = 'Treesitter: grow selection to parent node' }) -- visual-only; normal H/L = tab nav
      vim.keymap.set('x', 'L', function() ts_selection(false) end, { desc = 'Treesitter: shrink selection to child node' })
    end,
  },
}
