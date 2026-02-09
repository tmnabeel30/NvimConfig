# MyNvim Configuration

This repository contains a personal [Neovim](https://neovim.io/) configuration written in Lua. It uses [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager and includes a collection of plugins and settings aimed at modern C++ and Java development.

## Features

- **Core options**: relative line numbers, system clipboard, smart indentation, persistent undo, and more.
- **Plugin management**: automatic installation and setup through `lazy.nvim`.
- **User interface**
  - `kanagawa.nvim` colorscheme
  - File explorer via `nvim-tree`
  - Fuzzy finding with `telescope.nvim`
  - Automatic bracket/quote pairing using `nvim-autopairs`
  - Code highlighting and text objects powered by `nvim-treesitter`
- **Git integration**: `gitsigns.nvim`, `vim-fugitive`, `octo.nvim` for GitHub issues/PRs, plus `git-conflict.nvim` for resolving merge conflicts directly in Neovim (including Azure DevOps repos).
- **LSP and completion**
  - `mason.nvim` to install language servers
  - `nvim-lspconfig` with preset servers including `clangd`, `lua_ls`, `bashls`, `yamlls` and `jsonls`
  - Autocompletion through `nvim-cmp` and `LuaSnip`
  - Preconfigured `clangd` command to correctly resolve standard library headers
- **Debugging**: `nvim-dap`, `nvim-dap-ui`, `nvim-dap-python`, and `nvim-dap-virtual-text`.
- **Python workflow**: `pyright`, `ruff`, `black`, `isort`, `mypy`, plus `neotest` with the pytest adapter.
- **Java support**: `nvim-jdtls` with an auto-generated ftplugin and a helper to run Spring Boot applications (`<leader>sr`).
- **LeetCode integration**: `leetcode.nvim` for practicing coding problems.
- **Key mappings**
  - `<C-n>` toggles the tree view
  - `<C-p>` opens file search
  - `<F5>` compiles and runs the current C++ file
  - `<leader>b` / `<leader>d` / `<leader>n` for debugging commands
  - `<leader>tt` / `<leader>tT` / `<leader>ts` / `<leader>to` for Python test runs and output
  - Merge conflict resolution:
    - `<leader>gco` keep ours
    - `<leader>gct` keep theirs
    - `<leader>gcb` keep both
    - `<leader>gcn` keep none
    - `[x` / `]x` jump to previous/next conflict
- **Autocommands**
  - Automatically saves buffers on leave or focus lost
  - Provides a basic C++ template when creating a new `*.cpp` file
  - Treats `.h` and `.hpp` as C++ headers
- **Miscellaneous**
  - `dapui` automatically opens and closes alongside debugging sessions
  - Prints a confirmation message when the configuration loads

## Usage

Place `init.lua` in your Neovim configuration directory and start Neovim. The plugin manager will install missing plugins on first run.

### Python DAP .venv selection

If you want DAP to use a project `.venv` (when it contains `debugpy`), set one of these globals before plugins load:

```lua
-- Always prefer .venv when present
vim.g.dap_python_venv = true

-- Or prompt each time a .venv is detected
vim.g.dap_python_venv = "prompt"
```

### Python testing

- Run nearest test: `<leader>tt`
- Run current file: `<leader>tT`
- Stop current run: `<leader>ts`
- Open last test output: `<leader>to`

### GitHub issues/PRs with Octo.nvim

`octo.nvim` uses the GitHub CLI (`gh`) for authentication. After installing `gh`, run:

```sh
gh auth login
```

Then in Neovim:

- Open the Octo command picker: `<leader>gO`
- List pull requests: `<leader>gpr`
- List issues: `<leader>gpi`
