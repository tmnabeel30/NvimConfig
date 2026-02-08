# Python + Neovim Setup Guide

This configuration uses **Pyright** for type-checking, **Ruff** for linting/code actions, and **Black + isort** for formatting. Debugging is handled by **nvim-dap** with **debugpy**.

## Quick Start
1. Open Neovim and run `:Mason` to verify all tools are installed.
2. Open a Python file and check `:LspInfo` to confirm **pyright** and **ruff** are attached.
3. Use `<leader>gf` to format the current file.

## Daily Workflow
- **Diagnostics (errors/warnings):**
  - Inline diagnostics and gutter signs are enabled.
  - Use `:lua vim.diagnostic.open_float()` to see the diagnostic under the cursor.
- **Formatting:**
  - Automatic format-on-save is enabled.
  - Manual format: `<leader>gf`
- **Code Actions:**
  - Use `<leader>ca` for fixes (Ruff provides quick fixes where possible).
- **Go to Definition:**
  - `gd` (definition), `gD` (declaration), `gr` (references), `K` (hover).

## Debugging (Python)
- **Toggle breakpoint:** `<leader>b`
- **Start/continue debugging:** `<leader>c`
- **Step over/into/out:** `<leader>so`, `<leader>si`, `<leader>su`
- **Toggle UI:** `<leader>du`

If you want to debug libraries, use the **Launch file (include libraries)** configuration in the DAP menu.

## Maintenance Tips
- **Update tools:** open `:Mason` and press `U` to update all packages.
- **Check tool status:**
  - `:LspInfo` (LSP attachments)
  - `:NullLsInfo` (formatters/linters)
- **Python environment:** make sure your project virtualenv is active before launching Neovim if you rely on local packages.

## Common Issues
- **Diagnostics look wrong or missing:** run `:LspInfo` and ensure **pyright** and **ruff** are attached.
- **Formatting not working:** run `:NullLsInfo` and ensure **black** and **isort** are installed via Mason.
