" Vim settings
set noswapfile

" Word encording
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double

" Display
set number
set incsearch
set background=dark
set cursorline
" colorscheme xcodewwdc
set termguicolors
let ayucolor="dark"
colorscheme ayu
set laststatus=2
set updatetime=2000

" Search
set ignorecase
set smartcase
set wildignore+=*/node_modules/**,/node_modules/**,*/dist/**,*/.nuxt/**,yarn.lock,package-lock.json,**/coverage/**
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" Filer
filetype plugin on
let g:netrw_winsize = 35
let g:netrw_browse_split = 3
let g:netrw_banner=0
let g:netrw_localmovecmd="mv"

" Normal
set clipboard=unnamed

" Insert
set expandtab
set tabstop=2
set shiftwidth=2
set smartindent

" Keymap
nnoremap <C-p> gT
nnoremap <C-n> gt
nnoremap t1 :tabn 1<CR>
nnoremap <Esc> <Cmd>nohl<CR>
nnoremap v* *:vimgrep /<C-r>// **/*.{ts,tsx,vue}<CR>
inoremap <C-c> <Cmd>echo "'<\C-[>' を使ってnormalに戻さないやつはカス"<CR> 
vnoremap <C-c> <Cmd>echo "'<\C-[>' を使ってnormalに戻さないやつはカス"<CR> 

" Keymap(coc)
" nnoremap <silent> K :call <SID>show_documentation()<CR>
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

augroup HTML
  autocmd!
  autocmd Filetype vue inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" Coc
autocmd FileType scss setl iskeyword+=@-@

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

Plug 'airblade/vim-gitgutter'

Plug 'petertriho/nvim-scrollbar'

Plug 'weilbith/nvim-code-action-menu'
Plug 'arthurxavierx/vim-caser'
Plug 'tpope/vim-surround'
Plug 'yuttie/comfortable-motion.vim'

call plug#end()

so ~/.config/nvim/config/import.vim

" autocmd WinNew * :Fern . -reveal=% -drawer -width=40
augroup FernStart
  autocmd!
  autocmd TabNew * ++nested Fern . -reveal=% -toggle -stay -drawer -width=40
  autocmd VimEnter * ++nested Fern . -reveal=% -toggle -drawer -width=40
augroup END
