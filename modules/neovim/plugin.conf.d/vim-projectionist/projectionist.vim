if !dotfiles#plugin#selected('vim-projectionist') || exists('g:did_cfg_vim_projectionist')
    finish
endif
let g:did_cfg_vim_projectionist = 1

let g:projectionist_heuristics = {
            \ "go.mod": {
            \   "*.go": {
            \     "alternate": [
            \       "{}_test.go",
            \       "{}_internal_test.go"
            \     ],
            \     "type": "source"
            \   },
            \   "*_test.go": {
            \     "alternate": "{}.go",
            \     "type": "test"
            \   },
            \   "*_internal_test.go": {
            \     "alternate": "{}.go",
            \     "type": "test"
            \   }
            \ }}

function! s:configure_projectionist()
    nnoremap <silent> <buffer> <c-^> :A<cr>
endfunction

augroup dotfiles_projectionist
    autocmd!
    autocmd User ProjectionistActivate call s:configure_projectionist()
augroup END
