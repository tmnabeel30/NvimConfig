return {
  {
    "dccsillag/magma-nvim",
    build = ":UpdateRemotePlugins",
    config = function()
      vim.g.magma_automatically_open_output = true
      vim.g.magma_image_provider = "none"

      vim.keymap.set("n", "<leader>mi", ":MagmaInit<CR>", { desc = "Magma init" })
      vim.keymap.set("n", "<leader>mR", ":MagmaRestart!<CR>", { desc = "Magma restart" })
      vim.keymap.set("n", "<leader>mo", ":MagmaShowOutput<CR>", { desc = "Magma show output" })
      vim.keymap.set("n", "<leader>ml", ":MagmaEvaluateLine<CR>", { desc = "Magma eval line" })
      vim.keymap.set("n", "<leader>mc", ":MagmaReevaluateCell<CR>", { desc = "Magma re-eval cell" })
      vim.keymap.set("n", "<leader>md", ":MagmaDelete<CR>", { desc = "Magma delete cell" })
      vim.keymap.set("v", "<leader>mv", ":<C-u>MagmaEvaluateVisual<CR>", { desc = "Magma eval visual" })
    end,
  },
  {
    "GCBallesteros/jupytext.nvim",
    config = function()
      require("jupytext").setup({
        style = "hydrogen",
        output_extension = "auto",
      })
    end,
  },
}
