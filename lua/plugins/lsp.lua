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
    vim.lsp.config("pyright", {
      capabilities = capabilities,
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
