" Filer
filetype plugin on
let g:netrw_winsize = 35
let g:netrw_browse_split = 3
let g:netrw_banner=0
let g:netrw_localmovecmd="mv"

" VimPlug
call plug#begin('~/.vim/plugged')
" Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'cohama/lexima.vim'
Plug 'tpope/vim-commentary'
Plug 'posva/vim-vue'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

Plug 'vim-denops/denops.vim'
Plug 'Shougo/ddc.vim'
Plug 'Shougo/ddc-around'
Plug 'LumaKernel/ddc-file'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
Plug 'Shougo/ddc-converter_remove_overlap'
Plug 'Shougo/ddc-nvim-lsp'
Plug 'matsui54/denops-popup-preview.vim'
Plug 'matsui54/denops-signature_help'
Plug 'Shougo/pum.vim'
Plug 'Shougo/deoppet.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" depended by telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive' 

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'yuki-yano/fern-preview.vim'

Plug 'airblade/vim-gitgutter'

Plug 'petertriho/nvim-scrollbar'

Plug 'weilbith/nvim-code-action-menu'
Plug 'arthurxavierx/vim-caser'
Plug 'tpope/vim-surround'
Plug 'yuttie/comfortable-motion.vim'

call plug#end()

so ~/.config/nvim/config/import.vim
so ~/.config/nvim/autocmds.lua
so ~/.config/nvim/variables.lua
so ~/.config/nvim/mapping.lua

