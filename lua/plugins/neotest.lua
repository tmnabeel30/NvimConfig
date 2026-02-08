return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-python",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-python")({
          runner = "pytest",
        }),
      },
    })

    vim.keymap.set("n", "<leader>tt", function()
      neotest.run.run()
    end, { desc = "Run nearest test" })

    vim.keymap.set("n", "<leader>tT", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "Run file tests" })

    vim.keymap.set("n", "<leader>ts", function()
      neotest.run.stop()
    end, { desc = "Stop test run" })

    vim.keymap.set("n", "<leader>to", function()
      neotest.output.open({ enter = true, auto_close = true })
    end, { desc = "Open test output" })
  end,
}
