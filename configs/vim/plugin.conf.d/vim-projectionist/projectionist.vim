if !dotfiles#plugin#selected('vim-projectionist') || exists('g:did_cfg_vim_projectionist')
    finish
endif
let g:did_cfg_vim_projectionist = 1

function! s:configure_projectionist()
    nnoremap <silent> <buffer> <c-^> :A<cr>
endfunction

augroup dotfiles_projectionist
    autocmd!
    autocmd User ProjectionistActivate call s:configure_projectionist()
augroup END
