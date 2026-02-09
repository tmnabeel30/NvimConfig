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
      local function resolve_jupytext_command()
        if vim.fn.executable("jupytext") == 1 then
          return "jupytext"
        end

        local python = vim.fn.exepath("python3")
        if python == "" then
          python = vim.fn.exepath("python")
        end

        if python ~= "" then
          vim.fn.system({ python, "-m", "jupytext", "--version" })
          if vim.v.shell_error == 0 then
            return python .. " -m jupytext"
          end
        end

        return nil
      end

      local jupytext_command = resolve_jupytext_command()
      if not jupytext_command then
        vim.notify(
          "jupytext.nvim: jupytext CLI not found. Install with `pip install jupytext`.",
          vim.log.levels.WARN
        )
        return
      end

      local commands = require("jupytext.commands")
      commands.run_jupytext_command = function(input_file, options)
        local cmd = jupytext_command .. " " .. input_file .. " "
        for option_name, option_value in pairs(options) do
          if option_value ~= "" then
            cmd = cmd .. option_name .. "=" .. option_value .. " "
          else
            cmd = cmd .. option_name .. " "
          end
        end

        local output = vim.fn.system(cmd)

        if vim.v.shell_error ~= 0 then
          print(output)
          vim.api.nvim_err_writeln(cmd .. ": " .. vim.v.shell_error)
        end
      end

      require("jupytext").setup({
        style = "hydrogen",
        output_extension = "auto",
      })
    end,
  },
}
