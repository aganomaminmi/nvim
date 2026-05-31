vim.cmd('autocmd QuickfixCmdPost make,grep,grepadd,vimgrep copen')

-- vim.cmd([[
--   augroup HTML_TAG
--     autocmd!
--     autocmd Filetype html,vue,tsx inoremap <buffer> >/ ></<C-x><C-o><ESC>F>a<CR><ESC>O
--     autocmd Filetype html,vue,tsx inoremap <buffer> >< ></<C-x><C-o><ESC>F>a
--   augroup END
-- ]])

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

