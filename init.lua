-- =========================================
-- 🚀 Nabeel's Neovim Init.lua
-- =========================================

-- Leader keys (do this BEFORE lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =========================================
-- 📦 lazy.nvim bootstrap
-- =========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- =========================================
-- ⚙️ Core settings
-- =========================================
require("config.options")

-- =========================================
-- 🔌 Plugins (THIS is the key line)
-- =========================================
require("lazy").setup("plugins", {
  ui = {
    border = "rounded",
  },
  change_detection = {
    notify = false,
  },
})

-- =========================================
-- 🎉 Done. Go code.
-- =========================================
