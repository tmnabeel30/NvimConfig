local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- React Functional Component
  s("rfc", fmt([[
import React from 'react';

interface {}Props {{
  {}
}}

const {}: React.FC<{}Props> = ({{ {} }}) => {{
  return (
    <div>
      {}
    </div>
  );
}};

export default {};
]], {
    i(1, "Component"),
    i(2, "// props"),
    f(function(args) return args[1][1] end, {1}),
    f(function(args) return args[1][1] end, {1}),
    i(3, ""),
    i(4, "{/* content */}"),
    f(function(args) return args[1][1] end, {1}),
  })),

  -- useState Hook
  s("us", fmt([[
const [{}, set{}] = useState<{}>({});
]], {
    i(1, "state"),
    f(function(args) 
      local state = args[1][1]
      return state:sub(1,1):upper() .. state:sub(2)
    end, {1}),
    i(2, "type"),
    i(3, "initialValue"),
  })),

  -- useEffect Hook
  s("ue", fmt([[
useEffect(() => {{
  {}
}}, [{}]);
]], {
    i(1, "// effect"),
    i(2, ""),
  })),

  -- useCallback Hook
  s("ucb", fmt([[
const {} = useCallback(() => {{
  {}
}}, [{}]);
]], {
    i(1, "callback"),
    i(2, "// callback body"),
    i(3, ""),
  })),

  -- useMemo Hook
  s("um", fmt([[
const {} = useMemo(() => {{
  return {};
}}, [{}]);
]], {
    i(1, "memoizedValue"),
    i(2, "value"),
    i(3, ""),
  })),

  -- Custom Hook
  s("uch", fmt([[
const use{} = () => {{
  {}

  return {{ {} }};
}};
]], {
    i(1, "CustomHook"),
    i(2, "// hook logic"),
    i(3, ""),
  })),

  -- React Component with Props
  s("rfcp", fmt([[
interface {}Props {{
  {}
}}

export const {} = ({{ {} }}: {}Props) => {{
  return (
    <div>
      {}
    </div>
  );
}};
]], {
    i(1, "Component"),
    i(2, "// props"),
    f(function(args) return args[1][1] end, {1}),
    i(3, ""),
    f(function(args) return args[1][1] end, {1}),
    i(4, "{/* content */}"),
  })),

  -- JSX Element
  s("div", fmt([[
<div className="{}">
  {}
</div>
]], {
    i(1, ""),
    i(2, ""),
  })),

  -- Try-Catch for async
  s("trycatch", fmt([[
try {{
  {}
}} catch (error) {{
  console.error('{}:', error);
  {}
}}
]], {
    i(1, "// code"),
    i(2, "Error"),
    i(3, ""),
  })),

  -- Console log
  s("cl", fmt([[console.log({});]], { i(1, "") })),

  -- Async function
  s("af", fmt([[
const {} = async ({}) => {{
  {}
}};
]], {
    i(1, "functionName"),
    i(2, ""),
    i(3, ""),
  })),
}
