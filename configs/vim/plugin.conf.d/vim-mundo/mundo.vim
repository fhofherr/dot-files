if !dotfiles#plugin#selected('vim-mundo') || exists('g:did_cfg_vim_mundo')
    finish
endif
let g:did_cfg_vim_mundo = 1

let g:mundo_prefer_python3 = 1
let g:mundo_right = 1
nmap <silent> <F11> :MundoToggle<cr>

" Enable persistent undo for most files. See :h persistent-undo for more info.
" This is actually a vim feature. But we keep the config in the mundo_vim file
" as it is closely related.
set undofile
augroup dotfiles_mundo_vim
    autocmd!
    autocmd BufWritePre /tmp/* setlocal noundofile
augroup END
