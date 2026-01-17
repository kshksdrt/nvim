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
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true, disable = { 'ruby' } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = '<PageUp>',
            scope_incremental = 'grc',
            node_decremental = '<PageDown>',
          },
        },
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
    end,
  },
}
