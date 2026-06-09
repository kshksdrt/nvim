return {
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {

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
  },
}
