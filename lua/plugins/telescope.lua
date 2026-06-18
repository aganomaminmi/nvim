return {
  "nvim-telescope/telescope.nvim",
  -- tag = "0.1.4" は nvim-treesitter main の ft_to_lang 廃止と非互換のため HEAD を使う
  cmd = "Telescope",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fw", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    { "<leader>fg", "<cmd>Telescope git_files<CR>", desc = "Git files" },
  },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      pickers = {
        find_files = { theme = "dropdown" },
      },
      defaults = {
        mappings = {
          i = {
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
          },
        },
        file_ignore_patterns = { "^node_modules/" },
      },
    })
  end,
}
