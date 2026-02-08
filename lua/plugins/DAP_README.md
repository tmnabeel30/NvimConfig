# Neovim DAP (Debugger) Setup

Complete debugging setup for Python, React/TypeScript, and C++.

## 📦 Installation

1. **Copy the configuration files:**
   ```bash
   cp dap.lua ~/.config/nvim/lua/plugins/dap.lua
   cp dap-python.lua ~/.config/nvim/lua/plugins/dap-python.lua
   cp dap-js.lua ~/.config/nvim/lua/plugins/dap-js.lua
   cp dap-cpp.lua ~/.config/nvim/lua/plugins/dap-cpp.lua
   cp mason.lua ~/.config/nvim/lua/plugins/mason.lua
   ```

2. **Restart Neovim and sync plugins:**
   ```vim
   :Lazy sync
   ```

3. **Install debuggers via Mason:**
   ```vim
   :Mason
   ```
   Then install:
   - `debugpy` (Python)
   - `codelldb` (C/C++)

4. **Install Python debugger (if not using Mason):**
   ```bash
   pip install debugpy
   ```

## 🎯 Keybindings

### Global Debug Keys (All Languages)
| Key | Action |
|-----|--------|
| `<Leader>b` | Toggle breakpoint |
| `<Leader>c` | Continue/Start debugging |
| `<Leader>dt` | Terminate debug session |
| `<Leader>so` | Step over |
| `<Leader>si` | Step into |
| `<Leader>su` | Step out |

### Python-Specific Keys
| Key | Action |
|-----|--------|
| `<Leader>dn` | Debug nearest test method |
| `<Leader>df` | Debug test class |

## 🐍 Python Debugging

### Setup
1. Install debugpy: `pip install debugpy`
2. Set breakpoint with `<Leader>b`
3. Start debugging with `<Leader>c`

### Example Workflow
```python
def calculate_sum(a, b):
    result = a + b  # Set breakpoint here with <Leader>b
    return result

if __name__ == "__main__":
    calculate_sum(5, 10)
```

1. Place cursor on line 2
2. Press `<Leader>b` (sets breakpoint)
3. Press `<Leader>c` (starts debugger)
4. Use `<Leader>so` to step over, `<Leader>si` to step into

### Testing with pytest
```python
def test_calculation():
    assert calculate_sum(2, 3) == 5  # Cursor here
```
- Press `<Leader>dn` to debug this specific test

## ⚛️ React/TypeScript Debugging

### Setup for Vite Projects
1. Start your dev server: `npm run dev` (usually on port 5173)
2. Set breakpoints in your React code
3. Press `<Leader>c` and select "Launch Chrome (React/Vite)"

### Configuration Options
- **Launch Chrome (React/Vite)**: Debug React app in Chrome (connects to localhost:5173)
- **Launch TypeScript**: Debug standalone TypeScript files
- **Launch Node.js**: Debug Node.js scripts
- **Attach to Node.js**: Attach to running Node process

### Example Component Debugging
```typescript
const MyComponent = () => {
  const [count, setCount] = useState(0);
  
  const handleClick = () => {
    setCount(count + 1);  // Set breakpoint here
  };
  
  return <button onClick={handleClick}>Count: {count}</button>;
};
```

### Custom Vite Port
If your Vite runs on a different port, edit `dap-js.lua`:
```lua
url = "http://localhost:YOUR_PORT",
```

## 🔧 C++ Debugging

### Setup
1. Compile with debug symbols: `g++ -g myfile.cpp -o myfile`
2. Set breakpoints
3. Press `<Leader>c` and select configuration

### Configuration Options
- **Launch C++**: Run and debug executable
- **Launch C++ (with args)**: Run with command-line arguments
- **Attach to process**: Attach to running process

### Example Workflow
```cpp
#include <iostream>

int main() {
    int x = 5;
    int y = 10;
    int result = x + y;  // Set breakpoint here
    std::cout << result << std::endl;
    return 0;
}
```

1. Compile: `g++ -g main.cpp -o main`
2. Set breakpoint: `<Leader>b`
3. Start debug: `<Leader>c`
4. Select "Launch C++"
5. Enter path: `./main`

### With Arguments
```bash
# Your program expects: ./main arg1 arg2
```
1. Press `<Leader>c`
2. Select "Launch C++ (with args)"
3. Enter executable: `./main`
4. Enter arguments: `arg1 arg2`

## 🎨 DAP UI

The debugger UI automatically opens when you start debugging and shows:
- **Scopes**: Local variables and their values
- **Breakpoints**: All set breakpoints
- **Stacks**: Call stack trace
- **Watches**: Custom watch expressions
- **Console**: Debug output and REPL

### Navigate UI
- Use `Ctrl+w` + `hjkl` to move between windows
- UI closes automatically when debugging ends

## 🔍 Common Workflows

### 1. Quick Python Debug
```bash
# In your Python file
<Leader>b    # Set breakpoint
<Leader>c    # Start debugging
<Leader>so   # Step through code
```

### 2. React Component Debug
```bash
npm run dev                    # Start Vite
# Open React component in Neovim
<Leader>b                      # Set breakpoint
<Leader>c                      # Select "Launch Chrome"
# Interact with app in browser
```

### 3. C++ Debug with Input
```bash
g++ -g main.cpp -o main        # Compile with debug info
# In Neovim
<Leader>b                      # Set breakpoint
<Leader>c                      # Select "Launch C++ (with args)"
# Enter: ./main
# Enter args: input.txt output.txt
```

## 🚨 Troubleshooting

### Python: "No module named debugpy"
```bash
pip install debugpy
# or with conda:
conda install -c conda-forge debugpy
```

### React: Can't connect to localhost:5173
- Make sure Vite dev server is running
- Check the port in `dap-js.lua` matches your Vite config
- Try: `npm run dev -- --port 5173`

### C++: "No executable found"
- Compile with `-g` flag for debug symbols
- Use full path to executable
- Check file permissions: `chmod +x ./myprogram`

### DAP UI not opening
```vim
:lua require('dapui').open()
```

### Check DAP status
```vim
:lua require('dap').status()
:checkhealth dap
```

## 📚 Advanced Features

### Conditional Breakpoints
1. Set breakpoint: `<Leader>b`
2. Run: `:lua require('dap').set_breakpoint(vim.fn.input('Condition: '))`

### Log Points
```vim
:lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log message: '))
```

### Watch Expressions
In DAP UI, navigate to Watches panel and add expressions to monitor.

## 🎓 Resources

- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
- [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python)
- [nvim-dap-vscode-js](https://github.com/mxsdev/nvim-dap-vscode-js)
