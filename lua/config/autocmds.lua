vim.cmd("autocmd QuickfixCmdPost make,grep,grepadd,vimgrep copen")

local au_group = vim.api.nvim_create_augroup("QUICK_FIX", { clear = true })
vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "quickfix" then
      vim.cmd("ccl")
    end
  end,
  group = au_group,
})
