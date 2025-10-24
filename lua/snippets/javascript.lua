local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node

return {
  s('cl', {
    t { 'console.dir({', '  path: "' },
    f(function()
      return vim.fn.expand '%:~:.'
    end, {}),
    t '",',
    t { '' },
    i(1), -- cursor lands here, after path
    t { '', '}, { depth: null })' },
  }),
}
