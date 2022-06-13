-- Vim settings
-- noswapfile
vim.opt.swapfile = false

-- Word encording
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'ucs-boms,utf-8,euc-jp,cp932'
vim.opt.fileformats = 'unix,dos,mac'
vim.opt.ambiwidth = 'double'

-- Display
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.background = 'dark'
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.cmd('let ayucolor = "dark"')
vim.cmd('colorscheme ayu')
vim.opt.laststatus = 2
vim.opt.updatetime = 2000

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignore:append(',*/node_modules/**,/node_modules/**,*/dist/**,*/.nuxt/**,yarn.lock,package-lock.json,**/coverage/**')

-- other
vim.opt.clipboard = 'unnamed'
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- comfortable motion
vim.cmd([[
  let g:comfortable_motion_scroll_down_key = "j"
  let g:comfortable_motion_scroll_up_key = "k"
  let g:comfortable_motion_interval = 1000.0/20
  let g:comfortable_motion_friction = 200.0
  let g:comfortable_motion_air_drag = 0.0
]])
