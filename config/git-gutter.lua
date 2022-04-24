local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('', 'gh', '<cmd>GitGutterLineHighlightsToggle<CR>', opts)
vim.api.nvim_set_keymap('', 'gp', '<cmd>GitGutterPreviewHunk<CR>', opts)
vim.api.nvim_set_keymap('', 'gf', '<cmd>GitGutterDiffOrig<CR>', opts)

vim.cmd[[highlight GitGutterAdd ctermfg=green]]
vim.cmd[[highlight GitGutterChange ctermfg=blue]]
vim.cmd[[highlight GitGutterDelete ctermfg=red]]

vim.cmd[[highlight GitGutterAddLine ctermbg=green]]
vim.cmd[[highlight GitGutterChangeLine ctermbg=blue]]
vim.cmd[[highlight GitGutterDeleteLine ctermbg=red]]

vim.cmd[[highlight GitGutterAddLineNr ctermbg=green]]
vim.cmd[[highlight GitGutterChangeLineNr ctermbg=blue]]
vim.cmd[[highlight GitGutterDeleteLineNr ctermbg=red]]

vim.cmd[[highlight diffAdd ctermbg=green]]
vim.cmd[[highlight diffChange ctermbg=blue]]
vim.cmd[[highlight diffRemove ctermbg=red]]
