" Open quickfix entry in the last used window.
"
" See: https://vi.stackexchange.com/a/13377
nnoremap <buffer><CR> :exe 'wincmd p \| '.line('.').'cc'<CR>
