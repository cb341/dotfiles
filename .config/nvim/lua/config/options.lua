-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false
vim.opt.swapfile = false

vim.cmd([[
  abbrev railks rails
  abbrev rials rails
  abbrev raisl rails
  iabbrev teh the
  iabbrev enend end
]])

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_augroup("Git", {})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.wo.spell = true
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    if vim.fn.getline(1) == "" then
      vim.cmd("startinsert!")
    end
  end,
  group = "Git",
})
