-- Markdown rendering via the system pandoc binary (installed with yay on
-- arch, scoop on windows) -- no plugin involved.

-- Filter that adds line numbers to all code blocks (class numberSource)
local number_lines = vim.fn.stdpath 'config' .. '/assets/number-lines.lua'

-- Iosevka for code, by absolute URL: the stylesheet is inlined into the HTML
-- below, so there is no css file for a relative URL to resolve against.
-- Forward slashes keep the url() valid on Windows.
local iosevka = (vim.fn.stdpath 'config' .. '/assets/IosevkaNerdFont-Regular.ttf'):gsub('\\', '/')

-- Page chrome, in the register of an ordinary online publication: near-black
-- ink on paper, one muted navy accent, neutral greys for rules and fills.
-- Fenced code blocks are deliberately not covered here -- they keep the
-- kanagawa-dragon colors in every mode. Inline code is chrome rather than a
-- code panel, so it does follow the palette.
local palettes = {
  light = {
    bg = '#ffffff',
    fg = '#1c1c1c',
    heading = '#111111',
    rule = '#e5e5e5',
    link = '#326891',
    visited = '#6b5b95',
    fill = '#f7f7f7', -- blockquote and table header
    code_bg = '#f0f0f0', -- inline code only; fenced blocks stay dragon
    code_fg = '#1c1c1c',
    quote = '#4a4a4a',
    thumb = 'rgba(0,0,0,.25)',
    thumb_hover = 'rgba(0,0,0,.4)',
  },
  dark = {
    -- Held below the code block's #181616 so panels still read as raised.
    bg = '#0f0f0f',
    fg = '#dedede',
    heading = '#f5f5f5',
    rule = '#2a2a2a',
    link = '#79a9d1',
    visited = '#b09ac9',
    fill = '#1a1a1a',
    code_bg = '#282727',
    code_fg = '#c5c9c5',
    quote = '#b8b8b8',
    thumb = 'rgba(255,255,255,.22)',
    thumb_hover = 'rgba(255,255,255,.35)',
  },
}

-- Every chrome color in the rules below is read through a custom property, so
-- a palette is only ever spelled out in the table above.
local function custom_properties(palette)
  local declarations = {}
  for name, value in pairs(palette) do
    table.insert(declarations, '--' .. name:gsub('_', '-') .. ':' .. value)
  end
  table.sort(declarations) -- pairs() is unordered; keep the output stable
  return ':root{' .. table.concat(declarations, ';') .. '}'
end

-- 'auto' follows the reader's OS preference. 'light' and 'dark' pin one
-- palette, which is what an exported file wants when it gets shared or printed.
local modes = { 'auto', 'light', 'dark' }

local function root_block(mode)
  if mode == 'light' then
    return custom_properties(palettes.light)
  elseif mode == 'dark' then
    return custom_properties(palettes.dark)
  end
  return custom_properties(palettes.light)
    .. '@media (prefers-color-scheme:dark){'
    .. custom_properties(palettes.dark)
    .. '}'
end

