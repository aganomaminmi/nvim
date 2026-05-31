local set = vim.keymap.set
local opts = { noremap = true }

set("n", "<C-p>", "gT", opts)
set("n", "<C-n>", "gt", opts)
set("n", "t1", "<Cmd>tabn 1<CR>", opts)
set("n", "<Esc>", "<Cmd>nohl<CR>", opts)
set("n", "te", "<Cmd>tabedit%<CR>", opts)
