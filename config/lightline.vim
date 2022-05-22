 let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'modified' ],
    \             [ 'readonly', 'relativepath' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead',
    \ },
    \  'separator': { 'left': "", 'right': "" },
    \  'subseparator' :{ 'left': '|', 'right': '|' }
    \ }


" function! LightlineFilename()
"   let root = fnamemodify(get(b:, 'gitbranch_path'), ':h:h')
"   let path = expand('%:p')
"   if path[:len(root)-1] ==# root
"     return path[len(root)+1:]
"   endif
"   return expand('%')
" endfunction
