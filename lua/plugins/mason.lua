return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    -- Install LSP servers
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "jsonls",
        "pyright",
        "bashls",
        "yamlls",
        "clangd",
      },
      automatic_installation = true,
      handlers = {},
    })

    -- Install debuggers and formatters
    local mason_registry = require("mason-registry")
    local packages = {
      "debugpy",            -- Python debugger
      "codelldb",           -- C/C++ debugger
      "js-debug-adapter",   -- JavaScript/TypeScript debugger
    }

    for _, package in ipairs(packages) do
      local p = mason_registry.get_package(package)
      if not p:is_installed() then
        p:install()
      end
    end
  end,
}
