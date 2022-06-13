vim.cmd('autocmd QuickfixCmdPost make,grep,grepadd,vimgrep copen')

vim.cmd([[
  augroup HTML_TAG
    autocmd!
    autocmd Filetype html,vue,tsx inoremap <buffer> >/ ></<C-x><C-o><ESC>F>a<CR><ESC>O
    autocmd Filetype html,vue,tsx inoremap <buffer> >< ></<C-x><C-o><ESC>F>a
  augroup END
]])
