" ---------------------------------------------------------------------------
"
" vim-test
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('vim-test') || exists('g:did_cfg_vim_test')
    finish
endif
let g:did_cfg_vim_test = 1

if dotfiles#plugin#selected('vim-dispatch')
    let test#strategy = 'dispatch'
endif
let g:test#preserve_screen = 1

" Default options for go test
let g:test#go#gotest#options = '-timeout 30s'

nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>
