local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', 'ff', "<cmd>lua require('telescope.builtin').find_files()<CR>", opts)
vim.api.nvim_set_keymap('n', 'fw', "<cmd>lua require('telescope.builtin').live_grep()<CR>", opts)
vim.api.nvim_set_keymap('n', 'fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", opts)
vim.api.nvim_set_keymap('n', 'fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", opts)
vim.api.nvim_set_keymap('n', 'fg', "<cmd>lua require('telescope.builtin').git_files()<CR>", opts)
