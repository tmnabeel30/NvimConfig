-- ==========================================
-- KEYMAPS (k/j swap)
-- ==========================================
vim.keymap.set("n", "k", "j", { noremap = true, silent = true })
vim.keymap.set("n", "j", "k", { noremap = true, silent = true })

-- ==========================================
-- WINDOW RESIZE SHORTCUTS
-- ==========================================
-- Resize vertically (height)
vim.keymap.set("n", "<C-Up>", ":resize +5<CR>", { noremap = true, silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -5<CR>", { noremap = true, silent = true, desc = "Decrease window height" })

-- Resize horizontally (width)
vim.keymap.set(
	"n",
	"<C-Right>",
	":vertical resize +5<CR>",
	{ noremap = true, silent = true, desc = "Increase window width" }
)
vim.keymap.set(
	"n",
	"<C-Left>",
	":vertical resize -5<CR>",
	{ noremap = true, silent = true, desc = "Decrease window width" }
)

-- Alternative: Use leader key
vim.keymap.set("n", "<leader>+", ":resize +10<CR>", { noremap = true, silent = true, desc = "Increase height by 10" })
vim.keymap.set("n", "<leader>-", ":resize -10<CR>", { noremap = true, silent = true, desc = "Decrease height by 10" })
vim.keymap.set(
	"n",
	"<leader>>",
	":vertical resize +10<CR>",
	{ noremap = true, silent = true, desc = "Increase width by 10" }
)
vim.keymap.set(
	"n",
	"<leader><",
	":vertical resize -10<CR>",
	{ noremap = true, silent = true, desc = "Decrease width by 10" }
)

-- Equalize all windows
vim.keymap.set("n", "<leader>=", "<C-w>=", { noremap = true, silent = true, desc = "Equalize all windows" })

-- Maximize current window
vim.keymap.set(
	"n",
	"<leader>m",
	":resize<CR>:vertical resize<CR>",
	{ noremap = true, silent = true, desc = "Maximize window" }
)

-- ==========================================
-- GENERAL SETTINGS
-- ==========================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

-- ==========================================
-- GLOBAL INDENTATION (Default for all files)
-- ==========================================
vim.opt.expandtab = true -- Use spaces, not tabs
vim.opt.shiftwidth = 4 -- 4 spaces for indentation
vim.opt.tabstop = 4 -- Tab shows as 4 spaces
vim.opt.softtabstop = 4 -- 4 spaces when pressing Tab
vim.opt.smartindent = true
vim.opt.autoindent = true

-- ==========================================
-- SEARCH
-- ==========================================
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- ==========================================
-- UI/UX
-- ==========================================
vim.opt.scrolloff = 8
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.signcolumn = "yes"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ==========================================
-- PYTHON INDENTATION (STRICT 4 SPACES)
-- ==========================================
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.autoindent = true
		vim.opt_local.smartindent = false
		vim.opt_local.cindent = false
		vim.opt_local.textwidth = 88
		vim.opt_local.colorcolumn = "88"
	end,
})

-- ==========================================
-- KEYBINDINGS FOR INDENTATION FIXES
-- ==========================================
vim.keymap.set("n", "<leader>fi", function()
	local save_cursor = vim.fn.getpos(".")
	vim.cmd("normal! gg=G")
	vim.fn.setpos(".", save_cursor)
end, { desc = "Fix indentation" })

vim.keymap.set("n", "<leader>ts", function()
	vim.cmd("set expandtab")
	vim.cmd("retab")
	print("Converted tabs to spaces")
end, { desc = "Tabs to spaces" })

vim.keymap.set("n", "<leader>fw", function()
	local save_cursor = vim.fn.getpos(".")
	vim.cmd([[%s/\s\+$//e]])
	vim.fn.setpos(".", save_cursor)
	print("Removed trailing whitespace")
end, { desc = "Remove trailing whitespace" })

vim.keymap.set("n", "<leader>sw", function()
	vim.opt.list = not vim.opt.list:get()
	if vim.opt.list:get() then
		print("Showing whitespace")
	else
		print("Hiding whitespace")
	end
end, { desc = "Toggle whitespace visibility" })

-- ==========================================
-- AUTO-CONVERT TABS ON SAVE (Python only)
-- ==========================================
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.py",
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd("silent! %s/\\t/    /ge")
		vim.fn.setpos(".", save_cursor)
	end,
})
