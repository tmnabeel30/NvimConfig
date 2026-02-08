return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- ==========================================
    -- DIAGNOSTICS (ENABLE + CONSISTENT)
    -- ==========================================
    vim.diagnostic.config({
      virtual_text = { spacing = 2, prefix = "●" },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
    })

    -- ==========================================
    -- LSP ATTACH (KEYMAPS)
    -- ==========================================
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf, silent = true }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      end,
    })

    -- ==========================================
    -- CONFIGURE ALL LSP SERVERS
    -- ==========================================
    
    -- LUA (Neovim config)
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { 
            globals = { "vim" },
            disable = { "missing-fields", "incomplete-signature-doc" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    -- TYPESCRIPT / JAVASCRIPT / REACT
    vim.lsp.config("ts_ls", {
      capabilities = capabilities,
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root_markers = {
        "vite.config.ts",
        "vite.config.js",
        "tsconfig.json",
        "package.json",
        ".git",
      },
      init_options = {
        preferences = {
          importModuleSpecifierPreference = "relative",
          jsxAttributeCompletionStyle = "auto",
          includeCompletionsForModuleExports = true,
        },
      },
    })

    -- JSON
    vim.lsp.config("jsonls", {
      capabilities = capabilities,
      settings = {
        json = {
          validate = { enable = true },
          schemas = {
            {
              fileMatch = { "package.json" },
              url = "https://json.schemastore.org/package.json",
            },
            {
              fileMatch = { "tsconfig.json", "tsconfig.*.json" },
              url = "https://json.schemastore.org/tsconfig.json",
            },
          },
        },
      },
    })

    -- PYTHON - TYPE CHECKING (BASIC) + LINTING (RUFF)
    local function get_python_path(workspace)
      local venv = vim.env.VIRTUAL_ENV
      if venv and venv ~= "" then
        local venv_python = venv .. "/bin/python"
        if vim.fn.filereadable(venv_python) == 1 then
          return venv_python
        end
        local venv_python_win = venv .. "/Scripts/python.exe"
        if vim.fn.filereadable(venv_python_win) == 1 then
          return venv_python_win
        end
      end

      local candidates = {
        workspace .. "/.venv/bin/python",
        workspace .. "/.venv/bin/python3",
        workspace .. "/venv/bin/python",
        workspace .. "/venv/bin/python3",
        workspace .. "/.venv/Scripts/python.exe",
        workspace .. "/venv/Scripts/python.exe",
      }

      for _, path in ipairs(candidates) do
        if vim.fn.filereadable(path) == 1 then
          return path
        end
      end

      local system_python = vim.fn.exepath("python3")
      return system_python ~= "" and system_python or "python"
    end

    local function get_python_venv(workspace)
      local venv = vim.env.VIRTUAL_ENV
      if venv and venv ~= "" then
        local venv_name = vim.fn.fnamemodify(venv, ":t")
        local venv_path = vim.fn.fnamemodify(venv, ":h")
        if venv_name ~= "" and venv_path ~= "" then
          return venv_path, venv_name
        end
      end

      local candidates = { ".venv", "venv" }
      for _, name in ipairs(candidates) do
        local venv_dir = workspace .. "/" .. name
        if vim.fn.isdirectory(venv_dir) == 1 then
          return workspace, name
        end
      end

      return nil, nil
    end

    vim.lsp.config("pyright", {
      capabilities = capabilities,
      on_new_config = function(config, root_dir)
        local python_path = get_python_path(root_dir)
        local venv_path, venv_name = get_python_venv(root_dir)
        config.settings = config.settings or {}
        config.settings.python = config.settings.python or {}
        config.settings.python.pythonPath = python_path
        config.settings.python.defaultInterpreterPath = python_path
        if venv_path and venv_name then
          config.settings.python.venvPath = venv_path
          config.settings.python.venv = venv_name
        end
      end,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
            autoSearchPaths = true,
            autoImportCompletions = true,
            diagnosticSeverityOverrides = {
              reportGeneralTypeIssues = "none",
            },
          },
        },
      },
    })

    vim.lsp.config("ruff", {
      capabilities = capabilities,
      init_options = {
        settings = {
          args = {},
        },
      },
    })

    -- BASH
    vim.lsp.config("bashls", { 
      capabilities = capabilities,
    })

    -- YAML
    vim.lsp.config("yamlls", { 
      capabilities = capabilities,
    })

    -- C/C++
    vim.lsp.config("clangd", {
      capabilities = capabilities,
      cmd = { "clangd", "--header-insertion=never" },
    })
  end,
}
