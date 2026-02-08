---@diagnostic disable: param-type-mismatch
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",

  -- 👇 THIS is the key fix
  lazy = false,

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    -- Keymap
    vim.keymap.set(
      "n",
      "<leader>e",
      "<cmd>Neotree filesystem toggle left<CR>",
      { desc = "Toggle Neo-tree" }
    )

    -- Auto-open when starting in a directory
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local path = vim.fn.argv(0)
        if path ~= "" and vim.fn.isdirectory(path) == 1 then
          vim.cmd("Neotree filesystem reveal left")
        end
      end,
    })
  end,
}
