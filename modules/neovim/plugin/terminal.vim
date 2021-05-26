" ---------------------------------------------------------------------------
"
" Terminal
"
" ---------------------------------------------------------------------------
if exists('g:did_cfg_terminal')
    finish
endif
let g:did_cfg_terminal = 1

let $DOTFILES_PROTECT_VAR_PATH = 1

" Use <ESC> in Terminal mode and <C-v><ESC> to send <ESC> to a program in
" Terminal mode
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-v><Esc> <Esc>
endif

augroup dotfiles_terminal
    " Send q to the terminal even when in normal mode.
    autocmd TermOpen * nnoremap <buffer> q iq<C-\><C-n>
augroup END
