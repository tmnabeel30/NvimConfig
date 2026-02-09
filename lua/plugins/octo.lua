return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      enable_builtin = true,
    })

    local keymap = vim.keymap.set
    keymap("n", "<leader>gO", "<cmd>Octo<CR>", { desc = "Octo" })
    keymap("n", "<leader>gpr", "<cmd>Octo pr list<CR>", { desc = "Octo PR list" })
    keymap("n", "<leader>gpi", "<cmd>Octo issue list<CR>", { desc = "Octo issue list" })
  end,
}
