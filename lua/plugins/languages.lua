return {
  {
    "mattn/vim-goimports",
    ft = "go",
  },

  {
    "jparise/vim-graphql",
    ft = { "graphql", "graphqls" },
  },

  {
    "prettier/vim-prettier",
    build = "yarn install --frozen-lockfile --production",
    ft = {
      "javascript", "typescript", "css", "less", "scss", "json", "graphql",
      "markdown", "vue", "svelte", "yaml", "html", "typescriptreact",
    },
    init = function()
      vim.g["prettier#autoformat_config_present"] = 1
      vim.g["prettier#config#config_precedence"] = "prefer-file"
      vim.g["prettier#autoformat"] = 0
    end,
    config = function()
      vim.cmd([[
        if filereadable(findfile('.prettierrc.js', '.;')) || filereadable(findfile('.prettierrc.cjs', '.;')) || filereadable(findfile('.prettierrc', '.;'))
          augroup PRETTIER
            autocmd!
            autocmd BufWritePre *.js,*.jsx,*mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier
          augroup END
        endif
      ]])
      vim.keymap.set("n", "<Space>p", "<cmd>Prettier<CR>", { noremap = true, silent = true })
    end,
  },

  {
    "tidalcycles/vim-tidal",
    ft = "tidal",
    init = function()
      vim.g.tidal_ghci = "stack exec ghci --"
    end,
  },

  -- {
  --   "jalvesaq/Nvim-R",
  --   ft = "r",
  --   init = function()
  --     vim.g.maplocalleader = ","
  --     vim.g.r_indent_align_args = 0
  --     vim.g.r_indent_ess_comments = 0
  --     vim.g.r_indent_ess_compatible = 0
  --   end,
  -- },
}
