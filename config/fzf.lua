fzf_files = function()
  local function error_handler(e)
    print('error: ', e)
  end

  local status, err = xpcall(os.execute, error_handler, 'git status')
  print(status, err)
  if err == 0 then
    vim.api.nvim_command(':GFiles')
  else
    vim.api.nvim_command(':Files')
  end
end

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', 'ff', '<cmd>lua fzf_files()<CR>', opts)
vim.api.nvim_set_keymap('n', 'fw', '<cmd>Rg<CR>', opts)
vim.api.nvim_set_keymap('n', 'fb', '<cmd>Buffers<CR>', opts)
vim.api.nvim_set_keymap('n', 'fl', '<cmd>Lines<CR>', opts)
vim.api.nvim_set_keymap('n', 'fr', 'vawy:Rg <C-R>"<CR>', opts)
vim.cmd([[
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   "rg -g '!design/' -g '!dist/' -g '!pnpm-lock.yaml' -g '!.git' -g '!node_modules' -g '!coverage' -g '!__generated__' --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
    \   fzf#vim#with_preview({'options': '--exact --delimiter : --nth 4..'}), <bang>0)
]])


