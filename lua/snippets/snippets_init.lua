-- Load all custom snippets
local ls = require("luasnip")

-- Load TypeScript/JavaScript/React snippets
ls.add_snippets("typescript", require("snippets.typescript"))
ls.add_snippets("typescriptreact", require("snippets.typescript"))
ls.add_snippets("javascript", require("snippets.typescript"))
ls.add_snippets("javascriptreact", require("snippets.typescript"))

-- Load Python snippets
ls.add_snippets("python", require("snippets.python"))

-- Load C++ snippets
ls.add_snippets("cpp", require("snippets.cpp"))
ls.add_snippets("c", require("snippets.cpp"))

return {}
