return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local parsers = {
      "lua", "vim", "vimdoc", "query",
      "markdown", "markdown_inline",
      "bash", "json", "yaml", "toml",
      "javascript", "typescript", "tsx",
      "vue", "html", "css", "scss",
      "go", "graphql",
    }

    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
