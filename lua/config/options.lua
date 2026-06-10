vim.cmd("filetype plugin on")
vim.cmd("lang en_US.UTF-8")

vim.g.netrw_winsize = 35
vim.g.netrw_browse_split = 3
vim.g.netrw_banner = 0
vim.g.netrw_localmovecmd = "mv"

vim.opt.swapfile = false

vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf-8,iso-2022-jp,cp932,euc-jp,default,latin"
vim.opt.fileformats = "unix,dos,mac"

vim.opt.number = true
vim.opt.incsearch = true
vim.opt.background = "dark"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.cmd("colorscheme molokai")
-- molokai は treesitter 以前のテーマで @variable 未定義のため、放置すると
-- Neovim 組み込みデフォルトの薄グレーにフォールバックして見づらい。
-- monokai 流儀どおり変数は地の白 (#F8F8F2) にする。
vim.api.nvim_set_hl(0, "@variable", { fg = "#F8F8F2" })
vim.opt.laststatus = 2
vim.opt.updatetime = 2000

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignore:append({
  "*/node_modules/**",
  "/node_modules/**",
  "*/dist/**",
  "*/.nuxt/**",
  "yarn.lock",
  "package-lock.json",
  "**/coverage/**",
})

vim.opt.clipboard = "unnamed"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.g.goimports = 1
vim.g.goimports_simplify = 1
