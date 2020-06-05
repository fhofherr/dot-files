if !dotfiles#plugin#selected('undotree') || exists('g:did_cfg_undotree')
    finish
endif
let g:did_cfg_undotree = 1

let g:undotree_WindowLayout = 4

nmap <silent> <F11> :UndotreeToggle<cr>

" Enable persistent undo for most files. See :h persistent-undo for more info.
" This is actually a vim feature. But we keep the config in the undotree file
" as it is closely related.
" set undofile
" augroup dotfiles_undotree
"     autocmd!

"     autocmd BufWritePre /tmp/* setlocal noundofile
"     autocmd FileType gitcommit setlocal noundofile
" augroup END
