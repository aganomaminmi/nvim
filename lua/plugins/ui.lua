return {
  {
    "itchyny/lightline.vim",
    lazy = false,
    init = function()
      vim.g.lightline = {
        colorscheme = "solarized",
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

      vim.cmd([[
        highlight GitGutterAdd ctermfg=green
        highlight GitGutterChange ctermfg=blue
        highlight GitGutterDelete ctermfg=red

        highlight GitGutterAddLine ctermbg=green
        highlight GitGutterChangeLine ctermbg=blue
        highlight GitGutterDeleteLine ctermbg=red

        highlight GitGutterAddLineNr ctermbg=green
        highlight GitGutterChangeLineNr ctermbg=blue
        highlight GitGutterDeleteLineNr ctermbg=red

        highlight diffAdd ctermbg=green
        highlight diffChange ctermbg=blue
        highlight diffRemove ctermbg=red
        highlight diffAdd ctermfg=black
        highlight diffChange ctermfg=yellow
        highlight diffRemove ctermfg=yellow
      ]])
    end,
  },
}
