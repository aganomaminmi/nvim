return {
  "github/copilot.vim",
  event = "InsertEnter",
  init = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_node_command = vim.fn.expand("~/.nodenv/shims/node")
    vim.b.copilot_enabled = 1
  end,
  config = function()
    local keymap = vim.keymap.set
    keymap("i", "<C-l>", 'copilot#Accept("<CR>")', {
      silent = true,
      expr = true,
      script = true,
      replace_keycodes = false,
    })
    keymap("i", "<C-j>", "<Plug>(copilot-next)")
    keymap("i", "<C-k>", "<Plug>(copilot-previous)")
    keymap("i", "<C-o>", "<Plug>(copilot-dismiss)")
    keymap("i", "<C-s>", "<Plug>(copilot-suggest)")
  end,
}
