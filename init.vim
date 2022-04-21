
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
set laststatus=2

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
nnoremap <C-[><C-[> :nohl<CR>
nnoremap v* *:vimgrep /<C-r>// **/*.{ts,tsx,vue}<CR>

" Keymap(coc)
" nnoremap <silent> K :call <SID>show_documentation()<CR>
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Auto commands
autocmd BufWritePost :call CocAction('eslint.executeAutofix')
augroup HTML
  autocmd!
  autocmd Filetype vue inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" Short cuts
command! Format :call CocAction('eslint.executeAutofix')

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

Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'
Plug 'LumaKernel/ddc-file'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
Plug 'Shougo/ddc-converter_remove_overlap'
Plug 'Shougo/ddc-nvim-lsp'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive' 

Plug 'jose-elias-alvarez/null-ls.nvim'

call plug#end()

so ~/.config/nvim/config/import.vim
