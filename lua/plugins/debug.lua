-- debug.lua
--
-- DAP setup: CodeLLDB install + Rust/Go adapters (uses utils.platform for paths).

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      -- Start or continue the debugger
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      -- Stop the debugger
      '<S-F5>', -- Shift+F5
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Stop',
    },
    {
      -- Restart the debugger
      '<C-S-F5>', -- Ctrl+Shift+F5
      function()
        require('dap').restart()
      end,
      desc = 'Debug: Restart',
    },
    {
      -- Toggle a breakpoint on the current line
      '<F9>',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      -- Step over the current line
      '<F10>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      -- Step into the function on the current line
      '<F11>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      -- Step out of the current function
      '<S-F11>', -- Shift+F11
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
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
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
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

    -- Change breakpoint icons
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
    local install_codelldb = function()
      -- Define URLs and paths
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

      -- Step 4: Clean up the downloaded file
      print '🧹 Cleanup complete.'

      print '\n🎉 Success! CodeLLDB installation finished.'
    end

    -- Check if the CodeLLDB already installed
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

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
