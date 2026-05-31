local set = vim.keymap.set
local opts = { noremap = true }

set("n", "<C-p>", "gT", opts)
set("n", "<C-n>", "gt", opts)
set("n", "t1", "<Cmd>tabn 1<CR>", opts)
set("n", "<Esc>", "<Cmd>nohl<CR>", opts)
set("n", "te", "<Cmd>tabedit%<CR>", opts)

-- deskflow workaround:
-- Cmd の左右識別のため deskflow が Cmd と同時に F3/F4 を送ってくる。
-- 他アプリには影響しないが nvim では文字列として混入するため、全 mode で抑止。
for _, key in ipairs({ "<F3>", "<F4>" }) do
  set({ "n", "i", "v", "c", "t", "o", "s" }, key, "<Nop>", { noremap = true, silent = true })
end
