-- DAP: CodeLLDB install plus the Rust and Go adapters.
-- Paths come from utils.platform, so this works on Linux and Windows.

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Debugger UI, and the async library it needs.
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters.
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Language-specific adapters.
    'leoluz/nvim-dap-go',
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<S-F5>',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Stop',
    },
    {
      '<C-S-F5>',
      function()
        require('dap').restart()
      end,
      desc = 'Debug: Restart',
    },
    {
      '<F9>',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<F10>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F11>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<S-F11>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    -- Without this the session output is lost on an unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Sets up each installed debugger with a reasonable default config.
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
      },
    }

    -- See `:help nvim-dap-ui`.
    dapui.setup {
      -- Plain characters, likely to render in any terminal.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Disabled: custom breakpoint icons and colors.
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    local platform_utils = require 'utils.platform'

    local codelldb_path = platform_utils.get_home_dir() .. '/Sources/CodeLLDB'
    -- CodeLLDB has no Mason package here, so fetch and unpack the release .vsix.
    local install_codelldb = function()
      local codelldb_for_windows = 'https://github.com/vadimcn/codelldb/releases/download/v1.11.5/CodeLLDB-win32-x64.vsix'
      local codelldb_for_linux = 'https://github.com/vadimcn/codelldb/releases/download/v1.11.5/CodeLLDB-linux-x64.vsix'

      print '🚀 Starting CodeLLDB installation.'
      local downloaded_file_path = platform_utils.get_home_dir() .. '/temp/CodeLLDB.vsix'

      -- Step 1: Download the file
      local download_successful =
        platform_utils.run_command('curl -L -o ' .. downloaded_file_path .. ' ' .. (platform_utils.is_windows() and codelldb_for_windows or codelldb_for_linux))
      if not download_successful then
        print '❌ Download CodeLLDB failed.'
        return
      end
      print '✅ Download CodeLLDB complete.'

      -- Step 2: Create the destination directory
      local making_dir_successful = platform_utils.run_command('mkdir -p ' .. codelldb_path)
      if not making_dir_successful then
        print '❌ Failed to create destination directory.'
        return
      end
      print '📂 Destination directory ensured.'

      -- Step 3: Extract the contents
      local extraction_successful = platform_utils.run_command('unzip -o ' .. downloaded_file_path .. ' -d ' .. codelldb_path)
      if not extraction_successful then
        print '❌ Extraction failed.'
        return
      end
      print '📦 Extraction complete.'

      -- Step 4: nothing to clean up yet -- the downloaded .vsix is left in place.
      print '🧹 Cleanup complete.'

      print '\n🎉 Success! CodeLLDB installation finished.'
    end

    -- Install on first run, or if a previous attempt left the directory empty.
    if not platform_utils.is_dir(codelldb_path) or platform_utils.is_dir_empty(codelldb_path) then
      vim.notify('ℹ️ CodeLLDB directory ' .. codelldb_path .. ' is empty. Performing installation.')
      install_codelldb()
    end

    dap.adapters.codelldb = {
      type = 'executable',
      command = codelldb_path .. '/extension/adapter/codelldb',
    }

    dap.configurations.rust = {
      {
        name = 'Attach with process',
        type = 'codelldb',
        request = 'attach',
        pid = '${command:pickProcess}', -- Or pickMyProcess for only processes for the current user.
      },
    }

    -- Go adapter (delve).
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
