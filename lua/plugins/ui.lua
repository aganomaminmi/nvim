return {
  {
    "itchyny/lightline.vim",
    lazy = false,
    init = function()
      vim.g.lightline = {
        colorscheme = "molokai",
        active = {
          left = {
            { "mode", "paste" },
            { "gitbranch", "readonly", "modified" },
            { "readonly", "relativepath" },
          },
        },
        component_function = {
          gitbranch = "FugitiveHead",
        },
        separator = { left = "", right = "" },
        subseparator = { left = "|", right = "|" },
      }
    end,
  },

  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    opts = {
      handle = { color = "#3D3D40" },
      marks = {
        Search = { color = "#4B5632" },
        Error = { color = "#F44747" },
        Warn = { color = "#CE9178" },
        Info = { color = "#569CD6" },
        Hint = { color = "#6A9955" },
        Misc = { color = "#646695" },
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      pipe_table = { cell = "trimmed" },
    },
  },

  {
    "airblade/vim-gitgutter",
    event = "BufReadPre",
    config = function()
      local opts = { noremap = true, silent = true }
      vim.keymap.set("", "gh", "<cmd>GitGutterLineHighlightsToggle<CR>", opts)
      vim.keymap.set("", "gp", "<cmd>GitGutterPreviewHunk<CR>", opts)
      vim.keymap.set("", "gf", "<cmd>GitGutterDiffOrig<CR>", opts)
      -- 色は ayu.vim の GitGutter*/Diff* 定義に任せる
      -- (旧 cterm 指定は termguicolors 下では無効だったため削除)
    end,
  },
}
