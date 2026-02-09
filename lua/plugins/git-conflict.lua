return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufReadPre",
  config = function()
    require("git-conflict").setup({
      default_mappings = false,
      disable_diagnostics = true,
    })

    local keymap = vim.keymap.set
    local opts = { silent = true }

    keymap("n", "<leader>gco", "<cmd>GitConflictChooseOurs<CR>", vim.tbl_extend("force", opts, {
      desc = "Conflict: choose ours",
    }))
    keymap("n", "<leader>gct", "<cmd>GitConflictChooseTheirs<CR>", vim.tbl_extend("force", opts, {
      desc = "Conflict: choose theirs",
    }))
    keymap("n", "<leader>gcb", "<cmd>GitConflictChooseBoth<CR>", vim.tbl_extend("force", opts, {
      desc = "Conflict: choose both",
    }))
    keymap("n", "<leader>gcn", "<cmd>GitConflictChooseNone<CR>", vim.tbl_extend("force", opts, {
      desc = "Conflict: choose none",
    }))
    keymap("n", "]x", "<cmd>GitConflictNextConflict<CR>", vim.tbl_extend("force", opts, {
      desc = "Next conflict",
    }))
    keymap("n", "[x", "<cmd>GitConflictPrevConflict<CR>", vim.tbl_extend("force", opts, {
      desc = "Previous conflict",
    }))
  end,
}
