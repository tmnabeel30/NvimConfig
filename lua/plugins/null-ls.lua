return {
  "nvimtools/none-ls.nvim",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local ruff_diagnostics = require("none-ls.diagnostics.ruff")
    local ruff_actions = require("none-ls.code_actions.ruff")

    null_ls.setup({
      sources = {
        -- ==========================================
        -- FORMATTERS + LINTING
        -- ==========================================
        
        -- Lua
        null_ls.builtins.formatting.stylua,

        -- JavaScript/TypeScript
        null_ls.builtins.formatting.prettier.with({
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "css",
            "html",
            "json",
            "yaml",
            "markdown",
          },
        }),

        -- Python
        null_ls.builtins.formatting.black.with({
          extra_args = { "--line-length", "88" },
        }),
        null_ls.builtins.formatting.isort,
        ruff_diagnostics,
        ruff_actions,

        -- C/C++
        null_ls.builtins.formatting.clang_format,
      },
      
      -- Auto-format on save (optional)
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })

    -- Format current file keybinding
    vim.keymap.set("n", "<leader>gf", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format current file" })
  end,
}
