vim.cmd('nnoremap <silent> K :call <SID>show_documentation()<CR>')
vim.cmd('nnoremap <silent> gd <Plug>(coc-definition)')
vim.cmd('nnoremap <silent> gy <Plug>(coc-type-definition)')
vim.cmd('nnoremap <silent> gi <Plug>(coc-implementation)')
vim.cmd('nnoremap <silent> gr <Plug>(coc-references)')
vim.cmd([[
  augroup COC
    autocmd!
    autocmd FileType scss setl iskeyword+=@-@
  augroup END
]])
