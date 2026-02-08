return {
  "jay-babu/mason-null-ls.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
  config = function()
    require("mason-null-ls").setup({
      ensure_installed = {
        "black",
        "isort",
        "ruff",
        "stylua",
        "prettier",
        "clang-format",
      },
      automatic_installation = true,
    })
  end,
}
