call ddc#custom#patch_global('completionMenu', 'pum.vim')
call ddc#custom#patch_global('backspaceCompletion', 'v:true')
call ddc#custom#patch_global('sources', ['nvim-lsp', 'around', 'file', 'vsnip'])
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank'],
      \   'minAutoCompleteLength': 1 },
      \ 'vsnip': {
      \   'mark': 'Snip',
      \   'dup': v:true },
      \ 'nvim-lsp': {
      \   'mark': 'LSP',
      \   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
      \ 'around': { 'mark': 'Around' },
      \ 'file': {
      \   'mark': 'File',
      \   'isVolatile': v:true, 
      \   'forceCompletionPattern': '\S/\S*',
      \ }})
call ddc#custom#patch_global('sourceParams', {
    \ 'around': {'maxSize': 300},
    \ })
call ddc#custom#patch_global('autoCompleteEvents', [
    \ 'InsertEnter', 'TextChangedI', 'TextChangedP',
    \ 'CmdlineEnter', 'CmdlineChanged',
    \ ])

autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)

inoremap <expr> <C-n> pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : ddc#manual_complete()
inoremap <C-p> <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
inoremap <expr> <CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
inoremap <silent><expr> <C-[> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<C-[>'

inoremap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
snoremap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
inoremap <expr> <C-f> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-f>'
snoremap <expr> <C-f> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-f>'
inoremap <expr> <C-b> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-b>'
snoremap <expr> <C-b> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-b>'
let g:vsnip_filetypes = {}

call ddc#enable()
call popup_preview#enable()
call signature_help#enable()
