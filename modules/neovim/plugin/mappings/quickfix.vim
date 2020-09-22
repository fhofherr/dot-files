augroup dotfiles_quickfix
    autocmd!

    " Open quickfix entry in the last used window.
    "
    " See: https://vi.stackexchange.com/a/13377
    autocmd FileType qf nnoremap <buffer><cr> :exe 'wincmd p \| '.line('.').'cc'<cr>
augroup END
