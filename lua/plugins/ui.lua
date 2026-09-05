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
    -- インデントガイド。treesitter でカーソル位置のスコープ (ネスト) だけ
    -- 色を変えて強調する。アニメーションなしの静的表示。
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3B3A32" })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#66D9EF" })
      require("ibl").setup({
        indent = { char = "▏" },
        scope = {
          show_start = false, -- スコープ先頭行への下線は出さない
          show_end = false,
        },
      })
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
      pipe_table = { enabled = false },
    },
  },

  {
    "ice345/markdown-table-wrap.nvim",
    ft = { "markdown" },
    config = function()
      require("markdown-table-wrap").setup()

      local table_mode = "wrap" -- "wrap" or "original"

      vim.keymap.set("n", "<leader>t", function()
        local ok, rm = pcall(require, "render-markdown")
        if not ok then
          vim.notify("render-markdown.nvim がロードされていません", vim.log.levels.WARN)
          return
        end

        if table_mode == "wrap" then
          -- 編集モード: markdown-table-wrap をオフにし、render-markdown のテーブル表示を有効化
          vim.cmd("MarkdownTableDisableAutoPreview")
          rm.setup({ pipe_table = { enabled = true } })
          table_mode = "original"
          vim.notify("Table mode: Original (render-markdown)", vim.log.levels.INFO)
        else
          -- 閲覧モード: render-markdown のテーブル表示をオフにし、markdown-table-wrap を有効化
          rm.setup({ pipe_table = { enabled = false } })
          vim.cmd("MarkdownTableEnableAutoPreview")
          table_mode = "wrap"
          vim.notify("Table mode: Wrapped (markdown-table-wrap)", vim.log.levels.INFO)
        end
      end, { desc = "Toggle Markdown Table View Mode (Wrap / Original)" })
    end,
  },

  {
    -- バッファ内描画 (render-markdown) では折り返せない広いテーブル等を
    -- ブラウザで確認するための preview。<leader>m でトグル。
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_auto_close = 0 -- バッファ移動で勝手に閉じない
      vim.g.mkdp_theme = "dark"
      vim.g.mkdp_preview_options = {
        mkit = {
          html = true,
        },
      }
    end,
    keys = {
      {
        "<leader>m",
        "<cmd>MarkdownPreviewToggle<cr>",
        ft = "markdown",
        desc = "Markdown Preview Toggle",
      },
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
