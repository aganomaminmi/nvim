return {
  {
    "lambdalisue/fern.vim",
    enabled = false, -- oil.nvim 試用中 (plugins/oil.lua)。戻すときはこの行を消す
    lazy = false,
    dependencies = {
      "lambdalisue/glyph-palette.vim",
      "lambdalisue/fern-git-status.vim",
      "yuki-yano/fern-preview.vim",
      "lambdalisue/nerdfont.vim",
      "lambdalisue/fern-renderer-nerdfont.vim",
    },
    config = function()
      vim.g["fern#default_hidden"] = 1
      vim.g["fern#renderer"] = "nerdfont"

      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<C-e>", "<cmd>Fern . -reveal=% -drawer -toggle -width=40<CR>", opts)
      vim.keymap.set("n", "gr", "<Plug>(fern-action-grep)", opts)

      vim.cmd([[
        augroup my-glyph-palette
          autocmd! *
          autocmd FileType fern call glyph_palette#apply()
          autocmd FileType nerdtree,startify call glyph_palette#apply()
        augroup END

        function! s:fern_preview() abort
          nnoremap <silent> <buffer> p <Plug>(fern-action-preview:toggle)
          nnoremap <silent> <buffer> <Space>p <Plug>(fern-action-preview:auto:toggle)
          nnoremap <silent> <buffer> <C-f> <Plug>(fern-action-preview:scroll:down:half)
          nnoremap <silent> <buffer> <C-b> <Plug>(fern-action-preview:scroll:up:half)
        endfunction

        augroup FernPreviewStart
          autocmd!
          autocmd FileType fern call s:fern_preview()
        augroup END

        augroup FernStart
          autocmd!
          autocmd VimEnter * ++nested Fern . -reveal=% -toggle -drawer -width=40
        augroup END

        function! s:init_fern() abort
          nnoremap <Plug>(fern-close-drawer) :<C-u>FernDo close -drawer -stay<CR>
          nmap <buffer> <Plug>(fern-action-open-and-close)
                \ <Plug>(fern-action-open)<Plug>(fern-close-drawer)
          nnoremap <buffer> <CR> <Plug>(fern-action-open-or-expand)
          nnoremap <buffer> F <Plug>(fern-action-new-file)
          nnoremap <buffer> N N
          nnoremap <buffer> M M
          nnoremap <buffer> X <Plug>(fern-action-clipboard-move)
          nnoremap <buffer> D <Plug>(fern-action-remove)
        endfunction

        augroup fern-custom
          autocmd! *
          autocmd FileType fern call s:init_fern()
          autocmd FileType * set number
          autocmd FileType fern set nonumber
        augroup END
      ]])
    end,
  },
}
