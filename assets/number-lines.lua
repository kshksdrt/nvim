-- Pandoc filter: number every fenced code block. Pandoc's HTML writer
-- only numbers blocks carrying the `numberLines` class, and there is no
-- CLI flag to enable it globally.
function CodeBlock(block)
  block.classes:insert 'numberLines'
  return block
end
