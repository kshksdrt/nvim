-- Markdown rendering via the system pandoc binary (installed with yay on
-- arch, scoop on windows) -- no plugin involved.

-- Filter that adds line numbers to all code blocks (class numberSource)
local number_lines = vim.fn.stdpath 'config' .. '/assets/number-lines.lua'

-- Iosevka for code, by absolute URL: the stylesheet is inlined into the HTML
-- below, so there is no css file for a relative URL to resolve against.
-- Forward slashes keep the url() valid on Windows.
local iosevka = (vim.fn.stdpath 'config' .. '/assets/IosevkaNerdFont-Regular.ttf'):gsub('\\', '/')

-- Inlined CSS overrides pandoc highlighting; kanagawa-dragon dark code
-- colors, sticky gutter line numbers, scroll-overflow fixes.
local css = '<style>'
  .. [[@import url('https://fonts.googleapis.com/css2?family=Google+Sans:wght@400;500;700&family=Roboto+Mono&display=swap');]]
  .. [[@font-face{font-family:'Iosevka Nerd Font';src:url(']]
  .. iosevka
  .. [[') format('truetype')}
html{background-color:#fff}
body{font-family:"Google Sans","Segoe UI",Roboto,Helvetica,Arial,sans-serif;font-size:17px;color:#1f1f1f;background-color:#fff;line-height:1.625;max-width:46rem;margin:50px auto;padding:0 30px;-webkit-font-smoothing:antialiased}
h1,h2,h3{color:#1f1f1f;font-weight:500;letter-spacing:-.01em;margin-top:2.2rem;margin-bottom:.8rem}
h1{font-size:2rem}
h2{font-size:1.45rem;border-bottom:1px solid #f0f4f9;padding-bottom:8px}
h3{font-size:1.2rem}
a{color:#1a73e8;text-decoration:none;font-weight:500}
a:hover{text-decoration:underline}
code{font-family:"Iosevka Nerd Font","Roboto Mono",monospace;background-color:#282727;color:#c5c9c5;padding:3px 6px;border-radius:6px;font-size:85%}
pre{background-color:#181616;padding:18px;border-radius:0;overflow-x:auto;border:1px solid #393836;margin:1.5rem 0}
pre code{background-color:transparent;padding:0;font-size:90%;color:#c5c9c5}
pre.sourceCode{overflow-x:auto}
code span.kw,code span.cf{color:#8992a7;font-style:italic}
code span.op{color:#c4746e}
code span.dt{color:#8ea4a2}
code span.dv,code span.bn,code span.fl{color:#a292a3}
code span.st,code span.vs,code span.ss,code span.ch{color:#8a9a7b}
code span.sc{color:#949fb5}
code span.co,code span.do,code span.an,code span.cv,code span.in{color:#737c73;font-style:italic}
code span.fu,code span.bu{color:#8ba4b0}
code span.va{color:#c5c9c5}
code span.cn{color:#b6927b}
code span.pp,code span.im{color:#c4746e}
code span.at{color:#c4b28a}
code span.ot{color:#949fb5}
code span.wa{color:#ff9e3b;font-style:italic}
code span.al,code span.er{color:#e82424}
pre.numberSource{margin-left:0;border-left:none;padding-left:0;background:linear-gradient(to right,#282727 3.25em,#181616 3.25em)}
pre.numberSource code{display:inline-block;min-width:100%}
pre.numberSource code>span{left:0;min-width:100%;box-sizing:border-box}
pre.numberSource code>span>a:first-child{text-decoration:none;font-weight:400;pointer-events:none}
pre.numberSource code>span>a:first-child::before{content:counter(source-line);position:sticky;left:0;background-color:#282727;width:2.25em;padding-right:1em;margin-right:1em;text-align:right;text-decoration:none;color:#7a8382}
::-webkit-scrollbar{width:10px;height:10px}
::-webkit-scrollbar-track{background:transparent}
::-webkit-scrollbar-thumb{background-color:rgba(122,131,130,.5);border-radius:5px}
::-webkit-scrollbar-thumb:hover{background-color:rgba(122,131,130,.75)}
p,ul,ol{margin-top:0;margin-bottom:1.2rem}
li{margin-bottom:.5rem}
blockquote{border-left:4px solid #1a73e8;margin:24px 0;padding:8px 20px;color:#444746;background-color:#f8fafd;border-radius:0 12px 12px 0}
table{border-collapse:collapse;width:100%;margin:2rem 0;font-size:95%}
th,td{border-bottom:1px solid #e0e4e9;padding:12px;text-align:left}
th{background-color:#f8fafd;color:#1f1f1f;font-weight:500}
@media (prefers-color-scheme:dark){html{background-color:#131314}body{color:#e3e3e3;background-color:#131314}h1,h2,h3{color:#e3e3e3}h2{border-bottom-color:#222224}a{color:#a8c7fa}blockquote{background-color:#1a1b1f;color:#c4c7c5}th{background-color:#1a1b1f;color:#e3e3e3}th,td{border-bottom-color:#2d2d2e}}]]
  .. '</style>'

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
    '-V',
    'header-includes=' .. css,
    '--lua-filter',
    number_lines,
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
    '-V',
    'header-includes=' .. css,
    '--lua-filter',
    number_lines,
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
