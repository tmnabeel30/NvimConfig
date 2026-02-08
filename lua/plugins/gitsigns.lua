return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local keymap = vim.keymap.set
        local opts = { buffer = bufnr }

        keymap("n", "]c", "<cmd>Gitsigns next_hunk<CR>", opts)
        keymap("n", "[c", "<cmd>Gitsigns prev_hunk<CR>", opts)
      end,
    })
  end,
}
