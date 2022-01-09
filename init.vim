
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
colorscheme molokai

" Search
set ignorecase
set smartcase
set wildignore+=node_modules/**,
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" Filer
filetype plugin on
let g:netrw_winsize = 35
let g:netrw_browse_split = 3
let g:netrw_banner=0

" Insert
set tabstop=2
set shiftwidth=2
set smartindent

" Keymap
nnoremap <C-p> gT
nnoremap <C-n> gt

" Keymap(coc)
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'cohama/lexima.vim'
Plug 'tpope/vim-commentary'

call plug#end()

