local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Main function
  s("main", fmt([[
int main() {{
    {}
    return 0;
}}
]], {
    i(1, "// code"),
  })),

  -- Class definition
  s("class", fmt([[
class {} {{
public:
    {}();
    ~{}();
    
    {}

private:
    {}
}};
]], {
    i(1, "ClassName"),
    f(function(args) return args[1][1] end, {1}),
    f(function(args) return args[1][1] end, {1}),
    i(2, "// public members"),
    i(3, "// private members"),
  })),

  -- Struct definition
  s("struct", fmt([[
struct {} {{
    {}
}};
]], {
    i(1, "StructName"),
    i(2, "// members"),
  })),

  -- Namespace
  s("ns", fmt([[
namespace {} {{

{}

}} // namespace {}
]], {
    i(1, "name"),
    i(2, ""),
    f(function(args) return args[1][1] end, {1}),
  })),

  -- For loop
  s("for", fmt([[
for (int {} = 0; {} < {}; {}++) {{
    {}
}}
]], {
    i(1, "i"),
    f(function(args) return args[1][1] end, {1}),
    i(2, "n"),
    f(function(args) return args[1][1] end, {1}),
    i(3, "// code"),
  })),

  -- Range-based for loop
  s("forr", fmt([[
for (auto& {} : {}) {{
    {}
}}
]], {
    i(1, "item"),
    i(2, "container"),
    i(3, "// code"),
  })),

  -- While loop
  s("while", fmt([[
while ({}) {{
    {}
}}
]], {
    i(1, "condition"),
    i(2, "// code"),
  })),

  -- If statement
  s("if", fmt([[
if ({}) {{
    {}
}}
]], {
    i(1, "condition"),
    i(2, "// code"),
  })),

  -- If-else statement
  s("ife", fmt([[
if ({}) {{
    {}
}} else {{
    {}
}}
]], {
    i(1, "condition"),
    i(2, "// if code"),
    i(3, "// else code"),
  })),

  -- Switch statement
  s("switch", fmt([[
switch ({}) {{
    case {}:
        {}
        break;
    default:
        {}
        break;
}}
]], {
    i(1, "variable"),
    i(2, "value"),
    i(3, "// code"),
    i(4, "// default code"),
  })),

  -- Try-catch
  s("try", fmt([[
try {{
    {}
}} catch (const {}& e) {{
    {}
}}
]], {
    i(1, "// code"),
    i(2, "std::exception"),
    i(3, "std::cerr << e.what() << std::endl;"),
  })),

  -- Vector declaration
  s("vec", fmt([[
std::vector<{}> {}({}};
]], {
    i(1, "int"),
    i(2, "vec"),
    i(3, ""),
  })),

  -- Unique pointer
  s("uniq", fmt([[
std::unique_ptr<{}> {} = std::make_unique<{}>({});
]], {
    i(1, "Type"),
    i(2, "ptr"),
    f(function(args) return args[1][1] end, {1}),
    i(3, ""),
  })),

  -- Shared pointer
  s("shared", fmt([[
std::shared_ptr<{}> {} = std::make_shared<{}>({});
]], {
    i(1, "Type"),
    i(2, "ptr"),
    f(function(args) return args[1][1] end, {1}),
    i(3, ""),
  })),

  -- Lambda function
  s("lambda", fmt([[
auto {} = []({}) {{
    {}
}};
]], {
    i(1, "lambda"),
    i(2, ""),
    i(3, "// code"),
  })),

  -- Template function
  s("template", fmt([[
template<typename {}>
{} {}({}) {{
    {}
}}
]], {
    i(1, "T"),
    i(2, "T"),
    i(3, "function_name"),
    i(4, "T param"),
    i(5, "// code"),
  })),

  -- Include guard
  s("guard", fmt([[
#ifndef {}_H
#define {}_H

{}

#endif // {}_H
]], {
    i(1, "HEADER"),
    f(function(args) return args[1][1] end, {1}),
    i(2, "// content"),
    f(function(args) return args[1][1] end, {1}),
  })),

  -- Constructor
  s("ctor", fmt([[
{}::{}({}) : {} {{
    {}
}}
]], {
    i(1, "ClassName"),
    f(function(args) return args[1][1] end, {1}),
    i(2, ""),
    i(3, "// initializer list"),
    i(4, "// body"),
  })),

  -- Destructor
  s("dtor", fmt([[
{}::~{}() {{
    {}
}}
]], {
    i(1, "ClassName"),
    f(function(args) return args[1][1] end, {1}),
    i(2, "// cleanup"),
  })),

  -- Cout
  s("cout", fmt([[
std::cout << {} << std::endl;
]], {
    i(1, "output"),
  })),

  -- Cerr
  s("cerr", fmt([[
std::cerr << {} << std::endl;
]], {
    i(1, "error"),
  })),
}
