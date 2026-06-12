-- Markdown rendering via the system pandoc binary (installed with yay on
-- arch, scoop on windows) -- no plugin involved.

-- Stylesheet for rendered HTML, linked by absolute path so edits
-- apply on browser refresh without re-rendering
local css = vim.fn.stdpath 'config' .. '/assets/pandoc.css'
-- Filter that adds line numbers to all code blocks
local number_lines = vim.fn.stdpath 'config' .. '/assets/number-lines.lua'

vim.api.nvim_create_user_command('PandocPreview', function()
  if vim.bo.filetype ~= 'markdown' then
    vim.notify('PandocPreview only works for markdown files', vim.log.levels.WARN)
    return
  end

  local input = vim.api.nvim_buf_get_name(0)
  if input == '' then
    vim.notify('Buffer must be saved to a file first', vim.log.levels.ERROR)
    return
  end
  local output = vim.fn.tempname() .. '.html'

  -- Save buffer before rendering
  vim.cmd 'update'

  vim.fn.jobstart({
    'pandoc',
    input,
    '--standalone',
    '--toc',
    '--css',
    css,
    '--lua-filter',
    number_lines,
    -- Enable the next 2 lines when using a css that does not limit max-width
    -- '-V',
    -- 'header-includes=<style>body { max-width: 70ch; margin: auto; font-size: 15px; }</style>',
    '--output',
    output,
  }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('Pandoc: HTML render complete. Opening...', vim.log.levels.INFO)
        vim.ui.open(output)
      else
        vim.notify('Pandoc: Rendering failed', vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = 'Render markdown to HTML and open in browser' })

vim.api.nvim_create_user_command('PandocToDoc', function()
  if vim.bo.filetype ~= 'markdown' then
    vim.notify('PandocToDoc only works for markdown files', vim.log.levels.WARN)
    return
  end

  local input = vim.api.nvim_buf_get_name(0)
  if input == '' then
    vim.notify('Buffer must be saved to a file first', vim.log.levels.ERROR)
    return
  end

  local filename = vim.fn.fnamemodify(input, ':t:r')
  local output_dir = vim.fn.expand '~/Documents/'
  local output = output_dir .. filename .. '.html'

  -- Save buffer before rendering
  vim.cmd 'update'

  vim.fn.jobstart({
    'pandoc',
    input,
    '--standalone',
    '--toc',
    '--css',
    css,
    '--lua-filter',
    number_lines,
    -- Enable the next 2 lines when using a css that does not limit max-width
    -- '-V',
    -- 'header-includes=<style>body { max-width: 70ch; margin: auto; font-size: 15px; }</style>',
    '--output',
    output,
  }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('Pandoc: Exported to ' .. output, vim.log.levels.INFO)
      else
        vim.notify('Pandoc: Export failed', vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = 'Export markdown to ~/Documents/ as HTML' })
