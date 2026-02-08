local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Function definition
  s("def", fmt([[
def {}({}) -> {}:
    """{}"""
    {}
]], {
    i(1, "function_name"),
    i(2, ""),
    i(3, "None"),
    i(4, "Function description"),
    i(5, "pass"),
  })),

  -- Class definition
  s("class", fmt([[
class {}:
    """{}"""
    
    def __init__(self, {}):
        {}
]], {
    i(1, "ClassName"),
    i(2, "Class description"),
    i(3, ""),
    i(4, "pass"),
  })),

  -- Dataclass
  s("dc", fmt([[
from dataclasses import dataclass

@dataclass
class {}:
    """{}"""
    {}: {}
]], {
    i(1, "ClassName"),
    i(2, "Description"),
    i(3, "field"),
    i(4, "type"),
  })),

  -- If main
  s("ifmain", fmt([[
if __name__ == "__main__":
    {}
]], {
    i(1, "main()"),
  })),

  -- Try-except
  s("try", fmt([[
try:
    {}
except {} as e:
    {}
]], {
    i(1, "# code"),
    i(2, "Exception"),
    i(3, "print(f'Error: {e}')"),
  })),

  -- For loop
  s("for", fmt([[
for {} in {}:
    {}
]], {
    i(1, "item"),
    i(2, "items"),
    i(3, "pass"),
  })),

  -- List comprehension
  s("lc", fmt([[
[{} for {} in {}]
]], {
    i(1, "x"),
    i(2, "x"),
    i(3, "iterable"),
  })),

  -- Dictionary comprehension
  s("dc", fmt([[
{{{}: {} for {} in {}}}
]], {
    i(1, "key"),
    i(2, "value"),
    i(3, "item"),
    i(4, "items"),
  })),

  -- Async function
  s("async", fmt([[
async def {}({}) -> {}:
    """{}"""
    {}
]], {
    i(1, "function_name"),
    i(2, ""),
    i(3, "None"),
    i(4, "Async function description"),
    i(5, "pass"),
  })),

  -- Property decorator
  s("prop", fmt([[
@property
def {}(self) -> {}:
    """{}"""
    return self._{}
]], {
    i(1, "property_name"),
    i(2, "type"),
    i(3, "Property description"),
    f(function(args) return args[1][1] end, {1}),
  })),

  -- Setter decorator
  s("setter", fmt([[
@{}.setter
def {}(self, value: {}) -> None:
    self._{} = value
]], {
    i(1, "property_name"),
    f(function(args) return args[1][1] end, {1}),
    i(2, "type"),
    f(function(args) return args[1][1] end, {1}),
  })),

  -- Context manager
  s("with", fmt([[
with {}({}) as {}:
    {}
]], {
    i(1, "open"),
    i(2, "'file.txt'"),
    i(3, "f"),
    i(4, "pass"),
  })),

  -- Type hints import
  s("typing", fmt([[
from typing import {}
]], {
    i(1, "List, Dict, Optional, Union"),
  })),

  -- Print debug
  s("pd", fmt([[
print(f"{{{} = }}")
]], {
    i(1, "variable"),
  })),

  -- Pytest test function
  s("test", fmt([[
def test_{}():
    """{}"""
    # Arrange
    {}
    
    # Act
    {}
    
    # Assert
    assert {}
]], {
    i(1, "function_name"),
    i(2, "Test description"),
    i(3, ""),
    i(4, ""),
    i(5, "True"),
  })),
}
