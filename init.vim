" Filer
filetype plugin on
let g:netrw_winsize = 35
let g:netrw_browse_split = 3
let g:netrw_banner=0
let g:netrw_localmovecmd="mv"

lang en_US.UTF-8

" VimPlug
call plug#begin('~/.vim/plugged')
Plug 'cohama/lexima.vim'
Plug 'tpope/vim-commentary'

" lsp
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

" cmp
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" depended by telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" markdown viewer (in-buffer render, glow.nvim 後継)
Plug 'MeanderingProgrammer/render-markdown.nvim'

Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'yuki-yano/fern-preview.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'

Plug 'airblade/vim-gitgutter'

Plug 'petertriho/nvim-scrollbar'

Plug 'arthurxavierx/vim-caser'
Plug 'tpope/vim-surround'

Plug 'mattn/vim-goimports'

Plug 'jparise/vim-graphql'

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html', 'typescriptreact'] }

" Plug 'jalvesaq/Nvim-R'

Plug 'github/copilot.vim'

Plug 'tidalcycles/vim-tidal'

call plug#end()

lua <<EOF
require('render-markdown').setup({
  pipe_table = { cell = 'trimmed' },
})
EOF

let g:copilot_node_command="~/.nodenv/shims/node"
let b:copilot_enabled = 1
inoremap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
" let g:copilot_no_tab_map = v:true

so ~/.config/nvim/config/import.vim
so ~/.config/nvim/autocmds.lua
so ~/.config/nvim/variables.lua
so ~/.config/nvim/mapping.lua
