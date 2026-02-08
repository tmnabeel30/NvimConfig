-- Improved DAP configuration - stays in your code, not Python internals

return {
  "mfussenegger/nvim-dap",
  lazy = false,
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- ==========================================
    -- DAP UI SETUP
    -- ==========================================
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
      controls = { enabled = true, element = "repl" },
      floating = {
        max_height = nil,
        max_width = nil,
        border = "rounded",
        mappings = { close = { "q", "<Esc>" } },
      },
      windows = { indent = 1 },
      render = { max_type_length = nil, max_value_lines = 100 },
    })

    -- Setup virtual text
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      all_frames = false,
    })

    -- ==========================================
    -- AUTO-OPEN/CLOSE UI LISTENERS
    -- ==========================================
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.after.event_initialized.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    -- ==========================================
    -- PYTHON CONFIGURATION
    -- ==========================================
    
    local function python_has_debugpy(python_path)
      local check = io.popen(python_path .. " -c 'import debugpy' 2>/dev/null && echo 'OK'")
      if check then
        local result = check:read("*l")
        check:close()
        return result == "OK"
      end
      return false
    end

    local function get_venv_python()
      local cwd = vim.fn.getcwd()
      local candidates = {
        cwd .. "/.venv/bin/python",
        cwd .. "/.venv/bin/python3",
        cwd .. "/.venv/Scripts/python.exe",
      }

      for _, path in ipairs(candidates) do
        if vim.fn.executable(path) == 1 and python_has_debugpy(path) then
          return path
        end
      end

      return nil
    end

    -- Find Python 3.11 with debugpy
    local function get_python_path()
      local venv_option = vim.g.dap_python_venv
      if venv_option == true or venv_option == "prompt" then
        local venv_python = get_venv_python()
        if venv_python then
          if venv_option == true then
            return venv_python
          end

          local confirm = vim.fn.confirm("Use .venv for DAP?", "&Yes\n&No", 1)
          if confirm == 1 then
            return venv_python
          end
        end
      end

      local possible_pythons = {
        "python3.11",
        "python3",
        "/usr/bin/python3.11",
        "/usr/bin/python3",
        "/usr/local/bin/python3.11",
        "/opt/homebrew/bin/python3.11",
      }
      
      for _, python_cmd in ipairs(possible_pythons) do
        if python_cmd ~= "" then
          local handle = io.popen("command -v " .. python_cmd .. " 2>/dev/null")
          if handle then
            local python_path = handle:read("*l")
            handle:close()
            
            if python_path and python_path ~= "" then
              if python_has_debugpy(python_path) then
                return python_path
              end
            end
          end
        end
      end
      
      return vim.fn.exepath("python3.11") ~= "" and vim.fn.exepath("python3.11") or "python3"
    end

    local python_path = get_python_path()
    
    -- Setup dap-python
    require("dap-python").setup(python_path)

    -- Configure Python adapter
    dap.adapters.python = {
      type = "executable",
      command = python_path,
      args = { "-m", "debugpy.adapter" },
      options = {
        source_filetype = "python",
      },
    }

    -- Python configurations - STAYS IN YOUR CODE by default
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file (your code only)",
        program = "${file}",
        pythonPath = python_path,
        console = "integratedTerminal",
        justMyCode = true,  -- ⭐ This keeps you in YOUR code only!
      },
      {
        type = "python",
        request = "launch",
        name = "Launch file (stop on entry)",
        program = "${file}",
        pythonPath = python_path,
        console = "integratedTerminal",
        stopOnEntry = true,
        justMyCode = true,
      },
      {
        type = "python",
        request = "launch",
        name = "Launch file (include libraries)",
        program = "${file}",
        pythonPath = python_path,
        console = "integratedTerminal",
        justMyCode = false,  -- Use this to debug into libraries
      },
      {
        type = "python",
        request = "launch",
        name = "Launch with arguments",
        program = "${file}",
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " +")
        end,
        pythonPath = python_path,
        console = "integratedTerminal",
        justMyCode = true,
      },
      {
        type = "python",
        request = "launch",
        name = "Debug Django",
        program = "${workspaceFolder}/manage.py",
        args = { "runserver", "--noreload" },
        pythonPath = python_path,
        console = "integratedTerminal",
        django = true,
        justMyCode = true,
      },
      {
        type = "python",
        request = "launch",
        name = "Debug pytest",
        module = "pytest",
        args = { "${file}", "-v" },
        pythonPath = python_path,
        console = "integratedTerminal",
        justMyCode = true,
      },
      {
        type = "python",
        request = "attach",
        name = "Attach remote",
        connect = function()
          local host = vim.fn.input("Host [localhost]: ")
          host = host ~= "" and host or "localhost"
          local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
          return { host = host, port = port }
        end,
        pathMappings = {
          { localRoot = "${workspaceFolder}", remoteRoot = "." },
        },
        justMyCode = true,
      },
    }

    -- Python-specific keymaps
    vim.keymap.set("n", "<Leader>dn", function()
      require("dap-python").test_method()
    end, { desc = "Debug nearest Python test" })
    
    vim.keymap.set("n", "<Leader>df", function()
      require("dap-python").test_class()
    end, { desc = "Debug Python test class" })

    -- ==========================================
    -- C/C++ ADAPTER & CONFIGURATIONS
    -- ==========================================
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch C++",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
      {
        name = "Launch C++ (with args)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " ")
        end,
      },
    }

    dap.configurations.c = dap.configurations.cpp

    -- ==========================================
    -- JAVASCRIPT/TYPESCRIPT
    -- ==========================================
    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = {
        vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
      },
    }

    dap.configurations.javascript = {
      {
        name = "Launch Node.js",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
    }

    dap.configurations.typescript = dap.configurations.javascript
    dap.configurations.javascriptreact = dap.configurations.javascript
    dap.configurations.typescriptreact = dap.configurations.javascript

    -- ==========================================
    -- GLOBAL KEYMAPS
    -- ==========================================
    vim.keymap.set("n", "<Leader>b", function() 
      dap.toggle_breakpoint() 
    end, { desc = "Toggle breakpoint" })
    
    vim.keymap.set("n", "<Leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Set conditional breakpoint" })
    
    vim.keymap.set("n", "<Leader>c", function() 
      dap.continue()
      vim.defer_fn(function()
        if dap.session() then
          dapui.open()
        end
      end, 100)
    end, { desc = "Start/Continue debugging" })
    
    vim.keymap.set("n", "<Leader>dt", function() 
      dap.terminate() 
      dapui.close()
    end, { desc = "Terminate debug session" })
    
    vim.keymap.set("n", "<Leader>so", function() 
      dap.step_over() 
    end, { desc = "Step over" })
    
    vim.keymap.set("n", "<Leader>si", function() 
      dap.step_into() 
    end, { desc = "Step into" })
    
    vim.keymap.set("n", "<Leader>su", function() 
      dap.step_out() 
    end, { desc = "Step out" })
    
    vim.keymap.set("n", "<Leader>sb", function()
      dap.step_back()
    end, { desc = "Step back" })
    
    vim.keymap.set("n", "<Leader>du", function() 
      dapui.toggle() 
    end, { desc = "Toggle DAP UI" })
    
    vim.keymap.set("n", "<Leader>de", function() 
      dapui.eval() 
    end, { desc = "Evaluate expression" })
    
    vim.keymap.set("n", "<Leader>dr", function()
      dap.repl.open()
    end, { desc = "Open REPL" })
    
    vim.keymap.set("n", "<Leader>dl", function()
      dap.run_last()
    end, { desc = "Run last debug configuration" })

    -- ==========================================
    -- BREAKPOINT SIGNS
    -- ==========================================
    vim.fn.sign_define("DapBreakpoint", {
      text = "🔴",
      texthl = "DiagnosticSignError",
      linehl = "",
      numhl = "",
    })
    
    vim.fn.sign_define("DapBreakpointCondition", {
      text = "🟡",
      texthl = "DiagnosticSignWarn",
      linehl = "",
      numhl = "",
    })
    
    vim.fn.sign_define("DapStopped", {
      text = "👉",
      texthl = "DiagnosticSignInfo",
      linehl = "DapStoppedLine",
      numhl = "",
    })
    
    vim.fn.sign_define("DapBreakpointRejected", {
      text = "⭕",
      texthl = "DiagnosticSignHint",
      linehl = "",
      numhl = "",
    })
    
    vim.fn.sign_define("DapLogPoint", {
      text = "📝",
      texthl = "DiagnosticSignInfo",
      linehl = "",
      numhl = "",
    })

    -- Define highlight for stopped line
    vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#555530" })

    -- ==========================================
    -- NOTIFICATIONS
    -- ==========================================
    dap.listeners.after.event_initialized.notify = function()
      vim.notify("🐛 Debugger started! Python: " .. python_path, vim.log.levels.INFO)
    end
    
    dap.listeners.after.event_terminated.notify = function()
      vim.notify("✅ Debugger stopped", vim.log.levels.INFO)
    end

    -- Print Python path on startup
    vim.defer_fn(function()
      print("DAP ready | Python: " .. python_path)
    end, 1000)
  end,
}
