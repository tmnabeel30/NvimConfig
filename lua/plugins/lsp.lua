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
    local lsp_util = require("lspconfig.util")

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
    local function systemlist_in_dir(cmd, dir)
      local full_cmd = "cd " .. vim.fn.shellescape(dir) .. " && " .. cmd
      local output = vim.fn.systemlist(full_cmd)
      if vim.v.shell_error ~= 0 then
        return nil
      end
      return output
    end

    local function get_env_venv_root()
      local env_vars = { "VIRTUAL_ENV", "CONDA_PREFIX", "UV_PROJECT_ENVIRONMENT" }
      for _, var in ipairs(env_vars) do
        local value = vim.env[var]
        if value and value ~= "" and vim.fn.isdirectory(value) == 1 then
          return value
        end
      end
      return nil
    end

    local function get_project_venv_root(workspace)
      local candidates = { workspace .. "/.venv", workspace .. "/venv" }
      for _, path in ipairs(candidates) do
        if vim.fn.isdirectory(path) == 1 then
          return path
        end
      end
      return nil
    end

    local function get_tool_venv_root(workspace)
      local pyproject = workspace .. "/pyproject.toml"
      if vim.fn.filereadable(pyproject) == 1 and vim.fn.executable("poetry") == 1 then
        local lines = vim.fn.readfile(pyproject, "", 200)
        for _, line in ipairs(lines) do
          if line:match("^%s*%[tool%.poetry%]") then
            local output = systemlist_in_dir("poetry env info -p", workspace)
            if output and output[1] and vim.fn.isdirectory(output[1]) == 1 then
              return output[1]
            end
            break
          end
        end
      end

      if vim.fn.filereadable(workspace .. "/Pipfile") == 1 and vim.fn.executable("pipenv") == 1 then
        local output = systemlist_in_dir("pipenv --venv", workspace)
        if output and output[1] and vim.fn.isdirectory(output[1]) == 1 then
          return output[1]
        end
      end

      return nil
    end

    local function get_python_venv(workspace)
      local venv_root = get_env_venv_root()
        or get_project_venv_root(workspace)
        or get_tool_venv_root(workspace)

      if venv_root then
        local venv_name = vim.fn.fnamemodify(venv_root, ":t")
        local venv_path = vim.fn.fnamemodify(venv_root, ":h")
        if venv_name ~= "" and venv_path ~= "" then
          return venv_path, venv_name, venv_root
        end
      end

      return nil, nil, nil
    end

    local function get_python_path(workspace)
      local _, _, venv_root = get_python_venv(workspace)
      if venv_root then
        local candidates = {
          venv_root .. "/bin/python",
          venv_root .. "/bin/python3",
          venv_root .. "/Scripts/python.exe",
        }
        for _, path in ipairs(candidates) do
          if vim.fn.filereadable(path) == 1 then
            return path
          end
        end
      end

      local system_candidates = { "python3.12", "python3.11", "python3", "python" }
      for _, name in ipairs(system_candidates) do
        local system_python = vim.fn.exepath(name)
        if system_python ~= "" then
          return system_python
        end
      end

      return "python"
    end

    local function get_venv_site_packages(venv_root)
      if not venv_root or venv_root == "" then
        return {}
      end
      local site_packages = {}
      local patterns = { "lib/python*/site-packages", "Lib/site-packages" }
      for _, pattern in ipairs(patterns) do
        local matches = vim.fn.globpath(venv_root, pattern, false, true)
        for _, match in ipairs(matches) do
          table.insert(site_packages, match)
        end
      end
      return site_packages
    end

    vim.lsp.config("pyright", {
      capabilities = capabilities,
      root_dir = function(fname)
        return lsp_util.root_pattern(
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          ".venv",
          "venv",
          ".git"
        )(fname) or lsp_util.path.dirname(fname)
      end,
      on_new_config = function(config, root_dir)
        local python_path = get_python_path(root_dir)
        local venv_path, venv_name, venv_root = get_python_venv(root_dir)
        config.settings = config.settings or {}
        config.settings.python = config.settings.python or {}
        config.settings.python.pythonPath = python_path
        config.settings.python.defaultInterpreterPath = python_path
        config.settings.python.analysis = config.settings.python.analysis or {}
        config.settings.python.analysis.extraPaths = config.settings.python.analysis.extraPaths or {}
        if venv_path and venv_name then
          config.settings.python.venvPath = venv_path
          config.settings.python.venv = venv_name
        end
        for _, path in ipairs(get_venv_site_packages(venv_root)) do
          table.insert(config.settings.python.analysis.extraPaths, path)
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
