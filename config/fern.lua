local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<C-w>o', '<cmd>Fern . -reveal=% -drawer -toggle -width=40<CR>', opts)

vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#default_hidden'] = 1
vim.cmd([[
  augroup my-glyph-palette
    autocmd! *
    autocmd FileType fern call glyph_palette#apply()
    autocmd FileType nerdtree,startify call glyph_palette#apply()
  augroup END
]])
