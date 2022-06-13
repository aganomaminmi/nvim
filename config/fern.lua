local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<C-e>', '<cmd>Fern . -reveal=% -drawer -toggle -width=40<CR>', opts)

vim.g['fern#default_hidden'] = 1
vim.cmd([[
  augroup my-glyph-palette
    autocmd! *
    autocmd FileType fern call glyph_palette#apply()
    autocmd FileType nerdtree,startify call glyph_palette#apply()
  augroup END
]])
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(fern-action-grep)', opts)

vim.cmd([[
  function! s:fern_preview() abort
    nnoremap <silent> <buffer> p <Plug>(fern-action-preview:toggle)
    nnoremap <silent> <buffer> <Space>p <Plug>(fern-action-preview:auto:toggle)
    nnoremap <silent> <buffer> <C-f> <Plug>(fern-action-preview:scroll:down:half)
    nnoremap <silent> <buffer> <C-b> <Plug>(fern-action-preview:scroll:up:half)
  endfunction

  augroup FernPreviewStart
    autocmd!
    autocmd FileType fern call s:fern_preview()
  augroup END
]])

vim.cmd([[
  augroup FernStart
    autocmd!
    autocmd TabNew * ++nested Fern . -reveal=% -toggle -stay -drawer -width=40
    autocmd VimEnter * ++nested Fern . -reveal=% -toggle -drawer -width=40
  augroup END
]])

Fern_preview = function()
  local opt = { silent = true, buffer = true }
  vim.keymap.set('n', 'p', '<Plug>(fern-action-preview:toggle)', opt)
  vim.keymap.set('n', '<C-p>', '<Plug>(fern-action-preview:auto:toggle)', opt)
  vim.keymap.set('n', '<C-f>', '<Plug>(fern-action-preview:scroll:down:half)', opt)
  vim.keymap.set('n', '<C-b>', '<Plug>(fern-action-preview:scroll:up:half)', opt)
end

