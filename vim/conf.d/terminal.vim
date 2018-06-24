" ---------------------------------------------------------------------------
"
" Terminal
"
" ---------------------------------------------------------------------------

" Use <ESC> in Terminal mode and <C-v><ESC> to send <ESC> to a program in
" Terminal mode
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-v><Esc> <Esc>
endif
