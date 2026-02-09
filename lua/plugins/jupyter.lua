return {
  {
    "dccsillag/magma-nvim",
    build = ":UpdateRemotePlugins",
    config = function()
      vim.g.magma_automatically_open_output = true
      vim.g.magma_image_provider = "none"
      vim.g.magma_cell_highlight_group = "NotebookCellHighlight"

      vim.keymap.set("n", "<leader>mi", ":MagmaInit<CR>", { desc = "Magma init" })
      vim.keymap.set("n", "<leader>mR", ":MagmaRestart!<CR>", { desc = "Magma restart" })
      vim.keymap.set("n", "<leader>mo", ":MagmaShowOutput<CR>", { desc = "Magma show output" })
      vim.keymap.set("n", "<leader>ml", ":MagmaEvaluateLine<CR>", { desc = "Magma eval line" })
      vim.keymap.set("n", "<leader>mc", ":MagmaReevaluateCell<CR>", { desc = "Magma re-eval cell" })
      vim.keymap.set("n", "<leader>md", ":MagmaDelete<CR>", { desc = "Magma delete cell" })
      vim.keymap.set("n", "<leader>mr", ":MagmaEvaluateOperator<CR>", { desc = "Magma eval motion" })
      vim.keymap.set("v", "<leader>mv", ":<C-u>MagmaEvaluateVisual<CR>", { desc = "Magma eval visual" })

      local function magma_eval_buffer()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd("normal! ggVG")
        vim.cmd("MagmaEvaluateVisual")
        vim.fn.setpos(".", save_cursor)
      end

      vim.keymap.set("n", "<leader>mA", magma_eval_buffer, { desc = "Magma eval buffer" })

      vim.api.nvim_set_hl(0, "NotebookCellSeparator", { link = "Comment" })
      vim.api.nvim_set_hl(0, "NotebookCellMarker", { link = "Visual" })
      vim.api.nvim_set_hl(0, "NotebookCellTitle", { link = "Title" })
      vim.api.nvim_set_hl(0, "NotebookCellHighlight", { link = "CursorLine" })

      local cell_ns = vim.api.nvim_create_namespace("NotebookBlocks")
      local cell_group = vim.api.nvim_create_augroup("NotebookBlocks", { clear = true })

      local function is_cell_marker(line)
        return line:match("^%s*#%s*%%")
          or line:match("^%s*#%s*In%[")
          or line:match("^%s*//%s*%%")
          or line:match("^%s*%-%-%s*%%")
      end

      local function render_notebook_blocks(bufnr)
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        vim.api.nvim_buf_clear_namespace(bufnr, cell_ns, 0, -1)

        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local win_width = vim.api.nvim_win_get_width(0)
        local separator = string.rep("─", math.max(10, win_width - 4))

        for index, line in ipairs(lines) do
          if is_cell_marker(line) then
            vim.api.nvim_buf_set_extmark(bufnr, cell_ns, index - 1, 0, {
              hl_group = "NotebookCellMarker",
              end_col = #line,
              virt_lines = { { { separator, "NotebookCellSeparator" } } },
              virt_lines_above = true,
              virt_text = { { "󰯴 Cell", "NotebookCellTitle" } },
              virt_text_pos = "eol",
            })
          end
        end
      end

      local function attach_notebook_blocks(bufnr)
        render_notebook_blocks(bufnr)

        vim.api.nvim_create_autocmd(
          { "BufEnter", "BufWritePost", "TextChanged", "TextChangedI", "WinResized" },
          {
            group = cell_group,
            buffer = bufnr,
            callback = function()
              render_notebook_blocks(bufnr)
            end,
          }
        )
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = cell_group,
        pattern = { "python", "r", "julia", "markdown", "quarto" },
        callback = function(args)
          attach_notebook_blocks(args.buf)
        end,
      })
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