-- Inlined CSS overrides pandoc highlighting; kanagawa-dragon dark code
-- colors, sticky gutter line numbers, scroll-overflow fixes.
local rules = [[
html{background-color:var(--bg)}
body{font-family:Roboto,"Segoe UI",Helvetica,Arial,sans-serif;font-size:17px;color:var(--fg);background-color:var(--bg);line-height:1.625;max-width:46rem;margin:50px auto;padding:0 30px;-webkit-font-smoothing:antialiased}
h1,h2,h3{color:var(--heading);font-weight:500;letter-spacing:-.01em;margin-top:2.2rem;margin-bottom:.8rem}
h1{font-size:2rem}
h2{font-size:1.45rem;border-bottom:1px solid var(--rule);padding-bottom:8px}
h3{font-size:1.2rem}
a{color:var(--link);text-decoration:none;font-weight:500}
a:visited{color:var(--visited)}
a:hover{text-decoration:underline}
code{font-family:"Iosevka Nerd Font","Roboto Mono",monospace;background-color:var(--code-bg);color:var(--code-fg);padding:3px 6px;border-radius:6px;font-size:85%}
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
::-webkit-scrollbar-thumb{background-color:var(--thumb);border-radius:5px}
::-webkit-scrollbar-thumb:hover{background-color:var(--thumb-hover)}
p,ul,ol{margin-top:0;margin-bottom:1.2rem}
li{margin-bottom:.5rem}
blockquote{border-left:4px solid var(--link);margin:24px 0;padding:8px 20px;color:var(--quote);background-color:var(--fill);border-radius:0 12px 12px 0}
table{border-collapse:collapse;width:100%;margin:2rem 0;font-size:95%}
th,td{border-bottom:1px solid var(--rule);padding:12px;text-align:left}
th{background-color:var(--fill);color:var(--heading);font-weight:500}]]

local function build_css(mode)
  return '<style>'
    .. [[@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&family=Roboto+Mono&display=swap');]]
    .. [[@font-face{font-family:'Iosevka Nerd Font';src:url(']]
    .. iosevka
    .. [[') format('truetype')}]]
    .. root_block(mode)
    .. rules
    .. '</style>'
end

-- Shared front half of both commands: the buffer has to be a saved markdown
-- file, and the optional argument has to name a real mode.
local function resolve(command, args)
  if vim.bo.filetype ~= 'markdown' then
    vim.notify(command .. ' only works for markdown files', vim.log.levels.WARN)
    return nil
  end

  local input = vim.api.nvim_buf_get_name(0)
  if input == '' then
    vim.notify('Buffer must be saved to a file first', vim.log.levels.ERROR)
    return nil
  end

  local mode = args ~= '' and args or 'auto'
  if not vim.tbl_contains(modes, mode) then
    vim.notify('Pandoc: unknown mode ' .. mode .. ' (expected ' .. table.concat(modes, ', ') .. ')', vim.log.levels.ERROR)
    return nil
  end

  return input, mode
end

local function render(input, output, mode, label, on_success)
  -- Save buffer before rendering
  vim.cmd 'update'

  vim.fn.jobstart({
    'pandoc',
    input,
    '--standalone',
    '--toc',
    '-V',
    'header-includes=' .. build_css(mode),
    '--lua-filter',
    number_lines,
    '--output',
    output,
  }, {
    on_exit = function(_, code)
      if code == 0 then
        on_success()
      else
        vim.notify('Pandoc: ' .. label .. ' failed', vim.log.levels.ERROR)
      end
    end,
  })
end

local function complete_mode(arg_lead)
  return vim.tbl_filter(function(mode)
    return vim.startswith(mode, arg_lead)
  end, modes)
end

vim.api.nvim_create_user_command('PandocPreview', function(opts)
  local input, mode = resolve('PandocPreview', opts.args)
  if not input then
    return
  end

  local output = vim.fn.tempname() .. '.html'
  render(input, output, mode, 'Rendering', function()
    vim.notify('Pandoc: HTML render complete. Opening...', vim.log.levels.INFO)
    vim.ui.open(output)
  end)
end, {
  desc = 'Render markdown to HTML and open in browser (mode: auto|light|dark)',
  nargs = '?',
  complete = complete_mode,
})

vim.api.nvim_create_user_command('PandocToDoc', function(opts)
  local input, mode = resolve('PandocToDoc', opts.args)
  if not input then
    return
  end

  local filename = vim.fn.fnamemodify(input, ':t:r')
  local output = vim.fn.expand '~/Documents/' .. filename .. '.html'

  render(input, output, mode, 'Export', function()
    vim.notify('Pandoc: Exported to ' .. output, vim.log.levels.INFO)
  end)
end, {
  desc = 'Export markdown to ~/Documents/ as HTML (mode: auto|light|dark)',
  nargs = '?',
  complete = complete_mode,
})
